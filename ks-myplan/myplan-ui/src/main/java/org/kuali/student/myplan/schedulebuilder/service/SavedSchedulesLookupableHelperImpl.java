package org.kuali.student.myplan.schedulebuilder.service;

import org.apache.log4j.Logger;
import org.kuali.rice.krad.web.form.LookupForm;
import org.kuali.student.ap.framework.config.KsapFrameworkServiceLocator;
import org.kuali.student.ap.framework.context.TermHelper;
import org.kuali.student.enrollment.acal.infc.Term;
import org.kuali.student.myplan.config.UwMyplanServiceLocator;
import org.kuali.student.myplan.main.service.MyPlanLookupableImpl;
import org.kuali.student.myplan.plan.PlanConstants;
import org.kuali.student.myplan.plan.util.PlanHelper;
import org.kuali.student.myplan.schedulebuilder.dto.ActivityOptionInfo;
import org.kuali.student.myplan.schedulebuilder.dto.PossibleScheduleOptionInfo;
import org.kuali.student.myplan.schedulebuilder.dto.SecondaryActivityOptionsInfo;
import org.kuali.student.myplan.schedulebuilder.infc.*;
import org.kuali.student.myplan.schedulebuilder.util.PossibleScheduleErrorsInfo;
import org.kuali.student.myplan.schedulebuilder.util.ScheduleBuildHelper;
import org.kuali.student.myplan.schedulebuilder.util.ScheduleBuildStrategy;
import org.kuali.student.myplan.schedulebuilder.util.ScheduleBuilderConstants;
import org.kuali.student.myplan.utils.UserSessionHelper;
import org.kuali.student.r2.common.exceptions.PermissionDeniedException;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.io.InputStream;
import java.util.*;

/**
 * Created by hemanthg on 2/7/14.
 */
public class SavedSchedulesLookupableHelperImpl extends MyPlanLookupableImpl {

    private ScheduleBuildStrategy scheduleBuildStrategy;

    private UserSessionHelper userSessionHelper;

    private ScheduleBuildHelper scheduleBuildHelper;

    private TermHelper termHelper;

    private PlanHelper planHelper;

    private final Logger logger = Logger.getLogger(SavedSchedulesLookupableHelperImpl.class);

    @Override
    protected List<PossibleScheduleOption> getSearchResults(LookupForm lookupForm, Map<String, String> fieldValues, boolean unbounded) {
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        String termId = request.getParameter(PlanConstants.TERM_ID_KEY);
        String requestedLearningPlanId = request.getParameter(ScheduleBuilderConstants.LEARNING_PLAN_KEY);

        ScheduleBuildStrategy sb = getScheduleBuildStrategy();
        List<PossibleScheduleOption> savedSchedulesList = new ArrayList<PossibleScheduleOption>();
        if (StringUtils.hasText(termId) && StringUtils.hasText(requestedLearningPlanId)) {

            Term term = getTermHelper().getTermByAtpId(termId);
            List<PossibleScheduleOption> savedSchedules;
            try {
                savedSchedules = sb.getSchedules(requestedLearningPlanId);
            } catch (PermissionDeniedException e) {
                throw new IllegalStateException(
                        "Failed to refresh saved schedules", e);
            }

            Map<String, String> plannedItems = getPlanHelper().getPlanItemIdAndRefObjIdByRefObjType(requestedLearningPlanId, PlanConstants.SECTION_TYPE, termId);
            List<ReservedTime> reservedTimes = null;
            try {
                reservedTimes = getScheduleBuildStrategy().getReservedTimes(requestedLearningPlanId);
            } catch (PermissionDeniedException e) {
                e.printStackTrace();
            }

            for (PossibleScheduleOption possibleScheduleOption : savedSchedules) {
                if (termId.equals(possibleScheduleOption.getTermId())) {
                    PossibleScheduleErrorsInfo possibleScheduleErrorsInfo = new PossibleScheduleErrorsInfo();
                    Map<String, Map<String, List<String>>> invalidOptions = new LinkedHashMap<String, Map<String, List<String>>>();
                    List<ActivityOption> validatedActivities = validatedSavedActivities(possibleScheduleOption.getActivityOptions(), plannedItems, invalidOptions, reservedTimes == null ? new ArrayList<ReservedTime>() : reservedTimes);
                    if (!CollectionUtils.isEmpty(validatedActivities)) {
                        if (!CollectionUtils.isEmpty(invalidOptions)) {
                            possibleScheduleErrorsInfo.setErrorType(ScheduleBuilderConstants.PINNED_SCHEDULES_PASSIVE_ERROR);
                            possibleScheduleErrorsInfo.setInvalidOptions(invalidOptions);
                        }
                    } else {
                        possibleScheduleErrorsInfo.setErrorType(ScheduleBuilderConstants.PINNED_SCHEDULES_MODAL_ERROR);
                        possibleScheduleErrorsInfo.setInvalidOptions(invalidOptions);
                    }
                    ((PossibleScheduleOptionInfo) possibleScheduleOption).setPossibleErrors(possibleScheduleErrorsInfo);
                    getScheduleBuildHelper().buildPossibleScheduleEvents(possibleScheduleOption, term);
                    savedSchedulesList.add(possibleScheduleOption);
                }
            }
        } else {
            logger.error("Missing required parameters termId and LearningPlanId");
        }
        return savedSchedulesList;
    }


    /**
     * Validates Saved activities against current versions.
     *
     * @param activityOptions
     * @param plannedItems
     * @param invalidOptions
     * @return ActivityOption list which are validated items and also populates all invalidActivityOptions course code wise.
     */
    protected List<ActivityOption> validatedSavedActivities(List<ActivityOption> activityOptions, Map<String, String> plannedItems, Map<String, Map<String, List<String>>> invalidOptions, List<ReservedTime> reservedTimes) {
        List<ActivityOption> activityOptionList = new ArrayList<ActivityOption>();
        for (ActivityOption savedActivity : activityOptions) {
            List<ActivityOption> validatedAlternates = new ArrayList<ActivityOption>();
            if (!CollectionUtils.isEmpty(savedActivity.getSecondaryOptions())) {
                boolean isValid = true;
                for (SecondaryActivityOptions secondaryActivityOption : savedActivity.getSecondaryOptions()) {

                    List<ActivityOption> validatedSecondaryActivities = validatedSavedActivities(secondaryActivityOption.getActivityOptions(), plannedItems, invalidOptions, reservedTimes);
                    if (!CollectionUtils.isEmpty(secondaryActivityOption.getActivityOptions()) && CollectionUtils.isEmpty(validatedSecondaryActivities)) {
                        isValid = false;
                        break;
                    } else {
                        ((SecondaryActivityOptionsInfo) secondaryActivityOption).setActivityOptions(validatedSecondaryActivities);
                    }
                }
                /*NO secondaries available for this primary are available*/
                if (!isValid) {
                    if (invalidOptions == null) {
                        invalidOptions = new HashMap<String, Map<String, List<String>>>();
                    }
                    Map<String, List<String>> errorList = invalidOptions.get(savedActivity.getCourseCd());
                    if (errorList == null) {
                        errorList = new HashMap<String, List<String>>();
                        errorList.put(ScheduleBuilderConstants.PINNED_SCHEDULES_ERROR_REASON_NO_SECONDARIES, new ArrayList<String>());
                    }
                    List<String> activityList = errorList.get(ScheduleBuilderConstants.PINNED_SCHEDULES_ERROR_REASON_NO_SECONDARIES);
                    if (CollectionUtils.isEmpty(activityList)) {
                        activityList = new ArrayList<String>();
                    }
                    activityList.add(savedActivity.getActivityOfferingId());
                    errorList.put(ScheduleBuilderConstants.PINNED_SCHEDULES_ERROR_REASON_NO_SECONDARIES, activityList);
                    invalidOptions.put(savedActivity.getCourseCd(), errorList);
                    continue;
                }
            } else {
                validatedAlternates = savedActivity.getAlternateActivties() == null ? new ArrayList<ActivityOption>() : validatedSavedActivities(savedActivity.getAlternateActivties(), plannedItems, invalidOptions, reservedTimes);
            }

            ActivityOption currentActivity = getScheduleBuildStrategy().getActivityOption(savedActivity.getTermId(), savedActivity.getCourseId(), savedActivity.getActivityCode());
            String reasonForChange = areEqual(savedActivity, currentActivity, plannedItems, reservedTimes);
            if (StringUtils.isEmpty(reasonForChange)) {
                ((ActivityOptionInfo) savedActivity).setAlternateActivities(validatedAlternates);
                activityOptionList.add(savedActivity);
            } else if (StringUtils.hasText(reasonForChange) && !CollectionUtils.isEmpty(validatedAlternates)) {
                ActivityOptionInfo alAo = (ActivityOptionInfo) validatedAlternates.get(0);
                validatedAlternates.remove(0);
                alAo.setAlternateActivities(validatedAlternates.size() > 0 ? validatedAlternates : new ArrayList<ActivityOption>());
                activityOptionList.add(alAo);
            } else {
                if (invalidOptions == null) {
                    invalidOptions = new HashMap<String, Map<String, List<String>>>();
                }
                Map<String, List<String>> errorList = invalidOptions.get(savedActivity.getCourseCd());
                if (errorList == null) {
                    errorList = new HashMap<String, List<String>>();
                    errorList.put(reasonForChange, new ArrayList<String>());
                }
                List<String> activityList = errorList.get(reasonForChange);
                if (CollectionUtils.isEmpty(activityList)) {
                    activityList = new ArrayList<String>();
                }
                activityList.add(savedActivity.getActivityOfferingId());
                errorList.put(reasonForChange, activityList);
                invalidOptions.put(savedActivity.getCourseCd(), errorList);

            }
        }

        return activityOptionList;

    }


    /**
     * Compares the saved ActivityOption with withdrawnFlag, current ActivityOption, plannedActivities and ReservedTimes
     *
     * @param saved
     * @param current
     * @param plannedItems
     * @return (((savedStatusOpen but currentStatusClosed) OR currentIsWithdrawn OR ((currentMeeting and savedMeeting times vary) OR (reservedTime and savedMeeting time conflict))) AND savedActivity is not in PlannedActivities) then false otherwise true.
     */
    private String areEqual(ActivityOption saved, ActivityOption current, Map<String, String> plannedItems, List<ReservedTime> reservedTimes) {
        long[][] savedClassMeetingTime = getScheduleBuildHelper().xlateClassMeetingTimeList2WeekBits(saved.getClassMeetingTimes());
        long[][] currentClassMeetingTime = getScheduleBuildHelper().xlateClassMeetingTimeList2WeekBits(current.getClassMeetingTimes());
        long[][] reservedTime = getScheduleBuildHelper().xlateClassMeetingTimeList2WeekBits(reservedTimes);
        if (!plannedItems.containsKey(saved.getActivityOfferingId())) {
            if (current.isWithdrawn()) {
                return ScheduleBuilderConstants.PINNED_SCHEDULES_ERROR_REASON_WITHDRAWN;
            } else if (!Arrays.deepEquals(savedClassMeetingTime, currentClassMeetingTime)) {
                return ScheduleBuilderConstants.PINNED_SCHEDULES_ERROR_REASON_TIME_CHANGED;
            } else if (getScheduleBuildHelper().checkForConflictsWeeks(savedClassMeetingTime, reservedTime)) {
                return ScheduleBuilderConstants.PINNED_SCHEDULES_ERROR_REASON_CONFLICTS_RESERVED;
            }
        }
        return null;
    }


    public ScheduleBuildStrategy getScheduleBuildStrategy() {
        if (scheduleBuildStrategy == null) {
            scheduleBuildStrategy = UwMyplanServiceLocator.getInstance().getScheduleBuildStrategy();
        }
        return scheduleBuildStrategy;
    }

    public void setScheduleBuildStrategy(ScheduleBuildStrategy scheduleBuildStrategy) {
        this.scheduleBuildStrategy = scheduleBuildStrategy;
    }

    public UserSessionHelper getUserSessionHelper() {
        if (userSessionHelper == null) {
            userSessionHelper = UwMyplanServiceLocator.getInstance().getUserSessionHelper();
        }
        return userSessionHelper;
    }

    public void setUserSessionHelper(UserSessionHelper userSessionHelper) {
        this.userSessionHelper = userSessionHelper;
    }

    public TermHelper getTermHelper() {
        if (termHelper == null) {
            termHelper = KsapFrameworkServiceLocator.getTermHelper();
        }
        return termHelper;
    }

    public void setTermHelper(TermHelper termHelper) {
        this.termHelper = termHelper;
    }

    public PlanHelper getPlanHelper() {
        if (planHelper == null) {
            planHelper = UwMyplanServiceLocator.getInstance().getPlanHelper();
        }
        return planHelper;
    }

    public void setPlanHelper(PlanHelper planHelper) {
        this.planHelper = planHelper;
    }

    public ScheduleBuildHelper getScheduleBuildHelper() {
        if (scheduleBuildHelper == null) {
            scheduleBuildHelper = UwMyplanServiceLocator.getInstance().getScheduleBuildHelper();
        }
        return scheduleBuildHelper;
    }

    public void setScheduleBuildHelper(ScheduleBuildHelper scheduleBuildHelper) {
        this.scheduleBuildHelper = scheduleBuildHelper;
    }
}
