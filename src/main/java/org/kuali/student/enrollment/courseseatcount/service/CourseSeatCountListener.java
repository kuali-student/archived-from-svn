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

import org.apache.cxf.helpers.DOMUtils;
import org.apache.cxf.staxutils.StaxUtils;
import org.kuali.student.enrollment.academicrecord.service.SubscriptionActionEnum;
import org.kuali.student.enrollment.courseoffering.service.CourseOfferingCallbackNamespaceConstants;
import org.kuali.student.enrollment.courseoffering.service.CourseOfferingCallbackService;
import org.kuali.student.enrollment.courseoffering.service.CourseOfferingSubscriptionService;
import org.kuali.student.enrollment.courseoffering.service.cxf.SOAPService;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import javax.xml.namespace.QName;
import javax.xml.ws.Endpoint;
import javax.xml.ws.wsaddressing.W3CEndpointReference;
import java.io.InputStream;
import java.net.URL;

/**
 * @author Kuali Student Team
 */
public class CourseSeatCountListener {
    private static final Logger log = LoggerFactory.getLogger(CourseSeatCountListener.class);

    private static final QName SERVICE_NAME
            = new QName(CourseOfferingCallbackNamespaceConstants.NAMESPACE, "SOAPService");

    CourseOfferingCallbackService courseOfferingCallbackService;

    public void initCallback() {
        String address = "http://localhost:9005/CallbackContext/CourseOfferingCallbackService";
        Endpoint callbackEndpoint = Endpoint.publish(address, courseOfferingCallbackService);
        log.info("CourseSeatCountService published courseOfferingCallbackService UpdateActivityOfferings at address: " + address);

        InputStream is = CourseSeatCountServiceImpl.class.getResourceAsStream("/callback_infoset.xml");
        try {
            Document doc = StaxUtils.read(is);
            Element referenceParameters = (Element) DOMUtils.findChildWithAtt(doc.getDocumentElement(),
                    "wsa:ReferenceParameters",
                    "name", "");

            W3CEndpointReference ref = (W3CEndpointReference) callbackEndpoint.getEndpointReference(referenceParameters);

            URL wsdlURL = this.getClass().getResource("/basic_callback.wsdl");

            SOAPService ss = new SOAPService(wsdlURL, SERVICE_NAME);
            CourseOfferingSubscriptionService port = ss.getSOAPPort();

            log.info("CourseSeatCountService subscribing to AO updates");
            port.subscribeToActivityOfferings(SubscriptionActionEnum.UPDATE, ref, new ContextInfo());
        } catch(Exception e) {
            throw new RuntimeException(e);
        }
    }

    public CourseSeatCountListener(CourseOfferingCallbackService courseOfferingCallbackService) {
        this.courseOfferingCallbackService = courseOfferingCallbackService;
    }
}
