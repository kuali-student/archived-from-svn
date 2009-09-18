
package org.kuali.student.core.comment.service.jaxws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

import org.kuali.student.core.dto.ReferenceTypeInfo;

/**
 * This class was generated by Apache CXF 2.2
 * Fri Jun 05 15:33:47 EDT 2009
 * Generated source version: 2.2
 */

@XmlRootElement(name = "getReferenceTypesResponse", namespace = "http://student.kuali.org/wsdl/commentService")
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "getReferenceTypesResponse", namespace = "http://student.kuali.org/wsdl/commentService")

public class GetReferenceTypesResponse {

    @XmlElement(name = "return")
    private java.util.List<ReferenceTypeInfo> _return;

    public java.util.List<ReferenceTypeInfo> getReturn() {
        return this._return;
    }

    public void setReturn(java.util.List<ReferenceTypeInfo> new_return)  {
        this._return = new_return;
    }

}

