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
import org.springframework.jms.core.JmsTemplate;

import javax.jms.JMSException;
import javax.jms.ObjectMessage;

/**
 *
 * @author Kuali Student Team
 */
public class EnqueuerCallbackListener {

    private JmsTemplate jmsTemplate;

    public boolean updateCallback (String offeringId) {
        try {
            ObjectMessage objectMessage = new ActiveMQObjectMessage();
            objectMessage.setObject(offeringId);
//            jmsTemplate.convertAndSend("org.kuali.student.enrollment.courseOffering.eventQueue", objectMessage);
        } catch (JMSException e) {
            throw new RuntimeException("Error submitting notification.", e);
        }

        return true;
    }
}
