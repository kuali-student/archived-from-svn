/*
 * Copyright 2011 The Kuali Foundation
 * 
 * Licensed under the Educational Community License, Version 1.0 (the
 * "License"); you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.opensource.org/licenses/ecl1.php
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package org.kuali.student.enrollment.class2.acal.controller;

import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.kuali.rice.core.api.resourceloader.GlobalResourceLoader;
import org.kuali.rice.krad.uif.UifConstants;
import org.kuali.rice.krad.uif.UifParameters;
import org.kuali.rice.krad.util.GlobalVariables;
import org.kuali.rice.krad.util.KRADConstants;
import org.kuali.rice.krad.web.form.UifFormBase;
import org.kuali.student.enrollment.acal.dto.AcademicCalendarInfo;
import org.kuali.student.enrollment.acal.dto.TermInfo;
import org.kuali.student.enrollment.acal.service.AcademicCalendarService;
import org.kuali.student.enrollment.class2.acal.dto.*;
import org.kuali.student.enrollment.class2.acal.form.AcademicCalendarForm;
import org.kuali.student.enrollment.class2.acal.service.AcademicCalendarViewHelperService;
import org.kuali.student.enrollment.class2.acal.util.CalendarConstants;
import org.kuali.student.enrollment.uif.controller.KSControllerBase;
import org.kuali.student.r2.common.dto.StatusInfo;
import org.kuali.student.r2.common.util.constants.AcademicCalendarServiceConstants;
import org.kuali.student.r2.core.constants.AtpServiceConstants;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.namespace.QName;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

/**
 * This controller handles all the request from Academic calendar UI.
 *
 * These are the related xmls from where requests come to this controller
 * 1. AcademicCalendarView.xml
 * 2. AcademicCalendarEditPage.xml
 * 3. AcademicCalendarCopyPage.xml
 * 4. AcademicTermPage.xml
 *
 * @author Kuali Student Team
 */

@Controller
@RequestMapping(value = "/academicCalendar")
public class AcademicCalendarController extends KSControllerBase {

    private static final Logger LOG = org.apache.log4j.Logger.getLogger(AcademicCalendarController.class);

    private AcademicCalendarService acalService;

    @Override
    protected UifFormBase createInitialForm(HttpServletRequest request) {
        return new AcademicCalendarForm();
    }

    /**
     * This GET method loads an academic calendar based on the parameters passed into the request.
     *
     * These are the supported request parameters (specific to Acal)
     * 1. id - Academic Calendar Id to load in to UI
     * 2. readOnlyView - If true, sets the view as read only
     * 3. selectTab - can be 'info' or 'term'
     *
     */
    @Override
    @RequestMapping(method = RequestMethod.GET, params = "methodToCall=start")
    public ModelAndView start(@ModelAttribute("KualiForm") UifFormBase form, BindingResult result,
                              HttpServletRequest request, HttpServletResponse response) {
        AcademicCalendarForm acalForm = (AcademicCalendarForm) form;

        String acalId = request.getParameter(CalendarConstants.CALENDAR_ID);

        if (StringUtils.isNotBlank(acalId)){
            getAcalViewHelperService(acalForm).populateAcademicCalendar(acalId, acalForm);
        }

        String readOnlyView = request.getParameter(CalendarConstants.READ_ONLY_VIEW);
        acalForm.getView().setReadOnly(BooleanUtils.toBoolean(readOnlyView));

        if (StringUtils.isNotBlank(request.getParameter(CalendarConstants.SELECT_TAB))) {
            acalForm.setDefaultTabToShow(request.getParameter(CalendarConstants.SELECT_TAB));
        }

        return super.start(form, result, request, response);
    }

    /**
     * This method creates a blank academic calendar.
     */
    @RequestMapping(params = "methodToCall=createBlankCalendar")
    public ModelAndView createBlankCalendar(@ModelAttribute("KualiForm") AcademicCalendarForm acalForm, BindingResult result,
                                            HttpServletRequest request, HttpServletResponse response){

        acalForm.setAcademicCalendarInfo(new AcademicCalendarInfo());
        acalForm.setEvents(new ArrayList<AcalEventWrapper>());
        acalForm.setHolidayCalendarList(new ArrayList<HolidayCalendarWrapper>());
        acalForm.setTermWrapperList(new ArrayList<AcademicTermWrapper>());

        return getUIFModelAndView(acalForm, CalendarConstants.ACADEMIC_CALENDAR_EDIT_PAGE);
    }

    /**
     * This GET method is called before the Create New Academic Calendar page is displayed
     *
     * It fills in the original Acal for the form with the latest calendar found, by default
     */
    @RequestMapping(method = RequestMethod.GET, params = "methodToCall=startNew")
    public ModelAndView startNew( @ModelAttribute("KualiForm") AcademicCalendarForm acalForm, BindingResult result,
                                  HttpServletRequest request, HttpServletResponse response) {

        try {
            AcademicCalendarInfo acalInfo = getAcalViewHelperService(acalForm).getLatestAcademicCalendar();
            acalForm.setOrgAcalInfo(acalInfo);
        }
        catch (Exception x) {
            throw new RuntimeException(x);
        }


        return getUIFModelAndView(acalForm);
    }

    /**
     * This method will be called when user clicks on the edit link at the header portion of acal.
     *
     * @param acalForm
     * @param result
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(params = "methodToCall=toEdit")
    public ModelAndView toEdit(@ModelAttribute("KualiForm") AcademicCalendarForm acalForm, BindingResult result,
                                              HttpServletRequest request, HttpServletResponse response){
        AcademicCalendarInfo acalInfo = acalForm.getAcademicCalendarInfo();
        AcademicCalendarInfo orgAcalInfo = acalForm.getOrgAcalInfo();

        if (StringUtils.isBlank(acalInfo.getId()) && StringUtils.isNotBlank(orgAcalInfo.getId())){
            getAcalViewHelperService(acalForm).populateAcademicCalendar(orgAcalInfo.getId(), acalForm);
            acalForm.setOrgAcalInfo(new AcademicCalendarInfo());
        }

        acalForm.getView().setReadOnly(false);

        return getUIFModelAndView(acalForm, CalendarConstants.ACADEMIC_CALENDAR_EDIT_PAGE);
    }

    /**
     * Passes on request from Acal view to copy the Acal to the copyForNew method.  Needed a forwarder here because the
     * call is a GET rather than a POST
     *
     * @param acalForm
     * @param result
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(params = "methodToCall=toCopy")
    public ModelAndView toCopy(@ModelAttribute("KualiForm") AcademicCalendarForm acalForm, BindingResult result,
                                              HttpServletRequest request, HttpServletResponse response){

        AcademicCalendarInfo acalInfo = null;

        String acalId = request.getParameter(CalendarConstants.CALENDAR_ID);
        if (acalId != null && !acalId.trim().isEmpty()) {
            String pageId = request.getParameter(CalendarConstants.PAGE_ID);
            if (CalendarConstants.ACADEMIC_CALENDAR_COPY_PAGE.equals(pageId)) {

                try {
                    acalInfo= getAcalService().getAcademicCalendar(acalId, getAcalViewHelperService(acalForm).createContextInfo());
                    acalForm.setOrgAcalInfo(acalInfo);

                } catch (Exception ex) {
                    throw new RuntimeException(ex);
                }
            }
        }
        else {
            // try to get the AC from the form (in case of copy from the Acal view page) and set it as the Original Acal
            try {
                acalInfo = acalForm.getAcademicCalendarInfo();
                acalForm.reset();
                acalForm.setNewCalendar(true);
                acalForm.setOrgAcalInfo(acalInfo);
            }
            catch (Exception x) {
                throw new RuntimeException(x);
            }

        }

        return copy(acalForm, result, request, response);
    }

    /**
     * Copy over from the existing AcalInfo to create a new.
     *
     * @param acalForm
     * @param result
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(method = RequestMethod.POST, params="methodToCall=copy")
    public ModelAndView copy( @ModelAttribute("KualiForm") AcademicCalendarForm acalForm, BindingResult result,
                              HttpServletRequest request, HttpServletResponse response) {
        try {
           getAcalViewHelperService(acalForm).copyToCreateAcademicCalendar(acalForm);
        }catch (Exception ex) {
            throw new RuntimeException(ex);
        }

        return getUIFModelAndView(acalForm, CalendarConstants.ACADEMIC_CALENDAR_EDIT_PAGE);

    }

    //Editing Hcal is implemented fully and it's working.. but we're having some issues with KRAD form management
    //This will be implemented in future milestones
    /*@RequestMapping(method = RequestMethod.POST, params="methodToCall=editHolidayCalendar")
    public ModelAndView editHolidayCalendar( @ModelAttribute("KualiForm") AcademicCalendarForm acalForm, BindingResult result,
                                            HttpServletRequest request, HttpServletResponse response) {

        String selectedCollectionPath = acalForm.getActionParamaterValue(UifParameters.SELLECTED_COLLECTION_PATH);
        if (StringUtils.isBlank(selectedCollectionPath)) {
            throw new RuntimeException("unable to determine the selected collection path");
        }

        int selectedLineIndex = -1;
        String selectedLine = acalForm.getActionParamaterValue(UifParameters.SELECTED_LINE_INDEX);
        if (StringUtils.isNotBlank(selectedLine)) {
            selectedLineIndex = Integer.parseInt(selectedLine);
        }

        if (selectedLineIndex == -1) {
            throw new RuntimeException("unable to determine the selected line index");
        }

        Properties hcalURLParam = new Properties();
        hcalURLParam.put(KRADConstants.DISPATCH_REQUEST_PARAMETER, CalendarConstants.HC_EDIT_METHOD);
        hcalURLParam.put(CalendarConstants.CALENDAR_ID, acalForm.getHolidayCalendarList().get(selectedLineIndex).getId());
        hcalURLParam.put(UifParameters.VIEW_ID, CalendarConstants.HOLIDAYCALENDAR_FLOWVIEW);
        hcalURLParam.put(UifParameters.PAGE_ID, CalendarConstants.HOLIDAYCALENDAR_EDITPAGE);
        hcalURLParam.put(UifParameters.RETURN_FORM_KEY, acalForm.getFormKey());

        Properties acalReturnURLParams = new Properties();
        acalReturnURLParams.put(KRADConstants.DISPATCH_REQUEST_PARAMETER, CalendarConstants.AC_EDIT_METHOD);
        acalReturnURLParams.put(UifParameters.VIEW_ID, CalendarConstants.ACAL_VIEW);
        acalReturnURLParams.put(UifParameters.PAGE_ID, CalendarConstants.ACADEMIC_CALENDAR_EDIT_PAGE);
        String returnUrl = UrlFactory.parameterizeUrl(CalendarConstants.ACAL_CONTROLLER_PATH, acalReturnURLParams);
        hcalURLParam.put(UifParameters.RETURN_LOCATION, returnUrl);

        return super.performRedirect(acalForm,CalendarConstants.HCAL_CONTROLLER_PATH, hcalURLParam);

    }*/


    /**
     * Redirects the user to the search Calendar page
     *
     * @param acalForm
     * @param result
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping(params = "methodToCall=search")
    public ModelAndView search(@ModelAttribute("KualiForm") AcademicCalendarForm acalForm, BindingResult result,
                             HttpServletRequest request, HttpServletResponse response) throws Exception {

        String controllerPath = CalendarConstants.CALENDAR_SEARCH_CONTROLLER_PATH;
        Properties urlParameters = new Properties();
        urlParameters.put(KRADConstants.DISPATCH_REQUEST_PARAMETER, KRADConstants.START_METHOD);
        urlParameters.put(UifParameters.VIEW_ID, CalendarConstants.CALENDAR_SEARCH_VIEW);
        urlParameters.put(UifConstants.UrlParams.SHOW_HISTORY, BooleanUtils.toStringTrueFalse(false));
        return super.performRedirect(acalForm,controllerPath, urlParameters);
    }

    /**
     * This will save the academic calendar.
     *
     * @param academicCalendarForm
     * @param result
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(method = RequestMethod.POST, params = "methodToCall=save")
    public ModelAndView save(@ModelAttribute("KualiForm") AcademicCalendarForm academicCalendarForm, BindingResult result,
                             HttpServletRequest request, HttpServletResponse response) {
        return saveAcademicCalendar(academicCalendarForm, CalendarConstants.MSG_INFO_ACADEMIC_CALENDAR_SAVED, false);
    }

    /**
     * Method used to delete AcademicCalendar
     *
     * @param acalForm
     * @param result
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping(method = RequestMethod.POST, params = "methodToCall=delete")
    public ModelAndView delete(@ModelAttribute("KualiForm") AcademicCalendarForm acalForm, BindingResult result,
                                   HttpServletRequest request, HttpServletResponse response) throws Exception {

        StatusInfo statusInfo = getAcalService().deleteAcademicCalendar(acalForm.getAcademicCalendarInfo().getId(), getAcalViewHelperService(acalForm).createContextInfo());

        if (statusInfo.getIsSuccess()){
            GlobalVariables.getMessageMap().putInfo(KRADConstants.GLOBAL_MESSAGES, CalendarConstants.MSG_INFO_SEARCH_DELETE_SUCCESS, acalForm.getAcademicCalendarInfo().getName());
        } else {
            GlobalVariables.getMessageMap().putInfo(KRADConstants.GLOBAL_MESSAGES, CalendarConstants.MSG_ERROR_DELETING, acalForm.getAcademicCalendarInfo().getName(),statusInfo.getMessage());
            return getUIFModelAndView(acalForm);
        }

        Properties urlParameters = new  Properties();
        urlParameters.put("viewId", CalendarConstants.ENROLLMENT_HOME_VIEW);
        urlParameters.put("methodToCall", KRADConstants.START_METHOD);
        urlParameters.put(UifConstants.UrlParams.SHOW_HISTORY, BooleanUtils.toStringTrueFalse(false));

        return performRedirect(acalForm, request.getRequestURL().toString(), urlParameters);
    }

    /**
     * Cancel editing a term. This will undo all the changes done by the users. Basically, it loads the term info
     * from the DB.
     *
     * @param academicCalendarForm
     * @param result
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(method = RequestMethod.POST, params = "methodToCall=cancelTerm")
    public ModelAndView cancelTerm(@ModelAttribute("KualiForm") AcademicCalendarForm academicCalendarForm, BindingResult result,
                                        HttpServletRequest request, HttpServletResponse response) {

        String selectedCollectionPath = academicCalendarForm.getActionParamaterValue(UifParameters.SELLECTED_COLLECTION_PATH);
        if (StringUtils.isBlank(selectedCollectionPath)) {
            throw new RuntimeException("unable to determine the selected collection path");
        }

        int selectedLineIndex = -1;
        String selectedLine = academicCalendarForm.getActionParamaterValue(UifParameters.SELECTED_LINE_INDEX);
        if (StringUtils.isNotBlank(selectedLine)) {
            selectedLineIndex = Integer.parseInt(selectedLine);
        }

        if (selectedLineIndex == -1) {
            throw new RuntimeException("unable to determine the selected line index");
        }

        AcademicTermWrapper termWrapper = academicCalendarForm.getTermWrapperList().get(selectedLineIndex);

        AcademicCalendarViewHelperService viewHelperService = getAcalViewHelperService(academicCalendarForm);

        if (termWrapper.isNew()){
           academicCalendarForm.getTermWrapperList().remove(selectedLineIndex);
        }else{
            try {
                TermInfo termInfo = getAcalService().getTerm(termWrapper.getTermInfo().getId(), viewHelperService.createContextInfo());
                AcademicTermWrapper termWrapperFromDB = viewHelperService.populateTermWrapper(termInfo, false);
                academicCalendarForm.getTermWrapperList().set(selectedLineIndex,termWrapperFromDB);

               try{
                    viewHelperService.populateInstructionalDays(termWrapperFromDB);
                }catch(Exception e){
                    //TODO: FIXME: Have to handle the error.. but for now, as it's causing issue, just skipping calculation when there are errors
                    e.printStackTrace();
                }
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }

        return getUIFModelAndView(academicCalendarForm);
    }

    /**
     * This method makes a term official and persist to DB. User can selectively make a term official.
     *
     * @param academicCalendarForm
     * @param result
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(method = RequestMethod.POST, params = "methodToCall=makeTermOfficial")
    public ModelAndView makeTermOfficial(@ModelAttribute("KualiForm") AcademicCalendarForm academicCalendarForm, BindingResult result,
                                        HttpServletRequest request, HttpServletResponse response) {

        String selectedCollectionPath = academicCalendarForm.getActionParamaterValue(UifParameters.SELLECTED_COLLECTION_PATH);
        if (StringUtils.isBlank(selectedCollectionPath)) {
            throw new RuntimeException("unable to determine the selected collection path");
        }

        int selectedLineIndex = -1;
        String selectedLine = academicCalendarForm.getActionParamaterValue(UifParameters.SELECTED_LINE_INDEX);
        if (StringUtils.isNotBlank(selectedLine)) {
            selectedLineIndex = Integer.parseInt(selectedLine);
        }

        if (selectedLineIndex == -1) {
            throw new RuntimeException("unable to determine the selected line index");
        }

        AcademicTermWrapper termWrapper = academicCalendarForm.getTermWrapperList().get(selectedLineIndex);
        AcademicCalendarViewHelperService viewHelperService = getAcalViewHelperService(academicCalendarForm);

        viewHelperService.validateTerm(academicCalendarForm.getTermWrapperList(), selectedLineIndex, academicCalendarForm.getAcademicCalendarInfo());

        if (GlobalVariables.getMessageMap().getErrorCount() > 0){
           return getUIFModelAndView(academicCalendarForm);
        }

        try{
            boolean alreadyOfficial = StringUtils.equals(AtpServiceConstants.ATP_OFFICIAL_STATE_KEY,academicCalendarForm.getAcademicCalendarInfo().getStateKey());
            String messageText = alreadyOfficial ? "info.enroll.term.saved" : "info.enroll.term.official";
            viewHelperService.saveTerm(termWrapper, academicCalendarForm.getAcademicCalendarInfo().getId(), true);
            GlobalVariables.getMessageMap().putInfo(KRADConstants.GLOBAL_ERRORS, messageText, termWrapper.getTermNameForUI());
            // GlobalVariables.getMessageMap().putInfo(KRADConstants.GLOBAL_ERRORS,"info.enroll.term.official",termWrapper.getTermNameForUI());
        }catch (Exception e){
           throw new RuntimeException(e);
        }

       try{
            viewHelperService.populateInstructionalDays(termWrapper);
        }catch(Exception e){
            //TODO: FIXME: Have to handle the error.. but for now, as it's causing issue, just skipping calculation when there are errors
            e.printStackTrace();
        }

        return getUIFModelAndView(academicCalendarForm);
    }

    /**
     * This cancels adding a term.
     *
     * Improvement jira KSENROLL-3567 to clear all the fields at the client side instead of at server side.
     *
     * @param academicCalendarForm
     * @param result
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(method = RequestMethod.POST, params = "methodToCall=cancelAddingTerm")
    public ModelAndView cancelAddingTerm(@ModelAttribute("KualiForm") AcademicCalendarForm academicCalendarForm, BindingResult result,
                                        HttpServletRequest request, HttpServletResponse response) {

        ((AcademicTermWrapper)academicCalendarForm.getNewCollectionLines().get("termWrapperList")).clear();

        return getUIFModelAndView(academicCalendarForm);
    }

    /**
     *
     * Improvement jira KSENROLL-3568  to clear all the fields at the client side instead of at server side.
     * @param academicCalendarForm
     * @param result
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(method = RequestMethod.POST, params = "methodToCall=cancelAddingHoliday")
    public ModelAndView cancelAddingHoliday(@ModelAttribute("KualiForm") AcademicCalendarForm academicCalendarForm, BindingResult result,
                                        HttpServletRequest request, HttpServletResponse response) {

        ((HolidayCalendarWrapper)academicCalendarForm.getNewCollectionLines().get("holidayCalendarList")).setId(StringUtils.EMPTY);

        return getUIFModelAndView(academicCalendarForm);
    }

    /**
     * This would mark a term for deletion if it's already there in the DB. If it's a newly added term, it just deletes
     * that.
     *
     * @param academicCalendarForm
     * @param result
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(method = RequestMethod.POST, params = "methodToCall=deleteTerm")
    public ModelAndView deleteTerm(@ModelAttribute("KualiForm") AcademicCalendarForm academicCalendarForm, BindingResult result,
                                        HttpServletRequest request, HttpServletResponse response) {

        String selectedCollectionPath = academicCalendarForm.getActionParamaterValue(UifParameters.SELLECTED_COLLECTION_PATH);
        if (StringUtils.isBlank(selectedCollectionPath)) {
            throw new RuntimeException("unable to determine the selected collection path");
        }

        int selectedLineIndex = -1;
        String selectedLine = academicCalendarForm.getActionParamaterValue(UifParameters.SELECTED_LINE_INDEX);
        if (StringUtils.isNotBlank(selectedLine)) {
            selectedLineIndex = Integer.parseInt(selectedLine);
        }

        if (selectedLineIndex == -1) {
            throw new RuntimeException("unable to determine the selected line index");
        }

        AcademicTermWrapper termWrapper = academicCalendarForm.getTermWrapperList().get(selectedLineIndex);

        if (!termWrapper.isNew()){
            academicCalendarForm.getTermsToDeleteOnSave().add(termWrapper);
        }

        academicCalendarForm.getTermWrapperList().remove(selectedLineIndex);

        return getUIFModelAndView(academicCalendarForm);

    }

    /**
     * Like term, this would mark a key date for deletion. If it's newly added, just deletes it.
     *
     * @param academicCalendarForm
     * @param result
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(method = RequestMethod.POST, params = "methodToCall=deleteKeyDate")
    public ModelAndView deleteKeyDate(@ModelAttribute("KualiForm") AcademicCalendarForm academicCalendarForm, BindingResult result,
                                        HttpServletRequest request, HttpServletResponse response) {

        String selectedCollectionPath = academicCalendarForm.getActionParamaterValue(UifParameters.SELLECTED_COLLECTION_PATH);
        if (StringUtils.isBlank(selectedCollectionPath)) {
            throw new RuntimeException("unable to determine the selected collection path");
        }

        int selectedLineIndex = -1;
        String selectedLine = academicCalendarForm.getActionParamaterValue(UifParameters.SELECTED_LINE_INDEX);
        if (StringUtils.isNotBlank(selectedLine)) {
            selectedLineIndex = Integer.parseInt(selectedLine);
        }

        if (selectedLineIndex == -1) {
            throw new RuntimeException("unable to determine the selected line index");
        }

        String selectedTermIndex = StringUtils.substringBetween(selectedCollectionPath,"termWrapperList[","]");
        String selectedKeyDateGroup = StringUtils.substringBetween(selectedCollectionPath,"keyDatesGroupWrappers[","]");

        AcademicTermWrapper termWrapper = academicCalendarForm.getTermWrapperList().get(Integer.parseInt(selectedTermIndex));
        KeyDatesGroupWrapper keydateGroup = termWrapper.getKeyDatesGroupWrappers().get(Integer.parseInt(selectedKeyDateGroup));
        KeyDateWrapper keyDateWrapper = keydateGroup.getKeydates().get(selectedLineIndex);

        if (StringUtils.isNotBlank(keyDateWrapper.getKeyDateInfo().getId())){
            termWrapper.getKeyDatesToDeleteOnSave().add(keyDateWrapper);
        }

        keydateGroup.getKeydates().remove(selectedLineIndex);

        return getUIFModelAndView(academicCalendarForm);

    }

    @RequestMapping(method = RequestMethod.POST, params = "methodToCall=deleteKeyDateGroup")
    public ModelAndView deleteKeyDateGroup(@ModelAttribute("KualiForm") AcademicCalendarForm academicCalendarForm, BindingResult result,
                                           HttpServletRequest request, HttpServletResponse response) {

        String selectedCollectionPath = academicCalendarForm.getActionParamaterValue(UifParameters.SELLECTED_COLLECTION_PATH);
        if (StringUtils.isBlank(selectedCollectionPath)) {
            throw new RuntimeException("unable to determine the selected collection path");
        }

        int selectedLineIndex = -1;
        String selectedLine = academicCalendarForm.getActionParamaterValue(UifParameters.SELECTED_LINE_INDEX);
        if (StringUtils.isNotBlank(selectedLine)) {
            selectedLineIndex = Integer.parseInt(selectedLine);
        }

        if (selectedLineIndex == -1) {
            throw new RuntimeException("unable to determine the selected line index");
        }

        String selectedTermIndex = StringUtils.substringBetween(selectedCollectionPath, "termWrapperList[", "]");

        AcademicTermWrapper termWrapper = academicCalendarForm.getTermWrapperList().get(Integer.parseInt(selectedTermIndex));
        KeyDatesGroupWrapper keydateGroup = termWrapper.getKeyDatesGroupWrappers().get(selectedLineIndex);
        for (KeyDateWrapper keyDateWrapper : keydateGroup.getKeydates()) {
            if (StringUtils.isNotBlank(keyDateWrapper.getKeyDateInfo().getId())){
                termWrapper.getKeyDatesToDeleteOnSave().add(keyDateWrapper);
            }
        }

        termWrapper.getKeyDatesGroupWrappers().remove(keydateGroup);

        return getUIFModelAndView(academicCalendarForm);

    }

    /**
     * Method used to set Acal as official
     */
    @RequestMapping(method = RequestMethod.POST, params = "methodToCall=makeAcalOfficial")
    public ModelAndView makeAcalOfficial(@ModelAttribute("KualiForm") AcademicCalendarForm acalForm, BindingResult result,
                             HttpServletRequest request, HttpServletResponse response) throws Exception {
        return saveAcademicCalendar(acalForm, CalendarConstants.MSG_INFO_ACADEMIC_CALENDAR_OFFICIAL, true);
    }



    private AcademicCalendarInfo processHolidayCalendars(AcademicCalendarForm academicCalendarForm)    {
        AcademicCalendarInfo acalInfo = academicCalendarForm.getAcademicCalendarInfo();
        List<HolidayCalendarWrapper> holidayCalendarList = academicCalendarForm.getHolidayCalendarList();
        List<String> holidayCalendarIds = new ArrayList<String>();
        if (holidayCalendarList != null && !holidayCalendarList.isEmpty()) {
            for (HolidayCalendarWrapper hcWrapper : holidayCalendarList){
                holidayCalendarIds.add(hcWrapper.getHolidayCalendarInfo().getId());
            }
        }

        // if the list from the form is empty, then all holiday calendars have been removed (or none have been assigned)
        // so an empty list will be assigned to the AcademicCalendarInfo
        acalInfo.setHolidayCalendarIds(holidayCalendarIds);
        academicCalendarForm.setAcademicCalendarInfo(acalInfo);

        return acalInfo;
    }

    private ModelAndView saveAcademicCalendar(AcademicCalendarForm academicCalendarForm, String keyToDisplayOnSave, boolean isOfficial) {

        AcademicCalendarInfo academicCalendarInfo = academicCalendarForm.getAcademicCalendarInfo();
        AcademicCalendarViewHelperService viewHelperService = getAcalViewHelperService(academicCalendarForm);

        // Populate default times
        viewHelperService.populateAcademicCalendarDefaults(academicCalendarForm);

        // Validate Acal
        viewHelperService.validateAcademicCalendar(academicCalendarForm);
        if (GlobalVariables.getMessageMap().getErrorCount() > 0){
            return getUIFModelAndView(academicCalendarForm);
        }

        // If validation succeeds, continue save
        try {
            if (StringUtils.isNotBlank(academicCalendarInfo.getId())) {
                // 1. update acal and AC-HC relationships
                academicCalendarInfo = processHolidayCalendars(academicCalendarForm);
                if (isOfficial) {
                    academicCalendarInfo.setStateKey(AcademicCalendarServiceConstants.ACADEMIC_CALENDAR_OFFICIAL_STATE_KEY);
                }
                AcademicCalendarInfo acalInfo = getAcalService().updateAcademicCalendar(academicCalendarInfo.getId(), academicCalendarInfo, viewHelperService.createContextInfo());
                academicCalendarForm.setAcademicCalendarInfo(getAcalService().getAcademicCalendar(acalInfo.getId(), viewHelperService.createContextInfo()));

                // 2. update acalEvents if any
                List<AcalEventWrapper> events = academicCalendarForm.getEvents();
                processEvents(academicCalendarForm, events, acalInfo.getId());
            } else {
                AcademicCalendarInfo acalInfo = null;
                // 1. create  a new acalInfo with a list of HC Ids
                processHolidayCalendars(academicCalendarForm);
                acalInfo = viewHelperService.createAcademicCalendar(academicCalendarForm);
                academicCalendarForm.setAcademicCalendarInfo(getAcalService().getAcademicCalendar(acalInfo.getId(), viewHelperService.createContextInfo()));
                // 2. create new events if any
                createEvents(acalInfo.getId(), academicCalendarForm);
            }
        } catch(Exception e) {
            LOG.error("Add or update of Academic Calendar failed.", e);
            GlobalVariables.getMessageMap().putError(KRADConstants.GLOBAL_MESSAGES, CalendarConstants.MSG_ERROR_ACAL_SAVE_FAILED);
            return getUIFModelAndView(academicCalendarForm, CalendarConstants.ACADEMIC_CALENDAR_EDIT_PAGE);
        }

        // Delete terms which are deleted by the user in the ui
        for (AcademicTermWrapper termWrapper : academicCalendarForm.getTermsToDeleteOnSave()){
            String termId = termWrapper.getTermInfo().getId();
            try {
                getAcalService().deleteTerm(termId, viewHelperService.createContextInfo());
            } catch(Exception e) {
                LOG.error(String.format("Unable to delete term [%s].", termId), e);
                GlobalVariables.getMessageMap().putError(KRADConstants.GLOBAL_MESSAGES, CalendarConstants.MSG_ERROR_ACAL_SAVE_FAILED);
                return getUIFModelAndView(academicCalendarForm, CalendarConstants.ACADEMIC_CALENDAR_EDIT_PAGE);
            }
        }

        academicCalendarForm.getTermsToDeleteOnSave().clear();

        // Save Term and keydates
        for (AcademicTermWrapper termWrapper : academicCalendarForm.getTermWrapperList()){
            try {
                viewHelperService.saveTerm(termWrapper, academicCalendarForm.getAcademicCalendarInfo().getId(), false);
            } catch(Exception e) {
                LOG.error(String.format("Unable to save term [%s].", termWrapper.getName()), e);
                GlobalVariables.getMessageMap().putError(KRADConstants.GLOBAL_MESSAGES, CalendarConstants.MSG_ERROR_ACAL_SAVE_TERM_SAVE_FAILED,
                        termWrapper.getName(), e.getLocalizedMessage());
                return getUIFModelAndView(academicCalendarForm, CalendarConstants.ACADEMIC_CALENDAR_EDIT_PAGE);
            }
        }

        // Calculate instructional days (if HC exists)
        try {
            viewHelperService.populateInstructionalDays(academicCalendarForm.getTermWrapperList());
        } catch(Exception e) {
            //FIXME: Have to handle the error.. but for now, as it's causing issue, just skipping calculation when there are errors
            e.printStackTrace();
        }

        academicCalendarForm.setNewCalendar(false);

        if (isOfficial) {
            academicCalendarForm.setOfficialCalendar(true);
            academicCalendarForm.getView().setReadOnly(true);
        }

        GlobalVariables.getMessageMap().putInfo(KRADConstants.GLOBAL_MESSAGES, keyToDisplayOnSave, academicCalendarForm.getAcademicCalendarInfo().getName());

        return getUIFModelAndView(academicCalendarForm);
    }

    private void createEvents(String acalId, AcademicCalendarForm acalForm) throws Exception {
        List<AcalEventWrapper> events = acalForm.getEvents();

        AcademicCalendarViewHelperService viewHelperService = getAcalViewHelperService(acalForm);

        if(events != null && !events.isEmpty()){
            List<AcalEventWrapper> createdEvents = new ArrayList<AcalEventWrapper>();
            for (AcalEventWrapper event : events){
                createdEvents.add(viewHelperService.createEvent(acalId, event));
            }
            acalForm.setEvents(createdEvents);
        }

    }

    /**
     * Update existing events, create new events, and delete events that do not exist any more when a user modifies and saves an Academic Calendar
     */
    private void processEvents(AcademicCalendarForm acalForm, List<AcalEventWrapper> events, String acalId)throws Exception{
        List<AcalEventWrapper> updatedEvents = new ArrayList<AcalEventWrapper>();
        List<String> currentEventIds = getExistingEventIds(acalForm);
        AcademicCalendarViewHelperService viewHelperService = getAcalViewHelperService(acalForm);
        if(events != null && !events.isEmpty()){
            for(AcalEventWrapper event : events){
                if(currentEventIds.contains(event.getAcalEventInfo().getId())){
                    //update event
                    AcalEventWrapper updatedEvent = viewHelperService.updateEvent(event.getAcalEventInfo().getId(), event);
                    updatedEvents.add(updatedEvent);
                    currentEventIds.remove(event.getAcalEventInfo().getId());
                }
                else {
                    //create a new event
                    AcalEventWrapper createdEvent = viewHelperService.createEvent(acalId, event);
                    updatedEvents.add(createdEvent);
                }
            }
        }
        acalForm.setEvents(updatedEvents);

        //delete events that have been removed by the user
        if (currentEventIds != null && currentEventIds.size() > 0){
            for(String eventId: currentEventIds){
                //TODO: delete completely from db, when "deleted" state is available, update the event with state ="deleted"
                viewHelperService.deleteEvent(eventId);
            }
        }

    }

    private List<String> getExistingEventIds(AcademicCalendarForm acalForm) throws Exception{
        AcademicCalendarViewHelperService viewHelperService = getAcalViewHelperService(acalForm);
        List<AcalEventWrapper> events = viewHelperService.populateEventWrappers(acalForm.getAcademicCalendarInfo().getId());
        List<String> eventIds = new ArrayList<String>();

        if(events != null && !events.isEmpty()){
            for(AcalEventWrapper event : events){
                eventIds.add(event.getAcalEventInfo().getId());
            }
        }
        return eventIds;
    }


    public AcademicCalendarService getAcalService() {
        if(acalService == null) {
            acalService = (AcademicCalendarService) GlobalResourceLoader.getService(new QName(AcademicCalendarServiceConstants.NAMESPACE, AcademicCalendarServiceConstants.SERVICE_NAME_LOCAL_PART));
        }
        return this.acalService;
    }

    protected AcademicCalendarViewHelperService getAcalViewHelperService(AcademicCalendarForm acalForm){
        AcademicCalendarViewHelperService viewHelperService = (AcademicCalendarViewHelperService)getViewHelperService(acalForm);
        return viewHelperService;
    }

}
