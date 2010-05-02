/**
 * Copyright 2010 The Kuali Foundation Licensed under the
 * Educational Community License, Version 2.0 (the "License"); you may
 * not use this file except in compliance with the License. You may
 * obtain a copy of the License at
 *
 * http://www.osedu.org/licenses/ECL-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an "AS IS"
 * BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

package org.kuali.student.core.organization.service.jaxws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

import org.kuali.student.core.organization.dto.OrgOrgRelationInfo;

/**
 * This class was generated by Apache CXF 2.1.3
 * Fri Jan 16 11:42:39 EST 2009
 * Generated source version: 2.1.3
 */

@XmlRootElement(name = "getOrgOrgRelationsByOrgResponse", namespace = "http://student.kuali.org/wsdl/organization")
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "getOrgOrgRelationsByOrgResponse", namespace = "http://student.kuali.org/wsdl/organization")

public class GetOrgOrgRelationsByOrgResponse {

    @XmlElement(name = "return")
    private java.util.List<OrgOrgRelationInfo> _return;

    public java.util.List<OrgOrgRelationInfo> getReturn() {
		if(_return==null){
			_return = new java.util.ArrayList<OrgOrgRelationInfo>(0);
		}
        return this._return;
    }

    public void setReturn(java.util.List<OrgOrgRelationInfo> new_return)  {
        this._return = new_return;
    }

}

