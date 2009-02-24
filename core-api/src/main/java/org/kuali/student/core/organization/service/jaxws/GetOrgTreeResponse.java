
package org.kuali.student.core.organization.service.jaxws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

import org.kuali.student.core.organization.dto.OrgTreeInfo;

/**
 * This class was generated by Apache CXF 2.1.3
 * Fri Feb 06 10:04:32 EST 2009
 * Generated source version: 2.1.3
 */

@XmlRootElement(name = "getOrgTreeResponse", namespace = "http://org.kuali.student/core/organization")
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "getOrgTreeResponse", namespace = "http://org.kuali.student/core/organization")

public class GetOrgTreeResponse {

    @XmlElement(name = "return")
    private java.util.List<OrgTreeInfo> _return;

    public java.util.List<OrgTreeInfo> getReturn() {
        return this._return;
    }

    public void setReturn(java.util.List<OrgTreeInfo> new_return)  {
        this._return = new_return;
    }

}

