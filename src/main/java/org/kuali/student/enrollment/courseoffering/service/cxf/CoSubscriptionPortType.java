package org.kuali.student.enrollment.courseoffering.service.cxf;

import org.kuali.student.enrollment.courseoffering.service.CourseOfferingCallbackNamespaceConstants;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;
import javax.xml.bind.annotation.XmlSeeAlso;

/**
 * This class was generated by Apache CXF 2.7.12
 * 2014-08-25T09:43:06.061-04:00
 * Generated source version: 2.7.12
 * 
 */
@WebService(targetNamespace = CourseOfferingCallbackNamespaceConstants.NAMESPACE, name = "CoSubscriptionPortType")
@XmlSeeAlso({ObjectFactory.class})
@SOAPBinding(parameterStyle = SOAPBinding.ParameterStyle.BARE)
public interface CoSubscriptionPortType {

    @WebResult(name = "returnType", targetNamespace = CourseOfferingCallbackNamespaceConstants.NAMESPACE, partName = "the_return")
    @WebMethod(operationName = "SubscribeToActivityOfferings")
    public String subscribeToActivityOfferings(
            @WebParam(partName = "callback_object", name = "SubscribeToActivityOfferings", targetNamespace = CourseOfferingCallbackNamespaceConstants.NAMESPACE)
            javax.xml.ws.wsaddressing.W3CEndpointReference callbackObject
    );
}
