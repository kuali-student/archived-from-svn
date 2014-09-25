package org.kuali.student.enrollment.registration.engine.node.impl;

import org.joda.time.DateTime;
import org.kuali.rice.core.api.resourceloader.GlobalResourceLoader;
import org.kuali.student.enrollment.courseregistration.dto.RegistrationRequestInfo;
import org.kuali.student.enrollment.courseregistration.dto.RegistrationRequestItemInfo;
import org.kuali.student.enrollment.courseregistration.infc.RegistrationRequest;
import org.kuali.student.enrollment.courseregistration.service.CourseRegistrationService;
import org.kuali.student.enrollment.lpr.dto.LprTransactionInfo;
import org.kuali.student.enrollment.lpr.dto.LprTransactionItemInfo;
import org.kuali.student.enrollment.lpr.service.LprService;
import org.kuali.student.enrollment.registration.engine.dto.RegistrationRequestEngineMessage;
import org.kuali.student.enrollment.registration.engine.node.AbstractCourseRegistrationNode;
import org.kuali.student.enrollment.registration.engine.processor.CourseRegistrationErrorProcessor;
import org.kuali.student.enrollment.registration.engine.util.NodePerformanceUtil;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.common.dto.ValidationResultInfo;
import org.kuali.student.r2.common.exceptions.DataValidationErrorException;
import org.kuali.student.r2.common.exceptions.DoesNotExistException;
import org.kuali.student.r2.common.exceptions.InvalidParameterException;
import org.kuali.student.r2.common.exceptions.MissingParameterException;
import org.kuali.student.r2.common.exceptions.OperationFailedException;
import org.kuali.student.r2.common.exceptions.PermissionDeniedException;
import org.kuali.student.r2.common.exceptions.ReadOnlyException;
import org.kuali.student.r2.common.exceptions.VersionMismatchException;
import org.kuali.student.r2.common.infc.Attribute;
import org.kuali.student.r2.common.util.constants.CourseRegistrationServiceConstants;
import org.kuali.student.r2.common.util.constants.LprServiceConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.xml.namespace.QName;
import java.util.ArrayList;
import java.util.List;

public class CourseRegistrationVerifyRegRequestNode extends AbstractCourseRegistrationNode<RegistrationRequestEngineMessage, RegistrationRequestEngineMessage> {

    public static final Logger LOG = LoggerFactory.getLogger(CourseRegistrationVerifyRegRequestNode.class);

    private static final int VERSION_MISMATCH_TRIES = 3;

    private CourseRegistrationService courseRegistrationService;
    private LprService lprService;
    private CourseRegistrationErrorProcessor courseRegistrationErrorProcessor;

    public CourseRegistrationService getCourseRegistrationService() {
        if (courseRegistrationService == null) {
            courseRegistrationService = GlobalResourceLoader.getService(CourseRegistrationServiceConstants.Q_NAME);
        }

        return courseRegistrationService;
    }

    public void setCourseRegistrationService(CourseRegistrationService courseRegistrationService) {
        this.courseRegistrationService = courseRegistrationService;
    }

    public LprService getLprService() {
        if (lprService == null) {
            lprService = GlobalResourceLoader.getService(new QName(LprServiceConstants.NAMESPACE,
                    LprServiceConstants.SERVICE_NAME_LOCAL_PART));
        }
        return lprService;
    }

    public void setLprService(LprService lprService) {
        this.lprService = lprService;
    }

    @Override
    public RegistrationRequestEngineMessage process(RegistrationRequestEngineMessage message) {

        DateTime startTime = new DateTime();

        RegistrationRequest regRequest = message.getRegistrationRequest();
        ContextInfo contextInfo = message.getContextInfo();
        contextInfo.setPrincipalId(regRequest.getRequestorId());
        List<ValidationResultInfo> validationResults = new ArrayList<>();
        Exception transactionException = null; // if an exception happens during processing we should fail the entire transaction
        try {
            validationResults.addAll(this.getCourseRegistrationService().verifyRegistrationRequestForSubmission(message.
                getRegistrationRequest().getId(), contextInfo));
        } catch (Exception ex) {
            transactionException = ex;
            LOG.error("Error during rules execution.", ex);
        }
        List<ValidationResultInfo> errors = this.getErrors(validationResults);
        List<ValidationResultInfo> warnings = this.getWarnings(validationResults);
        if (errors.isEmpty() && warnings.isEmpty() && transactionException == null) {
            DateTime endTime = new DateTime();
            NodePerformanceUtil.putStatistics("CourseRegistrationVerifyRegRequestNode", startTime, endTime);
            return message;
        }

        try {
            if (transactionException != null) {
                message = courseRegistrationErrorProcessor.processRequest(message); // roll back the entire transaction
            } else {
                // Get the current persisted transaction
                String lprTransactionId = regRequest.getId();
                LprTransactionInfo trans = getLprService().getLprTransaction(lprTransactionId, contextInfo);
                String version = trans.getMeta().getVersionInd();

                int tryCounter = 0;
                boolean keepTrying = true;
                while (keepTrying) {
                    //Update the warnings
                    updateLprTransactionWithWarnings(trans, warnings);

                    //Only set state to failed for non admin registration requests.
                    String stateKey = isAdminRegistration(regRequest) ? null : LprServiceConstants.LPRTRANS_ITEM_FAILED_STATE_KEY;

                    //Update the errors
                    updateLprTransactionWithErrors(trans, errors, stateKey);

                    //Check the current transaction version
                    LprTransactionInfo currentTrans = getLprService().getLprTransaction(lprTransactionId, contextInfo);
                    String currentVersion = currentTrans.getMeta().getVersionInd();
                    if (currentVersion.equals(version)) {
                        //Persist the updated transaction
                        getLprService().updateLprTransaction(lprTransactionId, trans, contextInfo);

                        // the operation above has changed the registration request. Pull from the database and update existing
                        // message.
                        RegistrationRequestInfo updatedRequestInfo = getCourseRegistrationService().getRegistrationRequest(trans.getId(), contextInfo);
                        updateRegRequestWithErrors(updatedRequestInfo, errors, stateKey);
                        message.setRegistrationRequest(updatedRequestInfo);
                        keepTrying = false;
                    } else {
                        tryCounter++;
                        if (tryCounter <= VERSION_MISMATCH_TRIES) {
                            LOG.warn("Versions do not match...attempting to update again. Version: {}. Current version: {}", version, currentVersion);
                            trans = currentTrans;
                            version = currentVersion;
                        } else {
                            throw new RuntimeException("Failed version mismatch check "+tryCounter+" times, unable to continue");
                        }
                    }
                }
            }

        } catch (Exception ex) {
            throw new RuntimeException("Error updating transaction with errors. ", ex);
        }

        DateTime endTime = new DateTime();
        NodePerformanceUtil.putStatistics("CourseRegistrationVerifyRegRequestNode", startTime, endTime);

        return message;

    }

    protected void updateLprTransactionWithWarnings(LprTransactionInfo trans, List<ValidationResultInfo> warnings)
            throws PermissionDeniedException, MissingParameterException, InvalidParameterException, OperationFailedException,
            DoesNotExistException, VersionMismatchException, DataValidationErrorException, ReadOnlyException {

        for (LprTransactionItemInfo item : trans.getLprTransactionItems()) {
            for (ValidationResultInfo warning : warnings) {
                //Match each warning with the corresponding id.
                String itemId = warning.getElement().replaceFirst("registrationRequestItems\\['([^']*)'\\]", "$1");
                if (item.getId().equals(itemId)) {
                    //Update the item with the warning validation state and result
                    item.getValidationResults().add(new ValidationResultInfo(warning));
                }
            }
        }
    }

    protected void updateLprTransactionWithErrors(LprTransactionInfo trans, List<ValidationResultInfo> errors,
                                                                String stateKey)
            throws PermissionDeniedException, MissingParameterException, InvalidParameterException, OperationFailedException,
            DoesNotExistException, VersionMismatchException, DataValidationErrorException, ReadOnlyException {

        for (LprTransactionItemInfo item : trans.getLprTransactionItems()) {
            for (ValidationResultInfo error : errors) {
                //Match each error with the corresponding id.
                String itemId = error.getElement().replaceFirst("registrationRequestItems\\['([^']*)'\\]", "$1");
                if (item.getId().equals(itemId)) {
                    //Remove any warnings
                    removeWarnings(item);
                    //Update the item with the failed validation state and result
                    item.getValidationResults().add(new ValidationResultInfo(error));
                    if (stateKey != null) {
                        item.setStateKey(stateKey);
                    }
                }
            }
        }
    }

    protected void removeWarnings(LprTransactionItemInfo item) {
        List<ValidationResultInfo> oldValidationResults = item.getValidationResults();
        List<ValidationResultInfo> newValidationResults = new ArrayList<>();
        for (ValidationResultInfo validationResultInfo: oldValidationResults) {
            if (!validationResultInfo.isWarn()) {
                newValidationResults.add(validationResultInfo);
            }
        }
        item.setValidationResults(newValidationResults);
    }

    protected void updateRegRequestWithErrors(RegistrationRequestInfo updatedRequestInfo, List<ValidationResultInfo> errors,
                                              String stateKey) {
        for (ValidationResultInfo error : errors) {
            //Match each error with the corresponding id.
            String itemId = error.getElement().replaceFirst("registrationRequestItems\\['([^']*)'\\]", "$1");
            for (RegistrationRequestItemInfo requestItem : updatedRequestInfo.getRegistrationRequestItems()) {
                if (requestItem.getId().equals(itemId)) {
                    requestItem.getValidationResults().add(new ValidationResultInfo(error));
                    if (stateKey != null) {
                        requestItem.setStateKey(stateKey);
                    }
                }
            }
        }
    }

    protected boolean isAdminRegistration(RegistrationRequest regRequest) {
        // TODO: KSENROLL-13911 - This is only a temporary check while functionality is analyzed.
        // Check for admin user override (allow)
        for (Attribute attr : regRequest.getAttributes()) {
            if (attr.getKey().equals(CourseRegistrationServiceConstants.ELIGIBILITY_OVERRIDE_TYPE_KEY_ATTR)) {
                if (Boolean.valueOf(attr.getValue())) {
                    return true;
                }
            }
        }
        return false;
    }

    private List<ValidationResultInfo> getErrors(List<ValidationResultInfo> results) {
        List<ValidationResultInfo> errors = new ArrayList<>();
        for (ValidationResultInfo vr : results) {
            if (vr.isError()) {
                errors.add(vr);
            }
        }
        return errors;
    }

    private List<ValidationResultInfo> getWarnings(List<ValidationResultInfo> results) {
        List<ValidationResultInfo> warnings = new ArrayList<>();
        for (ValidationResultInfo vr : results) {
            if (vr.isWarn()) {
                warnings.add(vr);
            }
        }
        return warnings;
    }

    public void setCourseRegistrationErrorProcessor(CourseRegistrationErrorProcessor courseRegistrationErrorProcessor) {
        this.courseRegistrationErrorProcessor = courseRegistrationErrorProcessor;
    }
}
