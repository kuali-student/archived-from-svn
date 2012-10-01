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
import org.kuali.student.r2.core.class1.type.decorators.TypeServiceDecorator;
import org.kuali.student.r2.core.class1.type.dto.TypeInfo;
import org.kuali.student.r2.core.class1.type.dto.TypeTypeRelationInfo;
import org.kuali.student.r2.core.class1.type.service.TypeService;
import org.kuali.student.r2.core.constants.TypeServiceConstants;

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
    //
    // Have to override and check for null because of a bug in CXF 2.3.8 our current version
    // It was fixed in 2.6.1 but 2.3.8 still renders empty lists as null when transported by soap
    // see http://stackoverflow.com/questions/11384986/apache-cxf-web-services-problems
    //

    @Override
    public List<TypeInfo> getTypesByKeys(List<String> typeKeys, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<TypeInfo> list = this.getNextDecorator().getTypesByKeys(typeKeys, contextInfo);
        if (list == null) {
            return new ArrayList<TypeInfo>();
        }
        return list;
    }

    @Override
    public List<String> getRefObjectUris(ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<String> list = this.getNextDecorator().getRefObjectUris(contextInfo);
        if (list == null) {
            return new ArrayList<String>();
        }
        return list;
    }

    @Override
    public List<TypeInfo> getTypesByRefObjectUri(String refObjectUri, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<TypeInfo> list = this.getNextDecorator().getTypesByRefObjectUri(refObjectUri, contextInfo);
        if (list == null) {
            return new ArrayList<TypeInfo>();
        }
        return list;
    }

    @Override
    public List<TypeInfo> getTypesForGroupType(String groupTypeKey, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<TypeInfo> list = this.getNextDecorator().getTypesForGroupType(groupTypeKey, contextInfo);
        if (list == null) {
            return new ArrayList<TypeInfo>();
        }
        return list;
    }

    @Override
    public List<TypeInfo> getAllowedTypesForType(String ownerTypeKey, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<TypeInfo> list = this.getNextDecorator().getAllowedTypesForType(ownerTypeKey, contextInfo);
        if (list == null) {
            return new ArrayList<TypeInfo>();
        }
        return list;
    }

    @Override
    public List<ValidationResultInfo> validateType(String validationTypeKey, TypeInfo typeInfo, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<ValidationResultInfo> list = this.getNextDecorator().validateType(validationTypeKey, typeInfo, contextInfo);
        if (list == null) {
            return new ArrayList<ValidationResultInfo>();
        }
        return list;
    }

    @Override
    public List<TypeTypeRelationInfo> getTypeTypeRelationsByIds(List<String> typeTypeRelationIds, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<TypeTypeRelationInfo> list = this.getNextDecorator().getTypeTypeRelationsByIds(typeTypeRelationIds, contextInfo);
        if (list == null) {
            return new ArrayList<TypeTypeRelationInfo>();
        }
        return list;
    }

    @Override
    public List<TypeTypeRelationInfo> getTypeTypeRelationsByOwnerAndType(String ownerTypeKey, String typeTypeRelationTypeKey, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<TypeTypeRelationInfo> list = this.getNextDecorator().getTypeTypeRelationsByOwnerAndType(ownerTypeKey, typeTypeRelationTypeKey, contextInfo);
        if (list == null) {
            return new ArrayList<TypeTypeRelationInfo>();
        }
        return list;
    }

    @Override
    public List<TypeTypeRelationInfo> getTypeTypeRelationsByRelatedTypeAndType(String relatedTypeKey, String typeTypeRelationTypeKey, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<TypeTypeRelationInfo> list = this.getNextDecorator().getTypeTypeRelationsByRelatedTypeAndType(relatedTypeKey, typeTypeRelationTypeKey, contextInfo);
        if (list == null) {
            return new ArrayList<TypeTypeRelationInfo>();
        }
        return list;
    }

    @Override
    public List<ValidationResultInfo> validateTypeTypeRelation(String validationTypeKey, String typeKey, String typePeerKey, String typeTypeRelationTypeKey, TypeTypeRelationInfo typeTypeRelationInfo, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<ValidationResultInfo> list = this.getNextDecorator().validateTypeTypeRelation(validationTypeKey, typeKey, typePeerKey, typeTypeRelationTypeKey, typeTypeRelationInfo, contextInfo);
        if (list == null) {
            return new ArrayList<ValidationResultInfo>();
        }
        return list;
    }

    @Override
    public List<String> searchForTypeKeys(QueryByCriteria criteria, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<String> list = this.getNextDecorator().searchForTypeKeys(criteria, contextInfo);
        if (list == null) {
            return new ArrayList<String>();
        }
        return list;
    }

    @Override
    public List<TypeInfo> searchForTypes(QueryByCriteria criteria, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<TypeInfo> list = this.getNextDecorator().searchForTypes(criteria, contextInfo);
        if (list == null) {
            return new ArrayList<TypeInfo>();
        }
        return list;
    }

    @Override
    public List<String> searchForTypeTypeRelationIds(QueryByCriteria criteria, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<String> list = this.getNextDecorator().searchForTypeTypeRelationIds(criteria, contextInfo);
        if (list == null) {
            return new ArrayList<String>();
        }
        return list;
    }

    @Override
    public List<TypeTypeRelationInfo> searchForTypeTypeRelations(QueryByCriteria criteria, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<TypeTypeRelationInfo> list = this.getNextDecorator().searchForTypeTypeRelations(criteria, contextInfo);
        if (list == null) {
            return new ArrayList<TypeTypeRelationInfo>();
        }
        return list;
    }
}
