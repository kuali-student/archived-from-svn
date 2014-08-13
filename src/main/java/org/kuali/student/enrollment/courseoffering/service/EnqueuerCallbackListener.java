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

import org.apache.activemq.command.ActiveMQObjectMessage;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.common.dto.StatusInfo;
import org.springframework.jms.core.JmsTemplate;

import javax.jms.JMSException;
import javax.jms.ObjectMessage;
import javax.jws.WebParam;
import java.util.List;
import java.util.Queue;

/**
 *
 * @author Kuali Student Team
 */
public class EnqueuerCallbackListener implements CourseOfferingCallbackService {

    private Queue queue;

    private JmsTemplate jmsTemplate;

    public boolean updateCallback (String courseOfferingId) {
//        Event event = new Event ("CO_UPDATE_EVENT_TYPE", courseOfferingId);
//        queue.add(event);
        try {
            ObjectMessage objectMessage = new ActiveMQObjectMessage();
            objectMessage.setObject(courseOfferingId);
            jmsTemplate.convertAndSend("org.kuali.student.enrollment.courseOffering.eventQueue", objectMessage);
        } catch (JMSException e) {
            throw new RuntimeException("Error submitting notification.", e);
        }

        return true;
    }

    @Override
    public StatusInfo newCourseOfferings(List<String> courseOfferingIds, ContextInfo contextInfo) {
        return null;
    }

    @Override
    public StatusInfo updateCourseOfferings(List<String> courseOfferingIds, ContextInfo contextInfo) {
        return null;
    }

    @Override
    public StatusInfo deleteCourseOfferings(List<String> courseOfferingIds, ContextInfo contextInfo) {
        return null;
    }

    @Override
    public StatusInfo newActivityOfferings(List<String> activityOfferingIds, ContextInfo contextInfo) {
        return null;
    }

    @Override
    public StatusInfo updateActivityOfferings(List<String> activityOfferingIds,ContextInfo contextInfo) {
        return null;
    }

    @Override
    public StatusInfo deleteActivityOfferings(List<String> activityOfferingIds,ContextInfo contextInfo) {
        return null;
    }
}
