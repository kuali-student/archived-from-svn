/**
 * Copyright 2014 The Kuali Foundation Licensed under the
 * Educational Community License, Version 2.0 (the "License"); you may
 * not use this file except in compliance with the License. You may
 * obtain a copy of the License at
 *
 * http://www.osedu.org/licenses/ECL-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an "AS IS"
 * BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 *
 * Created by prasannag on 1/9/14
 */
package org.kuali.student.cm.course.controller;

import org.apache.commons.lang.StringUtils;
import org.kuali.rice.core.api.criteria.PredicateFactory;
import org.kuali.rice.core.api.criteria.QueryByCriteria;
import org.kuali.rice.core.api.resourceloader.GlobalResourceLoader;
import org.kuali.rice.core.api.util.RiceKeyConstants;
import org.kuali.rice.kew.api.KewApiConstants;
import org.kuali.rice.kew.api.exception.WorkflowException;
import org.kuali.rice.krad.service.KRADServiceLocatorWeb;
import org.kuali.rice.krad.uif.UifConstants;
import org.kuali.rice.krad.util.GlobalVariables;
import org.kuali.rice.krad.util.KRADConstants;
import org.kuali.rice.krad.util.ObjectUtils;
import org.kuali.rice.krad.web.controller.MethodAccessible;
import org.kuali.rice.krad.web.form.DocumentFormBase;
import org.kuali.rice.krad.web.form.MaintenanceDocumentForm;
import org.kuali.student.cm.common.util.CurriculumManagementConstants;
import org.kuali.student.cm.course.form.RecentlyViewedDocsUtil;
import org.kuali.student.cm.course.form.wrapper.RetireCourseWrapper;
import org.kuali.student.cm.course.service.RetireCourseMaintainable;
import org.kuali.student.cm.course.util.CourseProposalUtil;
import org.kuali.student.common.collection.KSCollectionUtils;
import org.kuali.student.common.object.KSObjectUtils;
import org.kuali.student.common.util.security.ContextUtils;
import org.kuali.student.r2.common.dto.DtoConstants;
import org.kuali.student.r2.common.dto.ValidationResultInfo;
import org.kuali.student.r2.core.atp.dto.AtpInfo;
import org.kuali.student.r2.core.atp.service.AtpService;
import org.kuali.student.r2.core.constants.AtpServiceConstants;
import org.kuali.student.r2.lum.course.dto.CourseInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.namespace.QName;
import java.util.Collections;
import java.util.List;

/**
 * This controller handles all the requests from the 'Retire Course' UI
 *
 * @author Kuali Student Team
 */

@Controller
@RequestMapping(value = CurriculumManagementConstants.ControllerRequestMappings.CM_RETIRE_COURSE)
public class RetireCourseController extends CourseController {
    private static final Logger LOG = LoggerFactory.getLogger(RetireCourseController.class);

    private transient AtpService atpService;

    @Override
    protected MaintenanceDocumentForm createInitialForm(HttpServletRequest request) {
        MaintenanceDocumentForm form = new MaintenanceDocumentForm();

        String useReviewProcessParam = request.getParameter(CurriculumManagementConstants.UrlParams.USE_CURRICULUM_REVIEW);
        // only do the manually setup of the MaintenanceDocumentForm fields if the USE_CURRICULUM_REVIEW param was passed in from initial view
        if (StringUtils.isNotBlank(useReviewProcessParam)) {
            Boolean isUseReviewProcess = Boolean.valueOf(useReviewProcessParam);
            form.setDocTypeName(getDocumentTypeNameForProposal(isUseReviewProcess, request));
        }

        form.getExtensionData().put(CurriculumManagementConstants.Export.UrlParams.EXPORT_TYPE, CurriculumManagementConstants.Export.FileType.PDF);

        return form;
    }

    protected String getDocumentTypeNameForProposal(Boolean isUseReviewProcess, HttpServletRequest request) {
        // throw an exception if the user is not a CS user but attempts to disable Curriculum Review for a proposal
        if (!isUseReviewProcess && !CourseProposalUtil.isUserCurriculumSpecialist()) {
            throw new RuntimeException(String.format("User (%s) is not allowed to disable Curriculum Review (Workflow Approval).",
                    GlobalVariables.getUserSession().getPerson().getPrincipalName()));
        }
        // set the doc type name based on the whether the user is CS and if they have chosen to use curriculum review
        return ((!isUseReviewProcess)
                ? CurriculumManagementConstants.DocumentTypeNames.CourseProposal.COURSE_RETIRE_ADMIN
                : CurriculumManagementConstants.DocumentTypeNames.CourseProposal.COURSE_RETIRE);
    }

    /**
     * Digs the CourseInfoWrapper out of DocumentFormBase.
     *
     * @param form The DocumentFormBase.
     * @return The CourseInfoWrapper.
     */
    protected RetireCourseWrapper getRetireCourseWrapper(DocumentFormBase form) {
        return ((RetireCourseWrapper) ((MaintenanceDocumentForm) form).getDocument().getNewMaintainableObject().getDataObject());
    }

    /**
     * Overridden because we needed a point at which the form is loaded with the document before we can initialize some
     * form fields. This method is used for when a new document is created.
     *
     * @param form - form instance that contains the doc type parameter and where
     *             the new document instance should be set
     */
    @Override
    protected void createDocument(DocumentFormBase form) throws WorkflowException {
        super.createDocument(form);
        String[] courseIdArray = form.getInitialRequestParameters().get(CurriculumManagementConstants.UrlParams.CLU_ID);
        if ((courseIdArray == null) || (courseIdArray.length != 1)) {
            throw new RuntimeException("Cannot perform retire if no course id is provided");
        }
        RetireCourseWrapper courseWrapper = getRetireCourseWrapper(form);
        String courseId = courseIdArray[0];
        courseWrapper.getProposalInfo().getProposalReference().add(courseId);
        courseWrapper.getProposalInfo().setProposalReferenceType(((RetireCourseMaintainable)((MaintenanceDocumentForm)form).getDocument().getNewMaintainableObject()).getProposalReferenceType());
        try {
            CourseInfo course = getCourseService().getCourse(courseId, ContextUtils.createDefaultContextInfo());
            courseWrapper.setCourseInfo(course);
            courseWrapper.getProposalInfo().setName("Retire: " + course.getCourseTitle());
            courseWrapper.setRetireStartTerm(getTermDesc(course.getStartTerm()));
        } catch (Exception e) {
            throw new RuntimeException("Could not fetch course", e);
        }
    }

    /**
     * This will approve and retire an admin retire proposal.
     *
     * @param form     {@link MaintenanceDocumentForm} instance used for this action
     * @param result
     * @param request  {@link HttpServletRequest} instance of the actual HTTP request made
     * @param response The intended {@link HttpServletResponse} sent back to the user
     * @return The {@link ModelAndView} that contains the newly updated {@CourseInfo} and {@ProposalInfo} information.
     */
    @RequestMapping(params = "methodToCall=approveAndRetire")
    public ModelAndView approveAndRetire(@ModelAttribute("KualiForm") DocumentFormBase form, BindingResult result,
                                         HttpServletRequest request, HttpServletResponse response) throws Exception {
        RetireCourseWrapper retireCourseWrapper = getRetireCourseWrapper(form);

        doValidationForProposal(form, KewApiConstants.ROUTE_HEADER_PROCESSED_CD, DtoConstants.STATE_RETIRED);
        if (!GlobalVariables.getMessageMap().hasErrors()) {
//            super.blanketApprove(form, result, request, response);
            // cannot call super class method as the redirect methods are causing an error when loading indicator is used after dialog confirmation is clicked
            performWorkflowAction(form, UifConstants.WorkflowAction.BLANKETAPPROVE, true);

            // Set the request redirect to false so that the user stays on the same page
            form.setRequestRedirected(false);
            // Hide all the workflow action buttons on the review proposal page while the document is still in Enroute state(It is being processed at the back-end)
            retireCourseWrapper.getUiHelper().setPendingWorkflowAction(true);
            //redirect back to client to display confirm dialog
            return getUIFModelAndView(form, getReviewPageKradPageId());
        } else {
            return getUIFModelAndView(form);
        }
    }

    /**
         * This will save the Course Proposal.
         *
         * @param form     {@link MaintenanceDocumentForm} instance used for this action
         * @param result
         * @param request  {@link HttpServletRequest} instance of the actual HTTP request made
         * @param response The intended {@link HttpServletResponse} sent back to the user
         * @return The new {@link ModelAndView} that contains the newly created/updated {@CourseInfo} and {@ProposalInfo} information.
         */
        @Override
        @RequestMapping(method = RequestMethod.POST, params = "methodToCall=saveProposal")
        public ModelAndView saveProposal(@ModelAttribute("KualiForm") MaintenanceDocumentForm form, BindingResult result,
                HttpServletRequest request, HttpServletResponse response) throws Exception {

            RetireCourseWrapper courseWrapper = getRetireCourseWrapper(form);
            form.getDocument().getDocumentHeader().setDocumentDescription(courseWrapper.getProposalInfo().getName());

            ModelAndView modelAndView;

            modelAndView = save(form, result, request, response);

            if (GlobalVariables.getMessageMap().hasErrors()) {
                return modelAndView;
            }

            RecentlyViewedDocsUtil.addRecentDoc(form.getDocument().getDocumentHeader().getDocumentDescription(),
                    form.getDocument().getDocumentHeader().getWorkflowDocument().getDocumentHandlerUrl() + "&"
                            + KewApiConstants.COMMAND_PARAMETER + "="
                            + KewApiConstants.DOCSEARCH_COMMAND + "&"
                            + KewApiConstants.DOCUMENT_ID_PARAMETER + "="
                            + form.getDocument().getDocumentHeader().getWorkflowDocument().getDocumentId());

            String nextOrCurrentPage = form.getActionParameters().get("displayPage");

            if (StringUtils.equalsIgnoreCase(nextOrCurrentPage, "NEXT")) {
                CurriculumManagementConstants.CourseRetireSections currentSection = (CurriculumManagementConstants.CourseRetireSections)courseWrapper.getUiHelper().getSelectedSection();
                if (currentSection.ordinal() < CurriculumManagementConstants.CourseRetireSections.values().length) {
                    CurriculumManagementConstants.CourseRetireSections nextSection = CurriculumManagementConstants.CourseRetireSections.values()[currentSection.ordinal() + 1];
                    courseWrapper.getUiHelper().setSelectedSection(nextSection);
                }
                return getUIFModelAndView(form);
            } else if (StringUtils.equalsIgnoreCase(nextOrCurrentPage, "CM-Proposal-Course-Retire-ReviewProposalLink")) {
                return getUIFModelAndView(form, getReviewPageKradPageId());
            } else {
                return getUIFModelAndView(form);
            }
        }

    /**
     * Returns the KRAD pageId that will be used for the Review Page display
     */
    protected String getReviewPageKradPageId() {
        return CurriculumManagementConstants.CoursePageIds.REVIEW_RETIRE_COURSE_PROPOSAL_PAGE;
    }

    /**
     * Method that will run the Kuali student course service validation.
     *
     * @param form - the form of the current users session
     * @param forcedCourseStateKey - the stateKey that needs to be faked for the CourseService.validationCourse() method (if null, uses state in CourseInfo object)
     * @return a list of errors from the CourseService validation method if it was properly executed and errors were found
     */
    protected List<ValidationResultInfo> runCourseServiceValidation(DocumentFormBase form, String forcedCourseStateKey) {
        RetireCourseWrapper retireCourseWrapper = getRetireCourseWrapper(form);
        try {
            //Perform Service Layer Data Dictionary validation
            CourseInfo courseInfoToValidate = (CourseInfo) ObjectUtils.deepCopy(retireCourseWrapper.getCourseInfo());
            if (StringUtils.isNotBlank(forcedCourseStateKey)) {
                courseInfoToValidate.setStateKey(forcedCourseStateKey);
            }
            return getCourseService().validateCourse("OBJECT", courseInfoToValidate, ContextUtils.createDefaultContextInfo());
        } catch (Exception ex) {
            LOG.error("Error occurred while performing service layer validation for Submit", ex);
            GlobalVariables.getMessageMap().putError(KRADConstants.GLOBAL_ERRORS, RiceKeyConstants.ERROR_CUSTOM, KSObjectUtils.unwrapException(20, ex).getMessage());
            retireCourseWrapper.getReviewProposalDisplay().setShowUnknownErrors(true);
        }
        return Collections.EMPTY_LIST;
    }

    public ModelAndView copyProposal(@ModelAttribute("KualiForm") DocumentFormBase form) {
        throw new RuntimeException("Cannot copy a Retire Proposal");
    }

    @MethodAccessible
    @RequestMapping(params = "methodToCall=reviewCourseProposal")
    public ModelAndView reviewCourseProposal(@ModelAttribute("KualiForm") DocumentFormBase form, BindingResult result,
                                             HttpServletRequest request, HttpServletResponse response) throws Exception {

        ((RetireCourseMaintainable) ((MaintenanceDocumentForm) form).getDocument().getNewMaintainableObject()).updateReview();

        //  Validate
        RetireCourseWrapper wrapper = getRetireCourseWrapper(form);
        KRADServiceLocatorWeb.getViewValidationService().validateViewAgainstNextState(form);
        if (GlobalVariables.getMessageMap().hasErrors()) {
            wrapper.setMissingRequiredFields(true);
        } else
        {
            wrapper.setMissingRequiredFields(false);
        }
        return getUIFModelAndView(form, CurriculumManagementConstants.CoursePageIds.REVIEW_RETIRE_COURSE_PROPOSAL_PAGE);
    }

    private String getTermDesc(String term) {

        String result = "";

        if (StringUtils.isNotEmpty(term)) {

            QueryByCriteria.Builder qbcBuilder = QueryByCriteria.Builder.create();
            qbcBuilder.setPredicates(PredicateFactory.in("id", term));

            QueryByCriteria qbc = qbcBuilder.build();
            try {

                List<AtpInfo> searchResult = getAtpService().searchForAtps(qbc, ContextUtils.createDefaultContextInfo());

                AtpInfo atpInfo = KSCollectionUtils.getOptionalZeroElement(searchResult);

                if (atpInfo != null) {
                    result = atpInfo.getName();
                }

            } catch (Exception ex) {
                throw new RuntimeException("Could not retrieve description of Term \"" + term + "\" : " + ex);
            }
        }

        return result;
    }

    protected AtpService getAtpService() {
        if (atpService == null) {
            QName qname = new QName(AtpServiceConstants.NAMESPACE, AtpServiceConstants.SERVICE_NAME_LOCAL_PART);
            atpService = (AtpService) GlobalResourceLoader.getService(qname);
        }
        return atpService;
    }

    /**
     * Load the course retire proposal review page
     */
    @Override
    @RequestMapping(params = "methodToCall=editCourseProposalPage")
    public ModelAndView editCourseProposalPage(@ModelAttribute("KualiForm") DocumentFormBase form, BindingResult result,
                                               HttpServletRequest request, HttpServletResponse response) throws Exception {

        String displaySectionId = form.getActionParameters().get("displaySection");
        RetireCourseWrapper wrapper = getRetireCourseWrapper(form);

        if (displaySectionId == null) {
            wrapper.getUiHelper().setSelectedSection(CurriculumManagementConstants.CourseRetireSections.RETIRE_INFO);
        } else {
            CurriculumManagementConstants.CourseRetireSections section = CurriculumManagementConstants.CourseRetireSections.getSection(displaySectionId);
            wrapper.getUiHelper().setSelectedSection(section);
        }

        return getUIFModelAndView(form, CurriculumManagementConstants.CoursePageIds.RETIRE_COURSE_PAGE);
    }
}
