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

import javax.jms.Queue;
import javax.jws.WebParam;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import javax.jms.Session;

/**
 *
 * @author Kuali Student Team
 */
public class DequeuerCallbackListener implements CourseOfferingSubscriptionService {
    private Queue queue;



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


/*    public void init () {
        queue.registerAsListenerForEventType ("CO_UPDATE_ENVENT_TYPE");
    }
*/
}
