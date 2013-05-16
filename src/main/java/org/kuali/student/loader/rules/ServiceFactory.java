/*
 * Copyright 2010 The Kuali Foundation
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
package org.kuali.student.loader.rules;

import org.kuali.rice.krms.api.repository.RuleManagementService;
import org.kuali.rice.krms.api.repository.term.TermRepositoryService;
import org.kuali.rice.krms.api.repository.type.KrmsTypeRepositoryService;
import org.kuali.student.loader.course.CourseService_Service;
import org.kuali.student.r1.core.statement.service.StatementService;
import org.kuali.student.r2.lum.course.service.CourseService;

import javax.xml.namespace.QName;
import java.net.MalformedURLException;
import java.net.URL;

/**
 * @author christoff.botha
 */
public class ServiceFactory {

    private static final String COURSE_SERVICE_NAME = "CourseService";
    private static final String STATEMENT_SERVICE_NAME = "StatementService";
    private static final String RULE_MANAGEMENT_SERVICE_NAME = "ruleManagementService";
    private static final String TERM_REPOSITORY_SERVICE_NAME = "termRepositoryService";
    private static final String KRMS_TYPE_REPOSITORY_SERVICE_NAME = "krmsTypeRepositoryService";

    public static final String LOCAL_HOST_EMBEDDED_URL = "http://localhost:8081/ks-with-rice-bundled-dev";

    //default to this url
    private String hostUrl = LOCAL_HOST_EMBEDDED_URL;

    public String getHostUrl() {
        return hostUrl;
    }

    public void setHostUrl(String hostUrl) {
        this.hostUrl = hostUrl;
    }

    private String calcWsdlUrl(String serviceName) {
        String url = getHostUrl() + "/services/" + serviceName + "?wsdl";
        return url;
    }

    private String calcRiceWsdlUrl(String serviceName) {
        String url = getHostUrl() + "/services/soap/krms/v2_0/" + serviceName + "?wsdl";
        return url;
    }

    public CourseService getCourseService() {
        URL wsdlURL;
        try {
            wsdlURL = new URL(calcWsdlUrl(COURSE_SERVICE_NAME));
        } catch (MalformedURLException ex) {
            throw new IllegalArgumentException(ex);
        }

        CourseService_Service oss = new CourseService_Service(wsdlURL);
        CourseService port = oss.getCourseServicePort();
        return port;
    }

    public StatementService getStatementService() {
        URL wsdlURL;
        try {
            wsdlURL = new URL(calcWsdlUrl(STATEMENT_SERVICE_NAME));
        } catch (MalformedURLException ex) {
            throw new IllegalArgumentException(ex);
        }
        StatementService_Service oss = new StatementService_Service(wsdlURL);
        StatementService port = oss.getServicePort();
        return port;
    }

    public RuleManagementService getRuleManagementService() {
        URL wsdlURL;
        try {
            wsdlURL = new URL(calcRiceWsdlUrl(RULE_MANAGEMENT_SERVICE_NAME));
        } catch (MalformedURLException ex) {
            throw new IllegalArgumentException(ex);
        }
        RuleManagementService_Service oss = new RuleManagementService_Service(wsdlURL);
        RuleManagementService port = oss.getServicePort();
        return port;
    }

    public KrmsTypeRepositoryService getKrmsTypeRepositoryService() {
        URL wsdlURL;
        try {
            wsdlURL = new URL(calcRiceWsdlUrl(KRMS_TYPE_REPOSITORY_SERVICE_NAME));
        } catch (MalformedURLException ex) {
            throw new IllegalArgumentException(ex);
        }
        KrmsTypeRepositoryService_Service oss = new KrmsTypeRepositoryService_Service(wsdlURL);
        KrmsTypeRepositoryService port = oss.getServicePort();
        return port;
    }

    public TermRepositoryService getTermRepositoryService() {
        URL wsdlURL;
        try {
            wsdlURL = new URL(calcRiceWsdlUrl(TERM_REPOSITORY_SERVICE_NAME));
        } catch (MalformedURLException ex) {
            throw new IllegalArgumentException(ex);
        }
        TermRepositoryService_Service oss = new TermRepositoryService_Service(wsdlURL);
        TermRepositoryService port = oss.getServicePort();
        return port;
    }

}
