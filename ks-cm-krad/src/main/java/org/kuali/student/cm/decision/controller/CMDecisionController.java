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
 * Created by venkat on 7/28/14
 */
package org.kuali.student.cm.decision.controller;

import org.apache.commons.lang.StringUtils;
import org.kuali.rice.core.api.resourceloader.GlobalResourceLoader;
import org.kuali.rice.krad.web.controller.KsUifControllerBase;
import org.kuali.rice.krad.web.controller.MethodAccessible;
import org.kuali.rice.krad.web.form.UifFormBase;
import org.kuali.student.cm.common.util.CurriculumManagementConstants;
import org.kuali.student.cm.decision.form.CMDecisionForm;
import org.kuali.student.cm.decision.form.wrapper.CMDecisionWrapper;
import org.kuali.student.common.util.security.ContextUtils;
import org.kuali.student.r1.common.rice.StudentIdentityConstants;
import org.kuali.student.r1.core.personsearch.service.impl.QuickViewByGivenName;
import org.kuali.student.r2.common.util.date.DateFormatters;
import org.kuali.student.r2.core.class1.type.service.TypeService;
import org.kuali.student.r2.core.comment.dto.CommentInfo;
import org.kuali.student.r2.core.comment.service.CommentService;
import org.kuali.student.r2.core.constants.CommentServiceConstants;
import org.kuali.student.r2.core.constants.ProposalServiceConstants;
import org.kuali.student.r2.core.constants.TypeServiceConstants;
import org.kuali.student.r2.core.proposal.dto.ProposalInfo;
import org.kuali.student.r2.core.proposal.service.ProposalService;
import org.kuali.student.r2.core.search.dto.SearchParamInfo;
import org.kuali.student.r2.core.search.dto.SearchRequestInfo;
import org.kuali.student.r2.core.search.dto.SearchResultCellInfo;
import org.kuali.student.r2.core.search.dto.SearchResultInfo;
import org.kuali.student.r2.core.search.dto.SearchResultRowInfo;
import org.kuali.student.r2.core.search.service.SearchService;
import org.kuali.student.r2.lum.util.constants.CourseServiceConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.namespace.QName;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Kuali Student Team
 */

@Controller
@RequestMapping(value = CurriculumManagementConstants.ControllerRequestMappings.CM_DECISION)
public class CMDecisionController extends KsUifControllerBase {

    private static final Logger LOG = LoggerFactory.getLogger(CMDecisionController.class);

    protected CommentService commentService;
    protected ProposalService proposalService;
    protected TypeService typeService;

    @Override
    protected UifFormBase createInitialForm(HttpServletRequest request) {
        return new CMDecisionForm();
    }

    @MethodAccessible
    @RequestMapping(params = "methodToCall=start")
    public ModelAndView start(@ModelAttribute("KualiForm") UifFormBase form, HttpServletRequest request,
                              HttpServletResponse response) {

        CMDecisionForm decisionForm = (CMDecisionForm) form;

        String proposalId = request.getParameter("proposalId");

        if (StringUtils.isBlank(proposalId)) {
            throw new RuntimeException("Missing proposal Id");
        }

        try {
            ProposalInfo proposalInfo = getProposalService().getProposal(proposalId, ContextUtils.createDefaultContextInfo());
            decisionForm.setProposal(proposalInfo);
            retrieveDecisions(decisionForm);
        } catch (Exception e) {
            throw new RuntimeException("Invalid Proposal [id=" + proposalId + "]");
        }

//        CMDecisionWrapper test = new CMDecisionWrapper();
//        test.setActor("Test user1");
//        test.setDate("01/01/2014");
//        test.setDecision("Accept");
//        test.setRationale("this is a test");
//        decisionForm.getDecisions().add(test);
//
//        test = new CMDecisionWrapper();
//        test.setActor("Test user2");
//        test.setDate("11/01/2014");
//        test.setDecision("Accept");
//        test.setRationale("You can create proposals from scratch (called a blank) or you can (Not yet implemented: start by copying one from an existing approved course or active course proposal.) You can copy a proposal using the Create a Course action link on CM Home, (or through the Copy to New Proposal option on the Review Proposal page. Copied proposals include pre-populated data from the source course or proposal.) ");
//        decisionForm.getDecisions().add(test);
//
//        test = new CMDecisionWrapper();
//        test.setActor("Test user3");
//        test.setDate("11/01/2014");
//        test.setDecision("Reject");
//        test.setRationale("This How-To-Guide details the Create a Course functionality for both the Faculty/Staff and the Curriculum Specialist (CS) roles (fred and alice, respectively). Every new course starts as a proposal, either a Credit Course Proposal or a Credit Course Admin Proposal doc type. Credit Course Proposals go through a curriculum review process (workflow) to be Approved or R");
//        decisionForm.getDecisions().add(test);

        retrieveDecisions(decisionForm);

        return super.start(form, request, response);
    }

    protected Map<String,String> getUsers(List<String> userIds){

        Map<String,String> results = new HashMap<>();

        SearchParamInfo personIdParam = new SearchParamInfo();
        personIdParam.setKey(QuickViewByGivenName.ID_PARAM);
        personIdParam.getValues().addAll(userIds);
        List<SearchParamInfo> queryParamValueList = new ArrayList<SearchParamInfo>();
        queryParamValueList.add(personIdParam);

        SearchRequestInfo searchRequest = new SearchRequestInfo();
        searchRequest.setSearchKey(QuickViewByGivenName.SEARCH_TYPE);
        searchRequest.setParams(queryParamValueList);
        searchRequest.setStartAt(0);
        searchRequest.setNeededTotalResults(false);
        searchRequest.setSortColumn(QuickViewByGivenName.DISPLAY_NAME_RESULT);

        SearchResultInfo searchResult = null;
        try {
            SearchService searchService = GlobalResourceLoader.getService(new QName(CourseServiceConstants.NAMESPACE_PERSONSEACH, CourseServiceConstants.PERSONSEACH_SERVICE_NAME_LOCAL_PART));
            searchResult = searchService.search(searchRequest, ContextUtils.createDefaultContextInfo());

            for (SearchResultRowInfo result : searchResult.getRows()) {

                List<SearchResultCellInfo> cells = result.getCells();

                String displayName = "";
                String userId = "";

                for (SearchResultCellInfo cell : cells) {

                    if (QuickViewByGivenName.PERSON_ID_RESULT.equals(cell.getKey())) {
                        userId = cell.getValue();
                    } else if (QuickViewByGivenName.GIVEN_NAME_RESULT.equals(cell.getKey())) {
                        displayName = cell.getValue();
                    }
                }

                if (StringUtils.isNotBlank(displayName) && StringUtils.isNotBlank(userId)){
                    results.put(userId,displayName);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error getting decision user names",e);
        }

        return results;

    }

    protected void retrieveDecisions(CMDecisionForm form) {

        ProposalInfo proposal = form.getProposal();

        LOG.debug("Retrieving decisions for  - " + proposal.getId());

        List<CommentInfo> decisions;

        form.getDecisions().clear();

        try {
            decisions = getCommentService().getCommentsByRefObject(proposal.getId(), StudentIdentityConstants.QUALIFICATION_PROPOSAL_REF_TYPE, ContextUtils.createDefaultContextInfo());
        } catch (Exception e) {
            throw new RuntimeException("Error retrieving decision(s) for the proposal [id=" + proposal.getId() + "]", e);
        }

        List userIds = new ArrayList<>();

        for (CommentInfo comment : decisions) {
//            if (ArrayUtils.contains(CommentServiceConstants.ALL_WORKFLOW_COMMENT,comment.getTypeKey())){
                CMDecisionWrapper wrapper = new CMDecisionWrapper(comment);
                wrapper.setActor(comment.getCommenterId());
                userIds.add(comment.getCommenterId());
                wrapper.setDate(DateFormatters.COURSE_OFFERING_VIEW_HELPER_DATE_TIME_FORMATTER.format(comment.getMeta().getCreateTime()));
                wrapper.setDecision(comment.getTypeKey());
                wrapper.setRationale(comment.getCommentText().getPlain());
                form.getDecisions().add(wrapper);
//            }
        }

        Map<String,String> personId2DisplayName = getUsers(userIds);

        for (CMDecisionWrapper wrapper : form.getDecisions()) {
            String displayName = personId2DisplayName.get(wrapper.getActor());
            wrapper.setActor(displayName);
        }

        LOG.debug("There are " + form.getDecisions().size() + " decisions for proposal " + proposal.getId());

        Collections.sort(form.getDecisions());
    }

    protected CommentService getCommentService() {
        if (commentService == null) {
            commentService = (CommentService) GlobalResourceLoader.getService(new QName(CommentServiceConstants.NAMESPACE, CommentService.class.getSimpleName()));
        }
        return commentService;
    }

    protected ProposalService getProposalService() {
        if (proposalService == null) {
            proposalService = (ProposalService) GlobalResourceLoader.getService(new QName(ProposalServiceConstants.NAMESPACE, ProposalServiceConstants.SERVICE_NAME_LOCAL_PART));
        }
        return proposalService;
    }

    protected TypeService getTypeService() {
        if (typeService == null) {
            typeService = (TypeService) GlobalResourceLoader.getService(new QName(TypeServiceConstants.NAMESPACE, TypeServiceConstants.SERVICE_NAME_LOCAL_PART));
        }

        return typeService;
    }
}