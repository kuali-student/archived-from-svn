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
 * Created by delyea on 3/18/14
 */
package org.kuali.student.cm.course.util;

import org.apache.commons.lang.StringUtils;
import org.kuali.rice.krad.uif.UifConstants;
import org.kuali.rice.krad.uif.UifParameters;
import org.kuali.rice.krad.util.KRADConstants;
import org.kuali.rice.krad.util.UrlFactory;
import org.kuali.rice.krms.dto.AgendaEditor;
import org.kuali.rice.krms.dto.PropositionEditor;
import org.kuali.rice.krms.dto.RuleEditor;
import org.kuali.student.cm.common.util.CMUtils;
import org.kuali.student.cm.common.util.CurriculumManagementConstants;
import org.kuali.student.cm.course.form.wrapper.CourseInfoWrapper;
import org.kuali.student.cm.course.form.wrapper.RetireCourseWrapper;
import org.kuali.student.cm.proposal.util.ProposalUtil;
import org.kuali.student.common.util.security.ContextUtils;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.common.dto.DtoConstants;
import org.kuali.student.r2.core.search.dto.SearchRequestInfo;
import org.kuali.student.r2.core.search.dto.SearchResultInfo;
import org.kuali.student.r2.core.versionmanagement.dto.VersionDisplayInfo;
import org.kuali.student.r2.lum.course.dto.CourseInfo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import static org.kuali.student.r1.lum.course.service.CourseServiceConstants.COURSE_NAMESPACE_URI;

/**
 * This class is a Util class designed to hold common course proposal related code that should be shared across multiple classes
 *
 * @author Kuali Student Team
 */
public class CourseProposalUtil {

    /**
     * Constructs a text URL for a particular course proposal.
     */
    public static String buildCourseProposalUrl(String methodToCall, String pageId, String workflowDocId, String proposalType) {
        Properties props = ProposalUtil.getProposalUrlProperties(methodToCall, pageId, workflowDocId);
        if (CurriculumManagementConstants.CoursePageIds.REVIEW_RETIRE_COURSE_PROPOSAL_PAGE.equals(pageId)) {
            props.put(UifParameters.DATA_OBJECT_CLASS_NAME, RetireCourseWrapper.class.getCanonicalName());
        } else {
            props.put(UifParameters.DATA_OBJECT_CLASS_NAME, CourseInfoWrapper.class.getCanonicalName());
        }
        String controllerRequestMapping = CurriculumManagementConstants.ControllerRequestMappings.MappingsByProposalType.getControllerMapping(proposalType);
        if (StringUtils.isBlank(controllerRequestMapping)) {
            throw new RuntimeException("Cannot find request mapping for proposal type: " + proposalType);
        }
        String courseBaseUrl = controllerRequestMapping.replaceFirst("/", "");
        return UrlFactory.parameterizeUrl(courseBaseUrl, props);
    }

    /**
     * Constructs the url for view course for redirect from retire course page.
     */
    public static String getViewCourseUrl(){

        String cmViewCourseControllerMapping = CurriculumManagementConstants.ControllerRequestMappings.VIEW_COURSE.replaceFirst("/", "");

        StringBuilder cmViewCourseUrl = new StringBuilder(cmViewCourseControllerMapping);
        cmViewCourseUrl.append("?" + KRADConstants.DISPATCH_REQUEST_PARAMETER + "=").append(KRADConstants.START_METHOD);
        cmViewCourseUrl.append("&" + UifConstants.UrlParams.VIEW_ID + "=").append(CurriculumManagementConstants.CourseViewIds.VIEW_COURSE_VIEW);

        return cmViewCourseUrl.toString();
    }

    public static CourseInfo getCurrentVersionOfCourse(String versionIndId,ContextInfo contextInfo) throws Exception {

        // Get id of current version of course given the version independent id
        VersionDisplayInfo curVerDisplayInfo = CMUtils.getCourseService().getCurrentVersion(COURSE_NAMESPACE_URI, versionIndId, contextInfo);
        String curVerId = curVerDisplayInfo.getId();

        // Return the current version of the course
        CourseInfo currVerCourse = CMUtils.getCourseService().getCourse(curVerId,contextInfo);

        return currVerCourse;
    }

    /**
     * Checks if the Course is modifiable. A Course is modifiable if:
     * - it is the 'current' version
     * - There is no later version in either 'DRAFT' or 'SUPERSEDED' states
     * @param courseInfo
     * @param contextInfo
     * @return
     * @throws Exception
     */
    public static boolean isModifiableCourse(CourseInfo courseInfo, ContextInfo contextInfo) throws Exception {

        // If this is not 'current' course, return 'false' immediately
        if(!isCurrentVersionOfCourse(courseInfo, contextInfo)) {
            return false;
        }

        String versionIndId = courseInfo.getVersion().getVersionIndId();
        Long versionSequenceNumber = courseInfo.getVersion().getSequenceNumber();

        SearchRequestInfo request = new SearchRequestInfo("lu.search.isVersionable");
        request.addParam("lu.queryParam.versionIndId", versionIndId);
        request.addParam("lu.queryParam.sequenceNumber", versionSequenceNumber.toString());
        List<String> states = new ArrayList<String>();
        states.add(DtoConstants.STATE_DRAFT);
        states.add(DtoConstants.STATE_SUPERSEDED);
        request.addParam("lu.queryParam.luOptionalState", states);
        SearchResultInfo result = CMUtils.getCluService().search(request, contextInfo);

        String resultString = result.getRows().get(0).getCells().get(0).getValue();
        return "0".equals(resultString);
    }

    public static boolean isCurrentVersionOfCourse(CourseInfo course, ContextInfo contextInfo) throws Exception {
        String courseId = course.getId();
        String verIndId = course.getVersion().getVersionIndId();

        // Get id of current version of course given the version independent id
        VersionDisplayInfo currentVersion = CMUtils.getCourseService().getCurrentVersion(COURSE_NAMESPACE_URI, verIndId, contextInfo);

        return currentVersion.getId().equals(courseId) ? true : false;
    }

    /**
     * We can only have one retire proposal in workflow at a time.  This method
     * will call the proposal webservice and run a custom search that will look
     * for any retire proposals that are in the saved or enroute state.  A
     * count is returned and, if the count is > 0, this method will return false.
     */
    public static boolean hasInProgressProposalForCourse(CourseInfo courseInfo) throws Exception {

        if (courseInfo == null) {
            throw new RuntimeException("Cannot verify if retire proposal can be created without valid course");
        }
        // Fill the request with the key to identify the search
        SearchRequestInfo request = new SearchRequestInfo("proposal.search.countForProposals");

        // Add search parms.  In this case, we will use the cluId of the course
        // we are trying to retire
        request.addParam("proposal.queryParam.cluId", courseInfo.getId());

        // Perform search and get the result
        SearchResultInfo result = CMUtils.getProposalService().search(request, ContextUtils.getContextInfo());
        String resultString = result.getRows().get(0).getCells().get(0).getValue();

        // If there are no retire proposals enroute or in saved status/
        // return false, else return true
        return !("0".equals(resultString));
    }

    /**
     * Rule editor key mappings used in isRequisitesEqual().
     */
    private static final Map<String,String> ruleEditorKeyMapping = new HashMap() {
        {   put("A", "G");
            put("B", "H");
            put("C", "I");
            put("D", "J");
            put("E", "K");
            put("F", "L");
            put("G", "A");
            put("H", "B");
            put("I", "C");
            put("J", "D");
            put("K", "E");
            put("L", "F");}
    };

    /**
     * Compares requisites by natural language. Assumes that the rule editor keys used are A-F or G-L, and that they
     * are consistently in the same order alphabetically by key and by type: prereq, coreq, recommended, etc.
     * @return True if the requisites are the same. Otherwise, false.
     */
    public static boolean isRequisitesEqual(final List<AgendaEditor> leftAgendas, final List<AgendaEditor> rightAgendas) {
        /*
         * Put all of the rule editors from each agenda in a single map per side.
         */
        Map<String, RuleEditor> leftRuleEditors = new HashMap<>();
        Map<String, RuleEditor> rightRuleEditors = new HashMap<>();

        for (AgendaEditor ae : leftAgendas) {
            leftRuleEditors.putAll(ae.getRuleEditors());
        }

        for (AgendaEditor ae : rightAgendas) {
            rightRuleEditors.putAll(ae.getRuleEditors());
        }

        /*  Decide if the key mapping needs to be used. Assume that the keys are either A-F and G-L though and ff the
         *  keys are mixed then use the map. Otherwise, don't.
         */
        boolean useRuleEditorMapping = false;
        if ((leftRuleEditors.containsKey("A") && rightRuleEditors.containsKey("G"))
            || (leftRuleEditors.containsKey("G") && rightRuleEditors.containsKey("A"))) {
            useRuleEditorMapping = true;
        }

        for (Map.Entry<String, RuleEditor> re : leftRuleEditors.entrySet()) {

            String leftRuleEditorKey = re.getKey();
            String rightRuleEditorKey = leftRuleEditorKey;
            if (useRuleEditorMapping) {
                rightRuleEditorKey = ruleEditorKeyMapping.get(leftRuleEditorKey);
            }

            RuleEditor leftRuleEditor = re.getValue();

            //  Get the left proposition and natural language map
            PropositionEditor leftProposition = leftRuleEditor.getPropositionEditor();
            //  If the left proposition is null but the right isn't then the requisites are different
            if (leftProposition == null) {
                if (rightRuleEditors.get(ruleEditorKeyMapping.get(leftRuleEditorKey)) != null
                        && rightRuleEditors.get(rightRuleEditorKey).getProposition() != null) {
                    return false;
                } else {
                    continue; //  Both are null so go to the next item.
                }
            }
            Map<String, String> leftNaturalLanguageMap = leftProposition.getNaturalLanguage();

            //  Get the right rule and proposition editors
            RuleEditor rightRuleEditor = rightRuleEditors.get(ruleEditorKeyMapping.get(leftRuleEditorKey));
            //  If no right rule editor then the requisites are different.
            if (rightRuleEditor == null) {
                return false;
            }
            PropositionEditor rightPropositionEditor = rightRuleEditor.getPropositionEditor();
            if (rightPropositionEditor == null) {
                return false;
            }

            /*
             * Compare the natural language for each proposition in both directions
             */
            Map<String, String> rightNaturalLanguageMap = rightPropositionEditor.getNaturalLanguage();
            //  If the natural language maps aren't the same size then no more comparison is necessary
            if (leftNaturalLanguageMap.size() != rightNaturalLanguageMap.size()) {
               return false;
            }

            for (Map.Entry<String, String> leftNl : leftNaturalLanguageMap.entrySet()) {
                String leftNlKey = leftNl.getKey();
                String leftNlValue = leftNl.getValue();

                String rightNlValue = rightNaturalLanguageMap.get(leftNlKey);

                if (rightNlValue == null || ! leftNlValue.equals(rightNlValue)) {
                    return false;
                }
            }

            for (Map.Entry<String, String> rightNl : rightNaturalLanguageMap.entrySet()) {
                String rightNlKey = rightNl.getKey();
                String rightNlValue = rightNl.getValue();

                String leftNlValue = rightNaturalLanguageMap.get(rightNlKey);

                if (leftNlValue == null || ! rightNlValue.equals(leftNlValue)) {
                    return false;
                }
            }
        }

        return true;
    }
}
