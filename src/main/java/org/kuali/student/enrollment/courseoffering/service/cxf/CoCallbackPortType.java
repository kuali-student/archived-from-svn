package org.kuali.student.enrollment.courseoffering.service.cxf;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;
import javax.xml.bind.annotation.XmlSeeAlso;

/**
 * This class was generated by Apache CXF 2.7.12
 * 2014-08-25T09:43:06.034-04:00
 * Generated source version: 2.7.12
 * 
 */
@WebService(targetNamespace = "http://apache.org/callback", name = "CoCallbackPortType")
@XmlSeeAlso({ObjectFactory.class})
@SOAPBinding(parameterStyle = SOAPBinding.ParameterStyle.BARE)
public interface CoCallbackPortType {

    @WebResult(name = "returnType", targetNamespace = "http://apache.org/callback", partName = "the_return")
    @WebMethod(operationName = "UpdateActivityOfferings")
    public String updateActivityOfferings(
            @WebParam(partName = "return_message", name = "callback_message", targetNamespace = "http://apache.org/callback")
            String returnMessage
    );
}
