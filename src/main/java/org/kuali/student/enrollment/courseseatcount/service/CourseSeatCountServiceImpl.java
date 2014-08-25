package org.kuali.student.enrollment.courseseatcount.service;

import org.apache.cxf.helpers.DOMUtils;
import org.apache.cxf.staxutils.StaxUtils;
import org.kuali.rice.core.api.criteria.QueryByCriteria;
import org.kuali.student.common.UUIDHelper;
import org.kuali.student.enrollment.courseoffering.service.CourseOfferingCallbackService;
import org.kuali.student.enrollment.courseoffering.service.cxf.CoSubscriptionPortType;
import org.kuali.student.enrollment.courseoffering.service.cxf.SOAPService;
import org.kuali.student.enrollment.courseseatcount.dto.CourseSeatCountInfo;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.common.dto.MetaInfo;
import org.kuali.student.r2.common.dto.StatusInfo;
import org.kuali.student.r2.common.dto.ValidationResultInfo;
import org.kuali.student.r2.common.exceptions.DataValidationErrorException;
import org.kuali.student.r2.common.exceptions.DoesNotExistException;
import org.kuali.student.r2.common.exceptions.InvalidParameterException;
import org.kuali.student.r2.common.exceptions.MissingParameterException;
import org.kuali.student.r2.common.exceptions.OperationFailedException;
import org.kuali.student.r2.common.exceptions.PermissionDeniedException;
import org.kuali.student.r2.common.exceptions.ReadOnlyException;
import org.kuali.student.r2.common.exceptions.VersionMismatchException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import javax.xml.namespace.QName;
import javax.xml.stream.XMLStreamException;
import javax.xml.ws.Endpoint;
import javax.xml.ws.wsaddressing.W3CEndpointReference;
import java.io.File;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Kuali Student Team
 */
public class CourseSeatCountServiceImpl implements CourseSeatCountService {
    private static final Logger log = LoggerFactory.getLogger(CourseSeatCountServiceImpl.class);
    private Map<String, CourseSeatCountInfo> courseSeatCountMap = new LinkedHashMap<String, CourseSeatCountInfo>();
    private static final QName SERVICE_NAME
            = new QName("http://apache.org/callback", "SOAPService");

    CourseOfferingCallbackService courseOfferingCallbackService;

    public void init() {

        String address = "http://localhost:9005/CallbackContext/COCallbackPort";
        Endpoint callbackEndpoint = Endpoint.publish(address, courseOfferingCallbackService);
        log.info("CourseSeatCountService published courseOfferingCallbackService UpdateActivityOfferings at address: " + address);

        InputStream is = CourseSeatCountServiceImpl.class.getResourceAsStream("/callback_infoset.xml");
        try {
            Document doc = StaxUtils.read(is);
            Element referenceParameters = (Element) DOMUtils.findChildWithAtt(doc.getDocumentElement(),
                    "wsa:ReferenceParameters",
                    "name", "");

            W3CEndpointReference ref = (W3CEndpointReference) callbackEndpoint.getEndpointReference(referenceParameters);

            URL wsdlURL;
            File wsdlFile = new File("/Users/jonrcook/intellij/sandbox/callback-poc/src/main/resources/basic_callback.wsdl");
            if (wsdlFile.exists()) {
                wsdlURL = wsdlFile.toURI().toURL();
            } else {
                wsdlURL = new URL("basic_callback.wsdl");
            }

            SOAPService ss = new SOAPService(wsdlURL, SERVICE_NAME);
            CoSubscriptionPortType port = ss.getSOAPPort();

            log.info("CourseSeatCountService subscribing to AO updates");
            port.subscribeToActivityOfferings(ref);
        } catch(XMLStreamException e) {
            throw new RuntimeException(e);
        } catch(MalformedURLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public CourseSeatCountInfo getCourseSeatCount(String courseSeatCountId, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        for(CourseSeatCountInfo courseSeatCountInfo : courseSeatCountMap.values()) {
            if(courseSeatCountInfo.getId().equals(courseSeatCountId)) {
                return courseSeatCountInfo;
            }
        }
        throw new RuntimeException("CourseSeatCount not found:" + courseSeatCountId);
    }

    @Override
    public List<CourseSeatCountInfo> getCourseSeatCountsByIds(List<String> courseSeatCountIds, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return null;
    }

    @Override
    public CourseSeatCountInfo getCourseSeatCountByActivityOffering(String activityOfferingId, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        if (!this.courseSeatCountMap.containsKey(activityOfferingId)) {
            throw new RuntimeException(activityOfferingId);
        }
        return this.courseSeatCountMap.get(activityOfferingId);
    }

    @Override
    public List<CourseSeatCountInfo> getSeatCountsByActivityOfferings(List<String> activityOfferingIds, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return null;
    }

    @Override
    public List<String> getCourseSeatCountIdsByType(String courseSeatCountTypeKey, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return null;
    }

    @Override
    public List<String> searchForCourseSeatCountIds(QueryByCriteria criteria, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return null;
    }

    @Override
    public List<CourseSeatCountInfo> searchForCourseSeatCounts(QueryByCriteria criteria, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return null;
    }

    @Override
    public List<ValidationResultInfo> validateCourseSeatCount(String validationTypeKey, String courseSeatCountTypeKey, CourseSeatCountInfo courseSeatCountInfo, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return null;
    }

    @Override
    public CourseSeatCountInfo createCourseSeatCount(String courseSeatCountTypeKey, CourseSeatCountInfo courseSeatCountInfo, ContextInfo contextInfo) throws DataValidationErrorException, DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException, ReadOnlyException {
        if (!courseSeatCountTypeKey.equals(courseSeatCountInfo.getTypeKey())) {
            throw new InvalidParameterException(
                    "The type parameter does not match the type on the info object");
        }
        CourseSeatCountInfo copy = new CourseSeatCountInfo(
                courseSeatCountInfo);
        if (copy.getId() == null) {
            copy.setId(UUIDHelper.genStringUUID());
        }
        copy.setMeta(newMeta(contextInfo));
        courseSeatCountMap.put(copy.getActivityOfferingId(), copy);
        return new CourseSeatCountInfo(copy);
    }

    @Override
    public CourseSeatCountInfo updateCourseSeatCount(String courseSeatCountId, CourseSeatCountInfo courseSeatCountInfo, ContextInfo contextInfo) throws DataValidationErrorException, DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException, ReadOnlyException, VersionMismatchException {
        if (!courseSeatCountId.equals(courseSeatCountInfo.getId())) {
            throw new InvalidParameterException(
                    "The id parameter does not match the id on the info object");
        }
        CourseSeatCountInfo copy = new CourseSeatCountInfo(
                courseSeatCountInfo);
        CourseSeatCountInfo old = this.getCourseSeatCount(
                courseSeatCountInfo.getId(), contextInfo);
        if (!old.getMeta().getVersionInd()
                .equals(copy.getMeta().getVersionInd())) {
            throw new VersionMismatchException(old.getMeta().getVersionInd());
        }
        copy.setMeta(updateMeta(copy.getMeta(), contextInfo));
        this.courseSeatCountMap.put(courseSeatCountInfo.getActivityOfferingId(), copy);
        return new CourseSeatCountInfo(copy);
    }

    @Override
    public StatusInfo deleteCourseSeatCount(String courseSeatCountId, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return null;
    }

    private MetaInfo newMeta(ContextInfo context) {
        MetaInfo meta = new MetaInfo();
        meta.setCreateId(context.getPrincipalId());
        meta.setCreateTime(new Date());
        meta.setUpdateId(context.getPrincipalId());
        meta.setUpdateTime(meta.getCreateTime());
        meta.setVersionInd("0");
        return meta;
    }

    private StatusInfo successStatus() {
        StatusInfo status = new StatusInfo();
        status.setSuccess(Boolean.TRUE);
        return status;
    }

    private StatusInfo failStatus() {
        StatusInfo status = new StatusInfo();
        status.setMessage("Operation Failed");
        status.setSuccess(Boolean.FALSE);
        return status;
    }

    private MetaInfo updateMeta(MetaInfo old, ContextInfo context) {
        MetaInfo meta = new MetaInfo(old);
        meta.setUpdateId(context.getPrincipalId());
        meta.setUpdateTime(new Date());
        meta.setVersionInd((Integer.parseInt(meta.getVersionInd()) + 1) + "");
        return meta;
    }

    public CourseOfferingCallbackService getCourseOfferingCallbackService() {
        return courseOfferingCallbackService;
    }

    public void setCourseOfferingCallbackService(CourseOfferingCallbackService courseOfferingCallbackService) {
        this.courseOfferingCallbackService = courseOfferingCallbackService;
    }
}
