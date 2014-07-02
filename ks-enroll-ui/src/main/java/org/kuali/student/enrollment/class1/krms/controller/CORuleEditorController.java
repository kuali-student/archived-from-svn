package org.kuali.student.enrollment.class1.krms.controller;

import org.kuali.rice.krad.uif.UifParameters;
import org.kuali.rice.krad.util.GlobalVariables;
import org.kuali.rice.krad.web.form.MaintenanceDocumentForm;
import org.kuali.rice.krad.web.form.UifFormBase;
import org.kuali.rice.krms.dto.RuleEditor;
import org.kuali.rice.krms.dto.RuleManagementWrapper;
import org.kuali.rice.krms.util.AgendaUtilities;
import org.kuali.rice.krms.util.KRMSConstants;
import org.kuali.student.enrollment.class1.krms.dto.CORuleManagementWrapper;
import org.kuali.student.enrollment.class1.krms.util.EnrolKRMSConstants;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * Override of RuleEditorController for Student
 *
 * @author Kuali Student Team
 */
@Controller
@RequestMapping(value = "/courseOfferingRules")
public class CORuleEditorController extends EnrolRuleEditorController {

    /**
     *
     * @param form
     * @return
     */
    @Override
    @RequestMapping(params = "methodToCall=addRule")
    public ModelAndView addRule(@ModelAttribute("KualiForm") UifFormBase form) {

        form.getActionParameters().put(UifParameters.NAVIGATE_TO_PAGE_ID, EnrolKRMSConstants.KSKRMS_RULE_CO_MAINTENANCE_PAGE_ID);
        return super.addRule(form);
    }

    /**
     * Method used to invoke the CO inquiry view from Manage Course Offering screen while search input is Course Offering
     * Code (04a screen)
     *
     * @param form
     * @return
     */
    @RequestMapping(params = "methodToCall=goToRuleView")
    public ModelAndView goToRuleView(@ModelAttribute("KualiForm") UifFormBase form) {

        form.getActionParameters().put(UifParameters.NAVIGATE_TO_PAGE_ID, EnrolKRMSConstants.KSKRMS_RULE_CO_MAINTENANCE_PAGE_ID);
        return super.goToRuleView(form);
    }

    /**
     * Reverts rule to previous state and navigates to agenda maintenance page.
     *
     * @param form
     * @return
     */
    @RequestMapping(params = "methodToCall=cancelEditRule")
    public ModelAndView cancelEditRule(@ModelAttribute("KualiForm") UifFormBase form) {

        form.getActionParameters().put(UifParameters.NAVIGATE_TO_PAGE_ID, EnrolKRMSConstants.KSKRMS_AGENDA_CO_MAINTENANCE_PAGE_ID);
        return super.cancelEditRule(form);
    }

    /**
     * Updates rule and redirects to agenda maintenance page.
     *
     * @param form
     * @return
     */
    @RequestMapping(params = "methodToCall=updateRule")
    public ModelAndView updateRule(@ModelAttribute("KualiForm") UifFormBase form) {

        form.getActionParameters().put(UifParameters.NAVIGATE_TO_PAGE_ID, EnrolKRMSConstants.KSKRMS_AGENDA_CO_MAINTENANCE_PAGE_ID);

        //KSENROLL-7267: workaround to display browser warning when leaving AO requisite screen without saving
        MaintenanceDocumentForm ruleMaintenanceForm = (MaintenanceDocumentForm) form;
        CORuleManagementWrapper coRuleMgtWrapper = (CORuleManagementWrapper) AgendaUtilities.getRuleWrapper(ruleMaintenanceForm);
        coRuleMgtWrapper.setAgendaDirty(true);

        return super.updateRule(form);
    }

    /**
     * Delete rule and redirects to agenda maintenance page.
     *
     * @param form
     * @return
     */
    @Override
    @RequestMapping(params = "methodToCall=deleteRule")
    public ModelAndView deleteRule(@ModelAttribute("KualiForm") UifFormBase form) {

        //KSENROLL-7267: workaround to display browser warning when leaving CO requisite screen without saving
        MaintenanceDocumentForm ruleMaintenanceForm = (MaintenanceDocumentForm) form;
        CORuleManagementWrapper coRuleMgtWrapper = (CORuleManagementWrapper) AgendaUtilities.getRuleWrapper(ruleMaintenanceForm);
        coRuleMgtWrapper.setAgendaDirty(true);

        return super.deleteRule(form);
    }


    /**
     * Retrieves selected proposition key and initializes edit on propostion.
     *
     * @param form
     * @return
     */
    @RequestMapping(params = "methodToCall=getSelectedKey")
    public ModelAndView getSelectedKey(@ModelAttribute("KualiForm") UifFormBase form) {

        //Clear the current states of the tabs to open the first tab again with the edit tree.
        Map<String, String> states = (Map<String, String>) form.getClientStateForSyncing().get(EnrolKRMSConstants.KSKRMS_RULE_CO_TABS_ID);
        states.put(KRMSConstants.KRMS_PARM_ACTIVE_TAB, EnrolKRMSConstants.KSKRMS_RULE_CO_EDITWITHOBJECT_ID);

        //Set the selected rule statement key.
        String selectedKey = form.getRequest().getParameter(KRMSConstants.KRMS_PARM_SELECTED_KEY);
        getRuleEditor(form).setSelectedKey(selectedKey);

        return this.goToEditProposition(form);
    }

    /**
     * Test method for a controller that invokes a dialog lightbox.
     *
     * @param form
     * @return
     */
    @RequestMapping(params = "methodToCall=compareRules")
    public ModelAndView compareRules(@ModelAttribute("KualiForm") UifFormBase form) {

        doCompareRules(form);

        // redirect back to client to display lightbox
        return showDialog(EnrolKRMSConstants.KSKRMS_DIALOG_COMPARE_CLU_CO, false, form);
    }

    protected void compareRulePropositions(MaintenanceDocumentForm form, RuleEditor ruleEditor) {

        RuleManagementWrapper ruleWrapper = (RuleManagementWrapper) form.getDocument().getNewMaintainableObject().getDataObject();

        //Compare CO to CLU and display info message
        if (ruleEditor.getProposition() != null) {
            if (!this.getViewHelper(form).compareRules(ruleWrapper.getRuleEditor())) {
                GlobalVariables.getMessageMap().putInfoForSectionId(KRMSConstants.KRMS_RULE_TREE_GROUP_ID, EnrolKRMSConstants.KSKRMS_MSG_INFO_CO_RULE_CHANGED);
            } else if (GlobalVariables.getMessageMap().containsMessageKey(KRMSConstants.KRMS_RULE_TREE_GROUP_ID)) {
                GlobalVariables.getMessageMap().removeAllInfoMessagesForProperty(KRMSConstants.KRMS_RULE_TREE_GROUP_ID);
            }
        }
    }

}
