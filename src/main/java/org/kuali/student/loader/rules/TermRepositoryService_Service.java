
/*
 * 
 */
package org.kuali.student.loader.rules;

import org.kuali.rice.krms.api.KrmsConstants;
import org.kuali.rice.krms.api.repository.term.TermRepositoryService;

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
@WebServiceClient(name = "termRepositoryService",
        wsdlLocation =
                "file://home/christoff/Developer/workspaces/trunk/ks-api/ks-enroll-api/src/main/resources/META-INF/wsdl/TermRepositoryService.wsdl",
        targetNamespace = KrmsConstants.Namespaces.KRMS_NAMESPACE_2_0)
public class TermRepositoryService_Service extends Service {

    public final static URL WSDL_LOCATION;
    public final static QName SERVICE = new QName(
            KrmsConstants.Namespaces.KRMS_NAMESPACE_2_0, "termRepositoryService");
    public final static QName termRepositoryServicePort = new QName(
            KrmsConstants.Namespaces.KRMS_NAMESPACE_2_0, "termRepositoryServicePort");

    static {
        URL url = null;
        try {
            url =
                    new URL(
                            "file://home/christoff/Developer/workspaces/trunk/ks-api/ks-enroll-api/src/main/resources/META-INF/wsdl/TermRepositoryService.wsdl");
        } catch (MalformedURLException e) {
            System.err.println(
                    "Can not initialize the default wsdl from file");
            // e.printStackTrace();
        }
        WSDL_LOCATION = url;
    }

    public TermRepositoryService_Service(URL wsdlLocation) {
        super(wsdlLocation, SERVICE);
    }

    public TermRepositoryService_Service(URL wsdlLocation, QName serviceName) {
        super(wsdlLocation, serviceName);
    }

    public TermRepositoryService_Service() {
        super(WSDL_LOCATION, SERVICE);
    }

    /**
     * @return returns TermRepositoryService
     */
    @WebEndpoint(name = "termRepositoryServicePort")
    public TermRepositoryService getServicePort() {
        return super.getPort(termRepositoryServicePort, TermRepositoryService.class);
    }

    /**
     * @param features A list of {@link javax.xml.ws.WebServiceFeature} to configure on the proxy.  Supported features not in the <code>features</code> parameter will have their default values.
     * @return returns TermRepositoryService
     */
    @WebEndpoint(name = "termRepositoryServicePort")
    public TermRepositoryService getServicePort(WebServiceFeature... features) {
        return super.getPort(termRepositoryServicePort, TermRepositoryService.class, features);
    }
}
