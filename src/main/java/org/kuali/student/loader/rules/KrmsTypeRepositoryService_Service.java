
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
@WebServiceClient(name = "KRMSTypeService",
        wsdlLocation =
                "file://home/christoff/Developer/workspaces/trunk/ks-api/ks-enroll-api/src/main/resources/META-INF/wsdl/KrmsTypeRepositoryService.wsdl",
        targetNamespace = KrmsConstants.Namespaces.KRMS_NAMESPACE_2_0)
public class KrmsTypeRepositoryService_Service extends Service {

    public final static URL WSDL_LOCATION;
    public final static QName SERVICE = new QName(
            KrmsConstants.Namespaces.KRMS_NAMESPACE_2_0, "KRMSTypeService");
    public final static QName krmsTypeServicePort = new QName(
            KrmsConstants.Namespaces.KRMS_NAMESPACE_2_0, "KRMSTypeServicePort");

    static {
        URL url = null;
        try {
            url =
                    new URL(
                            "file://home/christoff/Developer/workspaces/trunk/ks-api/ks-enroll-api/src/main/resources/META-INF/wsdl/KrmsTypeRepositoryService.wsdl");
        } catch (MalformedURLException e) {
            System.err.println(
                    "Can not initialize the default wsdl from file");
            // e.printStackTrace();
        }
        WSDL_LOCATION = url;
    }

    public KrmsTypeRepositoryService_Service(URL wsdlLocation) {
        super(wsdlLocation, SERVICE);
    }

    public KrmsTypeRepositoryService_Service(URL wsdlLocation, QName serviceName) {
        super(wsdlLocation, serviceName);
    }

    public KrmsTypeRepositoryService_Service() {
        super(WSDL_LOCATION, SERVICE);
    }

    /**
     * @return returns KrmsTypeRepositoryService
     */
    @WebEndpoint(name = "KRMSTypeServicePort")
    public KrmsTypeRepositoryService getServicePort() {
        return super.getPort(krmsTypeServicePort, KrmsTypeRepositoryService.class);
    }

    /**
     * @param features A list of {@link javax.xml.ws.WebServiceFeature} to configure on the proxy.  Supported features not in the <code>features</code> parameter will have their default values.
     * @return returns KrmsTypeRepositoryService
     */
    @WebEndpoint(name = "KRMSTypeServicePort")
    public KrmsTypeRepositoryService getServicePort(WebServiceFeature... features) {
        return super.getPort(krmsTypeServicePort, KrmsTypeRepositoryService.class, features);
    }
}
