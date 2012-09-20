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

import java.lang.String;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
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
import org.kuali.student.r2.core.atp.dto.AtpAtpRelationInfo;
import org.kuali.student.r2.core.atp.dto.AtpInfo;
import org.kuali.student.r2.core.atp.dto.MilestoneInfo;
import org.kuali.student.r2.core.atp.service.AtpService;
import org.kuali.student.r2.core.class1.atp.service.decorators.AtpServiceDecorator;
import org.kuali.student.r2.core.constants.AtpServiceConstants;

public class AtpServiceRemoteImpl extends AtpServiceDecorator {

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
            String urlStr = hostUrl + "/services/" + AtpServiceConstants.SERVICE_NAME_LOCAL_PART + "?wsdl";
            wsdlURL = new URL(urlStr);
        } catch (MalformedURLException ex) {
            throw new IllegalArgumentException(ex);
        }
        QName qname = new QName(AtpServiceConstants.NAMESPACE, AtpServiceConstants.SERVICE_NAME_LOCAL_PART);
        Service factory = Service.create(wsdlURL, qname);
        AtpService port = factory.getPort(AtpService.class);
        this.setNextDecorator(port);
    }
    //
    // Have to override and check for null because of a bug in CXF 2.3.8 our current version
    // It was fixed in 2.6.1 but 2.3.8 still renders empty lists as null when transported by soap
    // see http://stackoverflow.com/questions/11384986/apache-cxf-web-services-problems
    //

    @Override
    public List<AtpInfo> getAtpsByIds(List<String> atpIds, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<AtpInfo> list = this.getNextDecorator().getAtpsByIds(atpIds, contextInfo);
        if (list == null) {
            return new ArrayList<AtpInfo>();
        }
        return list;
    }

    @Override
    public List<String> getAtpIdsByType(String atpTypeKey, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<String> list = this.getNextDecorator().getAtpIdsByType(atpTypeKey, contextInfo);
        if (list == null) {
            return new ArrayList<String>();
        }
        return list;
    }

    @Override
    public List<AtpInfo> getAtpsByCode(String code, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<AtpInfo> list = this.getNextDecorator().getAtpsByCode(code, contextInfo);
        if (list == null) {
            return new ArrayList<AtpInfo>();
        }
        return list;
    }

    @Override
    public List<AtpInfo> getAtpsByDate(Date date, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<AtpInfo> list = this.getNextDecorator().getAtpsByDate(date, contextInfo);
        if (list == null) {
            return new ArrayList<AtpInfo>();
        }
        return list;
    }

    @Override
    public List<AtpInfo> getAtpsByDateAndType(Date date, String atpTypeKey, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<AtpInfo> list = this.getNextDecorator().getAtpsByDateAndType(date, atpTypeKey, contextInfo);
        if (list == null) {
            return new ArrayList<AtpInfo>();
        }
        return list;
    }

    @Override
    public List<AtpInfo> getAtpsByDates(Date startDate, Date endDate, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<AtpInfo> list = this.getNextDecorator().getAtpsByDates(startDate, endDate, contextInfo);
        if (list == null) {
            return new ArrayList<AtpInfo>();
        }
        return list;
    }

    @Override
    public List<AtpInfo> getAtpsByDatesAndType(Date startDate, Date endDate, String atpTypeKey, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<AtpInfo> list = this.getNextDecorator().getAtpsByDatesAndType(startDate, endDate, atpTypeKey, contextInfo);
        if (list == null) {
            return new ArrayList<AtpInfo>();
        }
        return list;
    }

    @Override
    public List<AtpInfo> getAtpsByStartDateRange(Date dateRangeStart, Date dateRangeEnd, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<AtpInfo> list = this.getNextDecorator().getAtpsByStartDateRange(dateRangeStart, dateRangeEnd, contextInfo);
        if (list == null) {
            return new ArrayList<AtpInfo>();
        }
        return list;
    }

    @Override
    public List<AtpInfo> getAtpsByStartDateRangeAndType(Date dateRangeStart, Date dateRangeEnd, String atpTypeKey, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<AtpInfo> list = this.getNextDecorator().getAtpsByStartDateRangeAndType(dateRangeStart, dateRangeEnd, atpTypeKey, contextInfo);
        if (list == null) {
            return new ArrayList<AtpInfo>();
        }
        return list;
    }

    @Override
    public List<String> searchForAtpIds(QueryByCriteria criteria, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<String> list = this.getNextDecorator().searchForAtpIds(criteria, contextInfo);
        if (list == null) {
            return new ArrayList<String>();
        }
        return list;
    }

    @Override
    public List<AtpInfo> searchForAtps(QueryByCriteria criteria, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<AtpInfo> list = this.getNextDecorator().searchForAtps(criteria, contextInfo);
        if (list == null) {
            return new ArrayList<AtpInfo>();
        }
        return list;
    }

    @Override
    public List<ValidationResultInfo> validateAtp(String validationTypeKey, String atpTypeKey, AtpInfo atpInfo, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<ValidationResultInfo> list = this.getNextDecorator().validateAtp(validationTypeKey, atpTypeKey, atpInfo, contextInfo);
        if (list == null) {
            return new ArrayList<ValidationResultInfo>();
        }
        return list;
    }

    @Override
    public List<AtpAtpRelationInfo> getAtpAtpRelationsByIds(List<String> atpAtpRelationIds, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<AtpAtpRelationInfo> list = this.getNextDecorator().getAtpAtpRelationsByIds(atpAtpRelationIds, contextInfo);
        if (list == null) {
            return new ArrayList<AtpAtpRelationInfo>();
        }
        return list;
    }

    @Override
    public List<String> getAtpAtpRelationIdsByType(String atpAtpRelationTypeKey, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<String> list = this.getNextDecorator().getAtpAtpRelationIdsByType(atpAtpRelationTypeKey, contextInfo);
        if (list == null) {
            return new ArrayList<String>();
        }
        return list;
    }

    @Override
    public List<AtpAtpRelationInfo> getAtpAtpRelationsByAtp(String atpId, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<AtpAtpRelationInfo> list = this.getNextDecorator().getAtpAtpRelationsByAtp(atpId, contextInfo);
        if (list == null) {
            return new ArrayList<AtpAtpRelationInfo>();
        }
        return list;
    }

    @Override
    public List<AtpAtpRelationInfo> getAtpAtpRelationsByAtps(String atpId, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<AtpAtpRelationInfo> list = this.getNextDecorator().getAtpAtpRelationsByAtps(atpId, contextInfo);
        if (list == null) {
            return new ArrayList<AtpAtpRelationInfo>();
        }
        return list;
    }

    @Override
    public List<AtpAtpRelationInfo> getAtpAtpRelationsByTypeAndAtp(String atpId, String atpAtpRelationTypeKey, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<AtpAtpRelationInfo> list = this.getNextDecorator().getAtpAtpRelationsByTypeAndAtp(atpId, atpAtpRelationTypeKey, contextInfo);
        if (list == null) {
            return new ArrayList<AtpAtpRelationInfo>();
        }
        return list;
    }

    @Override
    public List<String> searchForAtpAtpRelationIds(QueryByCriteria criteria, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<String> list = this.getNextDecorator().searchForAtpAtpRelationIds(criteria, contextInfo);
        if (list == null) {
            return new ArrayList<String>();
        }
        return list;
    }

    @Override
    public List<AtpAtpRelationInfo> searchForAtpAtpRelations(QueryByCriteria criteria, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<AtpAtpRelationInfo> list = this.getNextDecorator().searchForAtpAtpRelations(criteria, contextInfo);
        if (list == null) {
            return new ArrayList<AtpAtpRelationInfo>();
        }
        return list;
    }

    @Override
    public List<ValidationResultInfo> validateAtpAtpRelation(String validationTypeKey, String atpId, String atpPeerId, String atpAtpRelationTypeKey, AtpAtpRelationInfo atpAtpRelationInfo, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<ValidationResultInfo> list = this.getNextDecorator().validateAtpAtpRelation(validationTypeKey, atpId, atpPeerId, atpAtpRelationTypeKey, atpAtpRelationInfo, contextInfo);
        if (list == null) {
            return new ArrayList<ValidationResultInfo>();
        }
        return list;
    }

    @Override
    public List<MilestoneInfo> getMilestonesByIds(List<String> milestoneIds, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<MilestoneInfo> list = this.getNextDecorator().getMilestonesByIds(milestoneIds, contextInfo);
        if (list == null) {
            return new ArrayList<MilestoneInfo>();
        }
        return list;
    }

    @Override
    public List<String> getMilestoneIdsByType(String milestoneTypeKey, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<String> list = this.getNextDecorator().getMilestoneIdsByType(milestoneTypeKey, contextInfo);
        if (list == null) {
            return new ArrayList<String>();
        }
        return list;
    }

    @Override
    public List<MilestoneInfo> getMilestonesByDates(Date startDate, Date endDate, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<MilestoneInfo> list = this.getNextDecorator().getMilestonesByDates(startDate, endDate, contextInfo);
        if (list == null) {
            return new ArrayList<MilestoneInfo>();
        }
        return list;
    }

    @Override
    public List<MilestoneInfo> getMilestonesForAtp(String atpId, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<MilestoneInfo> list = this.getNextDecorator().getMilestonesForAtp(atpId, contextInfo);
        if (list == null) {
            return new ArrayList<MilestoneInfo>();
        }
        return list;
    }

    @Override
    public List<MilestoneInfo> getMilestonesByDatesForAtp(String atpId, Date startDate, Date endDate, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<MilestoneInfo> list = this.getNextDecorator().getMilestonesByDatesForAtp(atpId, startDate, endDate, contextInfo);
        if (list == null) {
            return new ArrayList<MilestoneInfo>();
        }
        return list;
    }

    @Override
    public List<MilestoneInfo> getMilestonesByTypeForAtp(String atpId, String milestoneTypeKey, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<MilestoneInfo> list = this.getNextDecorator().getMilestonesByTypeForAtp(atpId, milestoneTypeKey, contextInfo);
        if (list == null) {
            return new ArrayList<MilestoneInfo>();
        }
        return list;
    }

    @Override
    public List<MilestoneInfo> getImpactedMilestones(String milestoneId, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<MilestoneInfo> list = this.getNextDecorator().getImpactedMilestones(milestoneId, contextInfo);
        if (list == null) {
            return new ArrayList<MilestoneInfo>();
        }
        return list;
    }

    @Override
    public List<String> searchForMilestoneIds(QueryByCriteria criteria, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<String> list = this.getNextDecorator().searchForMilestoneIds(criteria, contextInfo);
        if (list == null) {
            return new ArrayList<String>();
        }
        return list;
    }

    @Override
    public List<MilestoneInfo> searchForMilestones(QueryByCriteria criteria, ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<MilestoneInfo> list = this.getNextDecorator().searchForMilestones(criteria, contextInfo);
        if (list == null) {
            return new ArrayList<MilestoneInfo>();
        }
        return list;
    }

    @Override
    public List<ValidationResultInfo> validateMilestone(String validationTypeKey, MilestoneInfo milestoneInfo, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        List<ValidationResultInfo> list = this.getNextDecorator().validateMilestone(validationTypeKey, milestoneInfo, contextInfo);
        if (list == null) {
            return new ArrayList<ValidationResultInfo>();
        }
        return list;
    }
}
