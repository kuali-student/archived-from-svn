
package org.kuali.student.core.organization.service.jaxws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

/**
 * This class was generated by Apache CXF 2.1.3
 * Wed Jan 21 13:23:57 EST 2009
 * Generated source version: 2.1.3
 */

@XmlRootElement(name = "getOrgPersonRelation", namespace = "http://student.kuali.org/wsdl/organization")
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "getOrgPersonRelation", namespace = "http://student.kuali.org/wsdl/organization")

public class GetOrgPersonRelation {

    @XmlElement(name = "orgPersonRelationId")
    private java.lang.String orgPersonRelationId;

    public java.lang.String getOrgPersonRelationId() {
        return this.orgPersonRelationId;
    }

    public void setOrgPersonRelationId(java.lang.String newOrgPersonRelationId)  {
        this.orgPersonRelationId = newOrgPersonRelationId;
    }

}

