/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.kuali.student.service.remote.impl;

import java.net.MalformedURLException;
import java.net.URL;
import javax.xml.namespace.QName;
import org.kuali.student.r2.core.class1.type.service.TypeService;
import javax.xml.ws.Service;
import org.kuali.student.r2.core.class1.type.decorators.TypeServiceDecorator;
import org.kuali.student.r2.core.constants.TypeServiceConstants;

/**
 *
 * @author nwright
 */
public class TypeServiceRemoteImpl extends TypeServiceDecorator {

    private String hostUrl;

    public String getHostUrl() {
        return hostUrl;
    }

    public void setHostUrl(String hostUrl) {
        this.hostUrl = hostUrl;
        if (hostUrl == null) {
            this.setNextDecorator(null);
            return;
        }    
        URL wsdlURL;
        try {
            String urlStr = hostUrl + "/services/" + TypeServiceConstants.SERVICE_NAME_LOCAL_PART + "?wsdl";
            wsdlURL = new URL(urlStr);
        } catch (MalformedURLException ex) {
            throw new IllegalArgumentException(ex);
        }
        QName qname = new QName(TypeServiceConstants.NAMESPACE, TypeServiceConstants.SERVICE_NAME_LOCAL_PART);
        Service factory = Service.create(wsdlURL, qname);
        TypeService port = factory.getPort(TypeService.class);
        this.setNextDecorator(port);
    }
}
