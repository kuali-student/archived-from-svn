
/*
 * 
 */

package org.kuali.student.wsdl.proposal;

import java.net.MalformedURLException;
import java.net.URL;
import javax.xml.namespace.QName;
import javax.xml.ws.WebEndpoint;
import javax.xml.ws.WebServiceClient;
import javax.xml.ws.WebServiceFeature;
import javax.xml.ws.Service;

/**
 * This class was generated by Apache CXF 2.2.10
 * Wed Sep 08 11:26:41 EDT 2010
 * Generated source version: 2.2.10
 * 
 */


@WebServiceClient(name = "ProposalService", 
                  wsdlLocation = "file:/D:/svn/maven-dictionary-generator/trunk/src/main/resources/wsdl/ProposalService.wsdl",
                  targetNamespace = "http://student.kuali.org/wsdl/proposal") 
public class ProposalService_Service extends Service {

    public final static URL WSDL_LOCATION;
    public final static QName SERVICE = new QName("http://student.kuali.org/wsdl/proposal", "ProposalService");
    public final static QName ProposalServicePort = new QName("http://student.kuali.org/wsdl/proposal", "ProposalServicePort");
    static {
        URL url = null;
        try {
            url = new URL("file:/D:/svn/maven-dictionary-generator/trunk/src/main/resources/wsdl/ProposalService.wsdl");
        } catch (MalformedURLException e) {
            System.err.println("Can not initialize the default wsdl from file:/D:/svn/maven-dictionary-generator/trunk/src/main/resources/wsdl/ProposalService.wsdl");
            // e.printStackTrace();
        }
        WSDL_LOCATION = url;
    }

    public ProposalService_Service(URL wsdlLocation) {
        super(wsdlLocation, SERVICE);
    }

    public ProposalService_Service(URL wsdlLocation, QName serviceName) {
        super(wsdlLocation, serviceName);
    }

    public ProposalService_Service() {
        super(WSDL_LOCATION, SERVICE);
    }
    

    /**
     * 
     * @return
     *     returns ProposalService
     */
    @WebEndpoint(name = "ProposalServicePort")
    public ProposalService getProposalServicePort() {
        return super.getPort(ProposalServicePort, ProposalService.class);
    }

    /**
     * 
     * @param features
     *     A list of {@link javax.xml.ws.WebServiceFeature} to configure on the proxy.  Supported features not in the <code>features</code> parameter will have their default values.
     * @return
     *     returns ProposalService
     */
    @WebEndpoint(name = "ProposalServicePort")
    public ProposalService getProposalServicePort(WebServiceFeature... features) {
        return super.getPort(ProposalServicePort, ProposalService.class, features);
    }

}
