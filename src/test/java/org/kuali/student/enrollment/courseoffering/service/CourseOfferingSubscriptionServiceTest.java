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
package org.kuali.student.enrollment.courseoffering.service;

import org.junit.After;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.kuali.student.enrollment.academicrecord.service.SubscriptionActionEnum;
import org.kuali.student.enrollment.courseoffering.dto.ActivityOfferingInfo;
import org.kuali.student.enrollment.courseoffering.dto.CourseOfferingInfo;
import org.kuali.student.enrollment.courseoffering.dto.FormatOfferingInfo;
import org.kuali.student.enrollment.courseseatcount.dto.CourseSeatCountInfo;
import org.kuali.student.enrollment.courseseatcount.service.CourseSeatCountService;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.common.util.constants.CourseOfferingSetServiceConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertTrue;

/**
 * @author Kuali Student Team
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:courseoffering-subscription-service-test.xml"})
public class CourseOfferingSubscriptionServiceTest {
    private static final Logger log = LoggerFactory.getLogger(CourseOfferingSubscriptionServiceTest.class);

    @Resource
    CourseOfferingCallbackService courseOfferingCallbackService;

    @Resource
    CourseOfferingService courseOfferingService;

    @Resource
    CourseOfferingSubscriptionServiceDecorator courseOfferingSubscriptionServiceDecorator;

    @Resource
    CourseSeatCountService courseSeatCountService;

    @Autowired
    CourseOfferingSubscriptionAdvice courseOfferingSubscriptionAdvice;

    private ContextInfo contextInfo;
    private String principalId = "123";

    @org.junit.Before
    public void setUp() {
        principalId = "123";
        contextInfo = new ContextInfo();
        contextInfo.setPrincipalId(principalId);
    }

    @After
    public void cleanup() throws Exception {

    }

    @Test
    public void testCallbackIfAoIsUpdated() throws Exception {

        // client subscribes to AO update events; CourseSeatCountService or CWL service would do this
        courseOfferingSubscriptionServiceDecorator.subscribeToActivityOfferings(SubscriptionActionEnum.UPDATE,
                courseOfferingCallbackService,
                contextInfo);


        String formatId = "1";
        String courseId = "1";
        String activityId = "1";
        String termId = "1";
        String activityOfferingTypeKey = "kuali.lui.type.activity.offering.lecture";
        String courseOfferingTypeKey = "course.offering.type";
        String courseSeatCountTypeKey = "course.seat.count.type";
        String formatOfferingTypeKey = "format.offering.type";
        List<String> optionKeys = new ArrayList<String>();
        optionKeys.add(CourseOfferingSetServiceConstants.USE_CANONICAL_OPTION_KEY);

        CourseOfferingInfo courseOfferingInfo = new CourseOfferingInfo();
        courseOfferingInfo.setTypeKey(courseOfferingTypeKey);

        // On the CO side, a courseOffering is created
        CourseOfferingInfo createdCo = courseOfferingService.createCourseOffering(
                courseId,
                termId,
                courseOfferingTypeKey,
                courseOfferingInfo,
                optionKeys,
                contextInfo);

        ActivityOfferingInfo activityOffering = new ActivityOfferingInfo();
        activityOffering.setTypeKey("kuali.lui.type.activity.offering.lecture");
        activityOffering.setMaximumEnrollment(20);
        activityOffering.setActivityId(activityId);
        activityOffering.setCourseOfferingId(createdCo.getId());


        FormatOfferingInfo formatOffering = new FormatOfferingInfo();
        formatOffering.setTypeKey(formatOfferingTypeKey);
        formatOffering.setCourseOfferingId(createdCo.getId());
        formatOffering.setFormatId(formatId);

        // On the CO side, a formatOffering is created
        FormatOfferingInfo createdFo = courseOfferingService.createFormatOffering(
                createdCo.getId(),
                formatId,
                formatOfferingTypeKey,
                formatOffering,
                contextInfo);

        activityOffering.setFormatOfferingId(createdFo.getId());

        // On the CO side, an activityOffering is created
        ActivityOfferingInfo createdAo = courseOfferingService.createActivityOffering(
                createdFo.getId(),
                activityId,
                activityOfferingTypeKey,
                activityOffering,
                contextInfo);

        CourseSeatCountInfo courseSeatCountInfo = new CourseSeatCountInfo();
        courseSeatCountInfo.setSeats(20);
        courseSeatCountInfo.setActivityOfferingId(createdAo.getId());
        courseSeatCountInfo.setTypeKey(courseSeatCountTypeKey);

        // On the CO side, an courseSeatCount is created
        courseSeatCountService.createCourseSeatCount(courseSeatCountTypeKey, courseSeatCountInfo, contextInfo);

        createdAo.setMaximumEnrollment(30);
        log.info("changing activityOffering " + createdAo.getId() + " maximumEnrollment to " +  createdAo.getMaximumEnrollment());

        // On the CO side, an activityOffering is updated
        courseOfferingService.updateActivityOffering(
                createdAo.getId(),
                createdAo,
                contextInfo);
        Thread.currentThread().sleep(5000);
    }

    public CourseOfferingSubscriptionAdvice getCourseOfferingSubscriptionAdvice() {
        return courseOfferingSubscriptionAdvice;
    }

    public void setCourseOfferingSubscriptionAdvice(CourseOfferingSubscriptionAdvice courseOfferingSubscriptionAdvice) {
        this.courseOfferingSubscriptionAdvice = courseOfferingSubscriptionAdvice;
    }

    public CourseOfferingCallbackService getCourseOfferingCallbackService() {
        return courseOfferingCallbackService;
    }

    public void setCourseOfferingCallbackService(CourseOfferingCallbackService courseOfferingCallbackService) {
        this.courseOfferingCallbackService = courseOfferingCallbackService;
    }

    public CourseOfferingService getCourseOfferingService() {
        return courseOfferingService;
    }

    public void setCourseOfferingService(CourseOfferingService courseOfferingService) {
        this.courseOfferingService = courseOfferingService;
    }

    public CourseOfferingSubscriptionServiceDecorator getCourseOfferingSubscriptionServiceDecorator() {
        return courseOfferingSubscriptionServiceDecorator;
    }

    public void setCourseOfferingSubscriptionServiceDecorator(CourseOfferingSubscriptionServiceDecorator courseOfferingSubscriptionServiceDecorator) {
        this.courseOfferingSubscriptionServiceDecorator = courseOfferingSubscriptionServiceDecorator;
    }
}
