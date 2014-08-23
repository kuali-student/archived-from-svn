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


import org.apache.activemq.command.ActiveMQMapMessage;
import org.springframework.jms.core.JmsTemplate;

import javax.jms.JMSException;
import javax.jms.MapMessage;

/**
 *
 * @author Kuali Student Team
 */
public class EnqueuerCallbackListener {

    private JmsTemplate jmsTemplate;

    public static final String EVENT_QUEUE = "org.kuali.student.enrollment.courseoffering.eventQueue";

    public static final String EVENT_QUEUE_MESSAGE_OFFERING_ID = "offeringId";

    public static final String EVENT_QUEUE_MESSAGE_METHOD_NAME = "methodName";



    public boolean updateCallback (String offeringId, String methodName) {
        try {

            MapMessage mapMessage = new ActiveMQMapMessage();
            mapMessage.setStringProperty(EVENT_QUEUE_MESSAGE_OFFERING_ID, offeringId);
            mapMessage.setStringProperty(EVENT_QUEUE_MESSAGE_METHOD_NAME, methodName);
            jmsTemplate.convertAndSend(EVENT_QUEUE, mapMessage);

        } catch (JMSException e) {
            throw new RuntimeException("Error submitting notification.", e);
        }

        return true;
    }

    protected JmsTemplate getJmsTemplate() {
        return jmsTemplate;
    }

    public void setJmsTemplate(JmsTemplate jmsTemplate) {
        this.jmsTemplate = jmsTemplate;
    }

}
