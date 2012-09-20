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
import org.kuali.student.r2.lum.lrc.dto.ResultScaleInfo;
import org.kuali.student.r2.lum.lrc.dto.ResultValueInfo;
import org.kuali.student.r2.lum.lrc.dto.ResultValuesGroupInfo;
import org.kuali.student.r2.lum.lrc.service.LRCService;
import org.kuali.student.r2.lum.lrc.service.LRCServiceDecorator;
import org.kuali.student.r2.lum.util.constants.LrcServiceConstants;

public class LrcServiceRemoteImpl extends LRCServiceDecorator {

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
    //
    // Have to override and check for null because of a bug in CXF 2.3.8 our current version
    // It was fixed in 2.6.1 but 2.3.8 still renders empty lists as null when transported by soap
    // see http://stackoverflow.com/questions/11384986/apache-cxf-web-services-problems
    //

    @Override
    public List<ResultValuesGroupInfo> getResultValuesGroupsByKeys(List<String> resultValuesGroupKeys, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<ResultValuesGroupInfo> list = this.getNextDecorator().getResultValuesGroupsByKeys(resultValuesGroupKeys, contextInfo);
        if (list == null) {
            return new ArrayList<ResultValuesGroupInfo>();
        }
        return list;
    }

    @Override
    public List<ResultValuesGroupInfo> getResultValuesGroupsByResultValue(String resultValueKey, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<ResultValuesGroupInfo> list = this.getNextDecorator().getResultValuesGroupsByResultValue(resultValueKey, contextInfo);
        if (list == null) {
            return new ArrayList<ResultValuesGroupInfo>();
        }
        return list;
    }

    @Override
    public List<ResultValuesGroupInfo> getResultValuesGroupsByResultScale(String resultScaleKey, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<ResultValuesGroupInfo> list = this.getNextDecorator().getResultValuesGroupsByResultScale(resultScaleKey, contextInfo);
        if (list == null) {
            return new ArrayList<ResultValuesGroupInfo>();
        }
        return list;
    }

    @Override
    public List<String> getResultValuesGroupKeysByType(String resultValuesGroupTypeKey, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<String> list = this.getNextDecorator().getResultValuesGroupKeysByType(resultValuesGroupTypeKey, contextInfo);
        if (list == null) {
            return new ArrayList<String>();
        }
        return list;
    }

    @Override
    public List<ValidationResultInfo> validateResultValuesGroup(String validationType, ResultValuesGroupInfo gradeValuesGroupInfo, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException {
        List<ValidationResultInfo> list = this.getNextDecorator().validateResultValuesGroup(validationType, gradeValuesGroupInfo, contextInfo);
        if (list == null) {
            return new ArrayList<ValidationResultInfo>();
        }
        return list;
    }

    @Override
    public List<ResultValueInfo> getResultValuesByKeys(List<String> resultValueKeys, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<ResultValueInfo> list = this.getNextDecorator().getResultValuesByKeys(resultValueKeys, contextInfo);
        if (list == null) {
            return new ArrayList<ResultValueInfo>();
        }
        return list;
    }

    @Override
    public List<String> getResultValueKeysByType(String resultValueTypeKey, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<String> list = this.getNextDecorator().getResultValueKeysByType(resultValueTypeKey, contextInfo);
        if (list == null) {
            return new ArrayList<String>();
        }
        return list;
    }

    @Override
    public List<ResultValueInfo> getResultValuesForResultValuesGroup(String resultValuesGroupKey, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<ResultValueInfo> list = this.getNextDecorator().getResultValuesForResultValuesGroup(resultValuesGroupKey, contextInfo);
        if (list == null) {
            return new ArrayList<ResultValueInfo>();
        }
        return list;
    }

    @Override
    public List<ValidationResultInfo> validateResultValue(String validationType, ResultValueInfo resultValueInfo, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException {
        List<ValidationResultInfo> list = this.getNextDecorator().validateResultValue(validationType, resultValueInfo, contextInfo);
        if (list == null) {
            return new ArrayList<ValidationResultInfo>();
        }
        return list;
    }

    @Override
    public List<ResultScaleInfo> getResultScalesByKeys(List<String> resultScaleKeys, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<ResultScaleInfo> list = this.getNextDecorator().getResultScalesByKeys(resultScaleKeys, contextInfo);
        if (list == null) {
            return new ArrayList<ResultScaleInfo>();
        }
        return list;
    }

    @Override
    public List<String> getResultScaleKeysByType(String resultScaleTypeKey, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<String> list = this.getNextDecorator().getResultScaleKeysByType(resultScaleTypeKey, contextInfo);
        if (list == null) {
            return new ArrayList<String>();
        }
        return list;
    }

    @Override
    public List<ValidationResultInfo> validateResultScale(String validationType, ResultScaleInfo gradeScaleInfo, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException {
        List<ValidationResultInfo> list = this.getNextDecorator().validateResultScale(validationType, gradeScaleInfo, contextInfo);
        if (list == null) {
            return new ArrayList<ValidationResultInfo>();
        }
        return list;
    }

    @Override
    public List<ResultValueInfo> getResultValuesForScale(String resultScaleKey, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<ResultValueInfo> list = this.getNextDecorator().getResultValuesForScale(resultScaleKey, contextInfo);
        if (list == null) {
            return new ArrayList<ResultValueInfo>();
        }
        return list;
    }

    @Override
    public List<ResultValueInfo> getResultValuesForResultValuesGroups(List<String> resultValuesGroupKeys, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<ResultValueInfo> list = this.getNextDecorator().getResultValuesForResultValuesGroups(resultValuesGroupKeys, contextInfo);
        if (list == null) {
            return new ArrayList<ResultValueInfo>();
        }
        return list;
    }

    @Override
    public List<ResultValuesGroupInfo> getResultValuesGroupsByResultScaleType(String resultScaleTypeKey, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<ResultValuesGroupInfo> list = this.getNextDecorator().getResultValuesGroupsByResultScaleType(resultScaleTypeKey, contextInfo);
        if (list == null) {
            return new ArrayList<ResultValuesGroupInfo>();
        }
        return list;
    }

    @Override
    public List<String> searchForResultScaleIds(QueryByCriteria criteria, ContextInfo context)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<String> list = this.getNextDecorator().searchForResultScaleIds(criteria, context);
        if (list == null) {
            return new ArrayList<String>();
        }
        return list;
    }

    @Override
    public List<ResultScaleInfo> searchForResultScales(QueryByCriteria criteria, ContextInfo context)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<ResultScaleInfo> list = this.getNextDecorator().searchForResultScales(criteria, context);
        if (list == null) {
            return new ArrayList<ResultScaleInfo>();
        }
        return list;
    }

    @Override
    public List<String> searchForResultValueIds(QueryByCriteria criteria, ContextInfo context)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<String> list = this.getNextDecorator().searchForResultValueIds(criteria, context);
        if (list == null) {
            return new ArrayList<String>();
        }
        return list;
    }

    @Override
    public List<ResultValueInfo> searchForResultValues(QueryByCriteria criteria, ContextInfo context)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<ResultValueInfo> list = this.getNextDecorator().searchForResultValues(criteria, context);
        if (list == null) {
            return new ArrayList<ResultValueInfo>();
        }
        return list;
    }

    @Override
    public List<String> searchForResultValuesGroupIds(QueryByCriteria criteria, ContextInfo context)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<String> list = this.getNextDecorator().searchForResultValuesGroupIds(criteria, context);
        if (list == null) {
            return new ArrayList<String>();
        }
        return list;
    }

    @Override
    public List<ResultValuesGroupInfo> searchForResultValuesGroups(QueryByCriteria criteria, ContextInfo context)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<ResultValuesGroupInfo> list = this.getNextDecorator().searchForResultValuesGroups(criteria, context);
        if (list == null) {
            return new ArrayList<ResultValuesGroupInfo>();
        }
        return list;
    }
}
