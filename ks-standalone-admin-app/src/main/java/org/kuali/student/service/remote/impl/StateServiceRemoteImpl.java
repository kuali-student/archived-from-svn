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
import java.util.ArrayList;
import java.util.List;
import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import org.kuali.rice.core.api.criteria.QueryByCriteria;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.common.dto.ValidationResultInfo;
import org.kuali.student.r2.common.exceptions.DoesNotExistException;
import org.kuali.student.r2.common.exceptions.InvalidParameterException;
import org.kuali.student.r2.common.exceptions.MissingParameterException;
import org.kuali.student.r2.common.exceptions.OperationFailedException;
import org.kuali.student.r2.common.exceptions.PermissionDeniedException;
import org.kuali.student.r2.core.class1.state.decorators.StateServiceDecorator;
import org.kuali.student.r2.core.class1.state.dto.LifecycleInfo;
import org.kuali.student.r2.core.class1.state.dto.StateInfo;
import org.kuali.student.r2.core.class1.state.service.StateService;
import org.kuali.student.r2.core.constants.StateServiceConstants;

public class StateServiceRemoteImpl extends StateServiceDecorator {

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
            String urlStr = hostUrl + "/services/" + StateServiceConstants.SERVICE_NAME_LOCAL_PART + "?wsdl";
            wsdlURL = new URL(urlStr);
        } catch (MalformedURLException ex) {
            throw new IllegalArgumentException(ex);
        }
        QName qname = new QName(StateServiceConstants.NAMESPACE, StateServiceConstants.SERVICE_NAME_LOCAL_PART);
        Service factory = Service.create(wsdlURL, qname);
        StateService port = factory.getPort(StateService.class);
        this.setNextDecorator(port);
    }
    //
    // Have to override and check for null because of a bug in CXF 2.3.8 our current version
    // It was fixed in 2.6.1 but 2.3.8 still renders empty lists as null when transported by soap
    // see http://stackoverflow.com/questions/11384986/apache-cxf-web-services-problems
    //

    @Override
    public List<LifecycleInfo> getLifecyclesByKeys(List<String> lifecycleKeys, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<LifecycleInfo> list = this.getNextDecorator().getLifecyclesByKeys(lifecycleKeys, contextInfo);
        if (list == null) {
            return new ArrayList<LifecycleInfo>();
        }
        return list;
    }

    @Override
    public List<String> getLifecycleKeysByRefObjectUri(String refObjectUri, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<String> list = this.getNextDecorator().getLifecycleKeysByRefObjectUri(refObjectUri, contextInfo);
        if (list == null) {
            return new ArrayList<String>();
        }
        return list;
    }

    @Override
    public List<String> searchForLifecycleKeys(QueryByCriteria criteria, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<String> list = this.getNextDecorator().searchForLifecycleKeys(criteria, contextInfo);
        if (list == null) {
            return new ArrayList<String>();
        }
        return list;
    }

    @Override
    public List<LifecycleInfo> searchForLifecycles(QueryByCriteria criteria, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<LifecycleInfo> list = this.getNextDecorator().searchForLifecycles(criteria, contextInfo);
        if (list == null) {
            return new ArrayList<LifecycleInfo>();
        }
        return list;
    }

    @Override
    public List<ValidationResultInfo> validateLifecycle(String validationTypeKey, LifecycleInfo lifecycleInfo, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<ValidationResultInfo> list = this.getNextDecorator().validateLifecycle(validationTypeKey, lifecycleInfo, contextInfo);
        if (list == null) {
            return new ArrayList<ValidationResultInfo>();
        }
        return list;
    }

    @Override
    public List<StateInfo> getStatesByKeys(List<String> stateKeys, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<StateInfo> list = this.getNextDecorator().getStatesByKeys(stateKeys, contextInfo);
        if (list == null) {
            return new ArrayList<StateInfo>();
        }
        return list;
    }

    @Override
    public List<StateInfo> getStatesByLifecycle(String lifecycleKey, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<StateInfo> list = this.getNextDecorator().getStatesByLifecycle(lifecycleKey, contextInfo);
        if (list == null) {
            return new ArrayList<StateInfo>();
        }
        return list;
    }

    @Override
    public List<String> searchForStateKeys(QueryByCriteria criteria, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<String> list = this.getNextDecorator().searchForStateKeys(criteria, contextInfo);
        if (list == null) {
            return new ArrayList<String>();
        }
        return list;
    }

    @Override
    public List<StateInfo> searchForStates(QueryByCriteria criteria, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<StateInfo> list = this.getNextDecorator().searchForStates(criteria, contextInfo);
        if (list == null) {
            return new ArrayList<StateInfo>();
        }
        return list;
    }

    @Override
    public List<ValidationResultInfo> validateState(String validationTypeKey, String lifecycleKey, StateInfo stateInfo, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<ValidationResultInfo> list = this.getNextDecorator().validateState(validationTypeKey, lifecycleKey, stateInfo, contextInfo);
        if (list == null) {
            return new ArrayList<ValidationResultInfo>();
        }
        return list;
    }
}
