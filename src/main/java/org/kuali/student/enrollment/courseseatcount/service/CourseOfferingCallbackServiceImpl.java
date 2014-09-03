/**
 * Copyright 2014 The Kuali Foundation Licensed under the Educational Community License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.osedu.org/licenses/ECL-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS"
 * BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 *
 */
package org.kuali.student.enrollment.courseseatcount.service;

import org.kuali.student.enrollment.courseoffering.dto.ActivityOfferingInfo;
import org.kuali.student.enrollment.courseoffering.service.CourseOfferingCallbackNamespaceConstants;
import org.kuali.student.enrollment.courseoffering.service.CourseOfferingCallbackService;
import org.kuali.student.enrollment.courseoffering.service.CourseOfferingService;
import org.kuali.student.enrollment.courseseatcount.dto.CourseSeatCountInfo;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.common.dto.StatusInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.annotation.Resource;
import javax.jws.WebParam;
import java.util.List;

/**
 * @author Kuali Student Team
 */
@javax.jws.WebService(serviceName = "CourseOfferingCallbackService",
        portName = "CourseOfferingCallbackService",
        endpointInterface = "org.kuali.student.enrollment.courseoffering.service.CourseOfferingCallbackService",
        targetNamespace = CourseOfferingCallbackNamespaceConstants.NAMESPACE)
public class CourseOfferingCallbackServiceImpl implements CourseOfferingCallbackService {
    private static final Logger log = LoggerFactory.getLogger(CourseOfferingCallbackServiceImpl.class);

    @Resource
    CourseSeatCountService courseSeatCountService;

    @Resource
    CourseOfferingService courseOfferingService;

    public CourseOfferingCallbackServiceImpl() {
        super();
    }

    public CourseOfferingCallbackServiceImpl(CourseSeatCountService courseSeatCountService, CourseOfferingService courseOfferingService) {
        this.setCourseSeatCountService(courseSeatCountService);
        this.setCourseOfferingService(courseOfferingService);
    }

    @Override
    public StatusInfo createCourseOfferings(List<String> courseOfferingIds, ContextInfo contextInfo) {

        StatusInfo statusInfo = new StatusInfo();
        statusInfo.setSuccess(true);
        return statusInfo;
    }

    @Override
    public StatusInfo updateCourseOfferings(List<String> courseOfferingIds, ContextInfo contextInfo) {
        log.info("callback received notification for updateCourseOffering event ");
        for(String courseOfferingId : courseOfferingIds) {
            log.info("updated courseOfferingId: " + courseOfferingId);
        }
        StatusInfo statusInfo = new StatusInfo();
        statusInfo.setSuccess(true);
        return statusInfo;
    }

    @Override
    public StatusInfo deleteCourseOfferings(List<String> courseOfferingIds, ContextInfo contextInfo) {
        StatusInfo statusInfo = new StatusInfo();
        statusInfo.setSuccess(true);
        return statusInfo;
    }

    @Override
    public StatusInfo createActivityOfferings(List<String> activityOfferingIds, ContextInfo contextInfo) {
        StatusInfo statusInfo = new StatusInfo();
        statusInfo.setSuccess(true);
        return statusInfo;
    }

    @Override
    public StatusInfo updateActivityOfferings(@WebParam(partName = "return_message", name = "callback_message",
                                                        targetNamespace = CourseOfferingCallbackNamespaceConstants.NAMESPACE)
                                                        List<String> activityOfferingIds,
                                              @WebParam(name = "contextInfo")ContextInfo contextInfo) {

        log.info("callback received notification for updateActivityOfferings event ");
        for(String activityOfferingId : activityOfferingIds) {
            log.info("updated activityOfferingId: " + activityOfferingId);
            try {
                ActivityOfferingInfo activityOfferingInfo = courseOfferingService.getActivityOffering(activityOfferingId, contextInfo);
                CourseSeatCountInfo courseSeatCountInfo =
                        courseSeatCountService.getCourseSeatCountByActivityOffering(activityOfferingId, contextInfo);

                handleMaxEnrollmentChange(activityOfferingInfo, courseSeatCountInfo, contextInfo);
                handleAoReinstated(activityOfferingInfo, contextInfo);
                handleNewAoOffering(activityOfferingInfo, contextInfo);

            } catch(Exception e) {
                log.error("Exception occurred in callback", e);
            }
        }
        StatusInfo statusInfo = new StatusInfo();
        statusInfo.setSuccess(true);
        return statusInfo;
    }

    protected void handleMaxEnrollmentChange(ActivityOfferingInfo activityOfferingInfo,
                                       CourseSeatCountInfo courseSeatCountInfo,
                                       ContextInfo contextInfo) throws Exception {

        if(!courseSeatCountInfo.getSeats().equals(activityOfferingInfo.getMaximumEnrollment())) {
            log.info("updating courseSeatCountInfo.seats from " + courseSeatCountInfo.getSeats()
                    + " to " + activityOfferingInfo.getMaximumEnrollment()
                    + " for activityOffering " + activityOfferingInfo.getId());
            courseSeatCountInfo.setSeats(activityOfferingInfo.getMaximumEnrollment());
            courseSeatCountService.updateCourseSeatCount(courseSeatCountInfo.getId(), courseSeatCountInfo, contextInfo);
        }
    }

    protected void handleAoReinstated(ActivityOfferingInfo activityOfferingInfo,
                                       ContextInfo contextInfo) throws Exception {

        // if AO state changed from Suspended to Offered (reinstated), trigger CourseWaitList processing

        return;
    }

    protected void handleNewAoOffering(ActivityOfferingInfo activityOfferingInfo,
                                       ContextInfo contextInfo) throws Exception {

        // or if new AO becomes offered, trigger CourseWaitList processing

        return;
    }


    @Override
    public StatusInfo deleteActivityOfferings(List<String> activityOfferingIds, ContextInfo contextInfo) {
        StatusInfo statusInfo = new StatusInfo();
        statusInfo.setSuccess(true);
        return statusInfo;
    }

    public CourseSeatCountService getCourseSeatCountService() {
        return courseSeatCountService;
    }

    public void setCourseSeatCountService(CourseSeatCountService courseSeatCountService) {
        this.courseSeatCountService = courseSeatCountService;
    }

    public CourseOfferingService getCourseOfferingService() {
        return courseOfferingService;
    }

    public void setCourseOfferingService(CourseOfferingService courseOfferingService) {
        this.courseOfferingService = courseOfferingService;
    }
}
