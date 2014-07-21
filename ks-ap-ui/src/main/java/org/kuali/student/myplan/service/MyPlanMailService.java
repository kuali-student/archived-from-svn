package org.kuali.student.myplan.service;

import javax.mail.MessagingException;

import org.kuali.rice.core.api.mail.MailMessage;
import org.kuali.rice.krad.exception.InvalidAddressException;

public interface MyPlanMailService {
    public final String SERVICE_NAME = "{MyPlan}MailService";
    public final String MODE_CONFIG_PROPERTY_NAME = "myplan.mailService.testMode";
    public final String TEST_MODE_TO_ADDRESS="myplan.comment.toAddress";
    public void sendMessage(MailMessage message) throws InvalidAddressException, MessagingException;
}
