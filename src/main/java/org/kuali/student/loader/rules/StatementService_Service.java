
/*
 * 
 */
package org.kuali.student.loader.rules;

import org.kuali.rice.krms.api.KrmsConstants;

import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import javax.xml.ws.WebEndpoint;
import javax.xml.ws.WebServiceClient;
import javax.xml.ws.WebServiceFeature;
import java.net.MalformedURLException;
import java.net.URL;

/**
 * @author christoff.botha
 */
@WebServiceClient(name = "StatementService",
        wsdlLocation =
                "file://home/christoff/Developer/workspaces/trunk/ks-api/ks-core-api/src/main/resources/META-INF/wsdl/StatementService.wsdl",
        targetNamespace = "http://student.kuali.org/wsdl/statement")
public class StatementService_Service extends Service {

    public final static URL WSDL_LOCATION;
    public final static QName SERVICE = new QName(
            "http://student.kuali.org/wsdl/statement", "StatementService");
    public final static QName statementServicePort = new QName(
            "http://student.kuali.org/wsdl/statement", "StatementServicePort");

    static {
        URL url = null;
        try {
            url =
                    new URL(
                            "file://home/christoff/Developer/workspaces/trunk/ks-api/ks-core-api/src/main/resources/META-INF/wsdl/StatementService.wsdl");
        } catch (MalformedURLException e) {
            System.err.println(
                    "Can not initialize the default wsdl from file");
            // e.printStackTrace();
        }
        WSDL_LOCATION = url;
    }

    public StatementService_Service(URL wsdlLocation) {
        super(wsdlLocation, SERVICE);
    }

    public StatementService_Service(URL wsdlLocation, QName serviceName) {
        super(wsdlLocation, serviceName);
    }

    public StatementService_Service() {
        super(WSDL_LOCATION, SERVICE);
    }

    /**
     * @return returns StatementService
     */
    @WebEndpoint(name = "StatementServicePort")
    public StatementService getServicePort() {
        return super.getPort(statementServicePort, StatementService.class);
    }

    /**
     * @param features A list of {@link javax.xml.ws.WebServiceFeature} to configure on the proxy.  Supported features not in the <code>features</code> parameter will have their default values.
     * @return returns StatementService
     */
    @WebEndpoint(name = "StatementServicePort")
    public StatementService getServicePort(WebServiceFeature... features) {
        return super.getPort(statementServicePort, StatementService.class, features);
    }
}
