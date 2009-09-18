
package org.kuali.student.core.organization.service.jaxws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

/**
 * This class was generated by Apache CXF 2.1.3
 * Wed Jan 21 13:23:58 EST 2009
 * Generated source version: 2.1.3
 */

@XmlRootElement(name = "validateOrgPersonRelation", namespace = "http://student.kuali.org/wsdl/organization")
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "validateOrgPersonRelation", namespace = "http://student.kuali.org/wsdl/organization", propOrder = {"validationType","orgPersonRelationInfo"})

public class ValidateOrgPersonRelation {

    @XmlElement(name = "validationType")
    private java.lang.String validationType;
    @XmlElement(name = "orgPersonRelationInfo")
    private org.kuali.student.core.organization.dto.OrgPersonRelationInfo orgPersonRelationInfo;

    public java.lang.String getValidationType() {
        return this.validationType;
    }

    public void setValidationType(java.lang.String newValidationType)  {
        this.validationType = newValidationType;
    }

    public org.kuali.student.core.organization.dto.OrgPersonRelationInfo getOrgPersonRelationInfo() {
        return this.orgPersonRelationInfo;
    }

    public void setOrgPersonRelationInfo(org.kuali.student.core.organization.dto.OrgPersonRelationInfo newOrgPersonRelationInfo)  {
        this.orgPersonRelationInfo = newOrgPersonRelationInfo;
    }

}

