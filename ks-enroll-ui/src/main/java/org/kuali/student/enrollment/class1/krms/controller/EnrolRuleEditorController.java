/**
 * Copyright 2005-2013 The Kuali Foundation
 *
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.opensource.org/licenses/ecl2.php
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.kuali.student.enrollment.class1.krms.controller;

import org.kuali.rice.krad.uif.UifConstants;
import org.kuali.rice.krad.uif.UifParameters;
import org.kuali.rice.krad.util.KRADConstants;
import org.kuali.rice.krad.web.form.DocumentFormBase;
import org.kuali.rice.krad.web.form.MaintenanceDocumentForm;
import org.kuali.rice.krad.web.form.UifFormBase;
import org.kuali.rice.krms.controller.RuleEditorController;
import org.kuali.rice.krms.dto.RuleEditor;
import org.kuali.rice.krms.util.AgendaUtilities;
import org.kuali.rice.krms.util.KRMSConstants;
import org.kuali.rice.krms.util.PropositionTreeUtil;
import org.kuali.student.common.uif.form.KSUifMaintenanceDocumentForm;
import org.kuali.student.common.uif.util.KSControllerHelper;
import org.kuali.student.enrollment.class1.krms.dto.CORuleManagementWrapper;
import org.kuali.student.enrollment.class1.krms.util.EnrolKRMSConstants;
import org.kuali.student.lum.lu.ui.krms.dto.CluSetRangeInformation;
import org.kuali.student.lum.lu.ui.krms.dto.LUPropositionEditor;
import org.kuali.student.lum.lu.ui.krms.dto.LURuleEditor;
import org.kuali.student.lum.lu.ui.krms.service.impl.LURuleViewHelperServiceImpl;
import org.kuali.student.lum.lu.ui.krms.util.CluSetRangeHelper;
import org.kuali.student.lum.lu.ui.krms.dto.CluSetRangeWrapper;
import org.kuali.student.r2.lum.clu.dto.MembershipQueryInfo;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Override of RuleEditorController for Student
 *
 * @author Kuali Student Team
 */
public class EnrolRuleEditorController extends RuleEditorController {

    @Override
    protected MaintenanceDocumentForm createInitialForm() {
        return new KSUifMaintenanceDocumentForm();
    }

    /**
     * Setups a new <code>MaintenanceDocumentView</code> with the edit maintenance
     * action
     */
    @RequestMapping(params = "methodToCall=" + KRADConstants.Maintenance.METHOD_TO_CALL_EDIT)
    public ModelAndView maintenanceEdit(@ModelAttribute("KualiForm") MaintenanceDocumentForm form) throws Exception {

        setupMaintenanceEdit(form);

        return getModelAndView(form);
    }

    /**
     *
     * @param form
     * @return
     */
    @Override
    @RequestMapping(params = "methodToCall=route")
    public ModelAndView route(@ModelAttribute("KualiForm") DocumentFormBase form) {
        super.route(form);
        return back(form);
    }

    /**
     *
     * @param form
     * @return
     */
    @RequestMapping(params = "methodToCall=cancel")
    @Override
    public ModelAndView cancel(@ModelAttribute("KualiForm") UifFormBase form) {

        DocumentFormBase documentForm = (DocumentFormBase) form;
        super.cancel(documentForm);

        return back(form);
    }

    /**
     *
     * @param form
     * @return
     */
    @Override
    @RequestMapping(params = "methodToCall=addRule")
    public ModelAndView addRule(@ModelAttribute("KualiForm") UifFormBase form) {

        //Clear the client state on new edit rule.
        form.getClientStateForSyncing().clear();
        MaintenanceDocumentForm document = (MaintenanceDocumentForm) form;

        RuleEditor ruleEditor = AgendaUtilities.getSelectedRuleEditor(document);
        LURuleEditor enrolRuleEditor = new LURuleEditor(ruleEditor.getKey(), true, ruleEditor.getRuleTypeInfo());
        enrolRuleEditor.setParent(ruleEditor.getParent());
        AgendaUtilities.getRuleWrapper(document).setRuleEditor(enrolRuleEditor);

        this.getViewHelper(form).refreshInitTrees(enrolRuleEditor);

        if(!form.getActionParameters().containsKey(UifParameters.NAVIGATE_TO_PAGE_ID)){
            form.getActionParameters().put(UifParameters.NAVIGATE_TO_PAGE_ID, KRMSConstants.KRMS_RULE_MAINTENANCE_PAGE_ID);
        }
        return super.navigate(form);
    }

    /**
     * Controller method used to display the lightbox with the list of courses in the selected range.
     *
     * @param form
     * @return
     */
    @RequestMapping(params="methodToCall=viewCourseRange")
    public ModelAndView viewCourseRange(@ModelAttribute("KualiForm") UifFormBase form) {

        MaintenanceDocumentForm document = (MaintenanceDocumentForm) form;
        CORuleManagementWrapper ruleWrapper = (CORuleManagementWrapper) document.getDocument().getNewMaintainableObject().getDataObject();
        LUPropositionEditor proposition = (LUPropositionEditor) PropositionTreeUtil.getProposition(ruleWrapper.getRuleEditor());

        String index = form.getActionParameters().get("selectedIndex");
        if ((proposition.getCourseSet() != null) && (proposition.getCourseSet().getCluSetRanges()!=null)){
            ruleWrapper.setClusInRange(proposition.getCourseSet().getCluSetRanges().get(Integer.valueOf(index)).getClusInRange());
        }

        return showDialog(EnrolKRMSConstants.KSKRMS_DIALOG_COURSERANGE_LOOKUP, false, form);
     }

    /**
     * Controller method used to add a new course range to the list of course ranges.
     *
     * @param form
     * @return
     */
    @RequestMapping(params = "methodToCall=addRange")
    public ModelAndView addRange(@ModelAttribute("KualiForm") UifFormBase form) {

        LURuleEditor rule = (LURuleEditor) getRuleEditor(form);
        LUPropositionEditor prop = (LUPropositionEditor) PropositionTreeUtil.getProposition(rule);

        //Build the membershipquery
        CluSetRangeWrapper range = prop.getCluSetRange();
        if(!CluSetRangeHelper.validateCourseRange(prop, range)){
            return getModelAndView(form);
        }

        MembershipQueryInfo membershipQueryInfo = CluSetRangeHelper.buildMembershipQuery(range);

        //Build the cluset range wrapper object
        CluSetRangeInformation cluSetRange = new CluSetRangeInformation();
        cluSetRange.setCluSetRangeLabel(CluSetRangeHelper.buildLabelFromQuery(membershipQueryInfo));
        cluSetRange.setMembershipQueryInfo(membershipQueryInfo);
        cluSetRange.setClusInRange(this.getViewHelper(form).getCoursesInRange(membershipQueryInfo));

        if(!CluSetRangeHelper.validateCoursesInRange(prop, range, cluSetRange)) {
            return getModelAndView(form);
        }

        prop.getCourseSet().getCluSetRanges().add(cluSetRange);

        //Reset range helper to clear values on screen.
        range.reset();

        return getModelAndView(form);
    }

    /**
     *
     * @param form
     * @return
     */
    protected LURuleViewHelperServiceImpl getViewHelper(UifFormBase form) {
        return (LURuleViewHelperServiceImpl) KSControllerHelper.getViewHelperService(form);
    }
}
