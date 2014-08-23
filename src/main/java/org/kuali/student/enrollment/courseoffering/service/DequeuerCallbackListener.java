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

import org.apache.activemq.command.DestinationInfo;
import org.kuali.student.enrollment.academicrecord.service.SubscriptionActionEnum;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.common.dto.StatusInfo;
import org.kuali.student.r2.common.exceptions.DoesNotExistException;
import org.kuali.student.r2.common.exceptions.InvalidParameterException;
import org.kuali.student.r2.common.exceptions.MissingParameterException;
import org.kuali.student.r2.common.exceptions.OperationFailedException;
import org.kuali.student.r2.common.exceptions.PermissionDeniedException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import javax.jms.JMSException;
import javax.jms.MapMessage;
import javax.jms.Message;
import javax.jms.MessageListener;
import javax.jms.Queue;
import javax.jws.WebParam;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import javax.jms.Session;

/**
 *
 * @author Kuali Student Team
 */
public class DequeuerCallbackListener implements CourseOfferingSubscriptionService, MessageListener {
    private static final Logger log = LoggerFactory.getLogger(DequeuerCallbackListener.class);

    @Resource
    CourseOfferingCallbackService courseOfferingCallbackService;

    private Set<CourseOfferingCallbackService> callbacks = new HashSet<CourseOfferingCallbackService>();

    @Override
    public String subscribeToActivityOfferings(SubscriptionActionEnum action, CourseOfferingCallbackService courseOfferingCallbackService, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {

        return null;
    }

    @Override
    public String subscribeToActivityOfferingsByTerm( SubscriptionActionEnum action, String termId, CourseOfferingCallbackService courseOfferingCallbackService, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return null;
    }

    @Override
    public String subscribeToActivityOfferingsByActivity(SubscriptionActionEnum action, String activityId, CourseOfferingCallbackService courseOfferingCallbackService, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return null;
    }

    @Override
    public String subscribeToActivityOfferingsByType( SubscriptionActionEnum action, String activityOfferingTypeKey, CourseOfferingCallbackService courseOfferingCallbackService, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return null;
    }

    @Override
    public String subscribeToCourseOfferings( SubscriptionActionEnum action, CourseOfferingCallbackService courseOfferingCallbackService, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return null;
    }

    @Override
    public String subscribeToCourseOfferingsByIds( SubscriptionActionEnum action, List<String> courseOfferingIds, CourseOfferingCallbackService courseOfferingCallbackService, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return null;
    }

    @Override
    public String subscribeToCourseOfferingsByTerm( SubscriptionActionEnum action, String termId, CourseOfferingCallbackService courseOfferingCallbackService, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return null;
    }

    @Override
    public String subscribeToCourseOfferingsByCourse( SubscriptionActionEnum action, String courseId, CourseOfferingCallbackService courseOfferingCallbackService, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return null;
    }

    @Override
    public String subscribeToCourseOfferingsByType( SubscriptionActionEnum action, String courseOfferingTypeKey, CourseOfferingCallbackService courseOfferingCallbackService, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return null;
    }

    @Override
    public StatusInfo removeSubscription( String subscriptionId, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return null;
    }

    @Override
    @Transactional
    public void onMessage(Message message) {
        try {
            String methodName = message.getStringProperty(EnqueuerCallbackListener.EVENT_QUEUE_MESSAGE_METHOD_NAME);
            String offeringId = message.getStringProperty(EnqueuerCallbackListener.EVENT_QUEUE_MESSAGE_OFFERING_ID);

            if("updateActivityOffering".equals(methodName)) {
                courseOfferingCallbackService.updateActivityOfferings(Arrays.asList(new String[] { offeringId }), new ContextInfo());
            } else {
                log.warn(methodName + " not supported");
            }
        } catch(JMSException e) {
            throw new RuntimeException(e);
        }
    }

    public CourseOfferingCallbackService getCourseOfferingCallbackService() {
        return courseOfferingCallbackService;
    }

    public void setCourseOfferingCallbackService(CourseOfferingCallbackService courseOfferingCallbackService) {
        this.courseOfferingCallbackService = courseOfferingCallbackService;
    }
}
