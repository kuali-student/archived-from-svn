/*
 * Copyright 2011 The Kuali Foundation
 *
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may	obtain a copy of the License at
 *
 * 	http://www.osedu.org/licenses/ECL-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.kuali.student.service.remote.impl;

import java.net.MalformedURLException;
import java.net.URL;
import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import org.kuali.student.r2.lum.lrc.service.LRCService;
import org.kuali.student.r2.lum.lrc.service.LRCServiceDecorator;
import org.kuali.student.r2.lum.util.constants.LrcServiceConstants;

public class LRCServiceRemoteImpl extends LRCServiceDecorator {

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
            String urlStr = hostUrl + "/services/" + LrcServiceConstants.SERVICE_NAME_LOCAL_PART + "?wsdl";
            wsdlURL = new URL(urlStr);
        } catch (MalformedURLException ex) {
            throw new IllegalArgumentException(ex);
        }
        QName qname = new QName(LrcServiceConstants.NAMESPACE, LrcServiceConstants.SERVICE_NAME_LOCAL_PART);
        Service factory = Service.create(wsdlURL, qname);
        LRCService port = factory.getPort(LRCService.class);
        this.setNextDecorator(port);
    }
}
