
package org.kuali.student.lum.lu.service.jaxws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

/**
 * This class was generated by Apache CXF 2.1.4
 * Tue Feb 24 12:25:29 EST 2009
 * Generated source version: 2.1.4
 */

@XmlRootElement(name = "getLuiLuiRelation", namespace = "http://student.kuali.org/lum/lu")
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "getLuiLuiRelation", namespace = "http://student.kuali.org/lum/lu")

public class GetLuiLuiRelation {

    @XmlElement(name = "luiLuiRelationId")
    private java.lang.String luiLuiRelationId;

    public java.lang.String getLuiLuiRelationId() {
        return this.luiLuiRelationId;
    }

    public void setLuiLuiRelationId(java.lang.String newLuiLuiRelationId)  {
        this.luiLuiRelationId = newLuiLuiRelationId;
    }

}

