
package org.kuali.student.rules.repository.service.jaxws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

/**
 * This class was generated by Apache CXF 2.1.4
 * Wed Mar 11 13:47:09 EDT 2009
 * Generated source version: 2.1.4
 */

@XmlRootElement(name = "fetchRuleSetSnapshotsByCategoryResponse", namespace = "http://student.kuali.org/wsdl/brms/RuleRepository")
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "fetchRuleSetSnapshotsByCategoryResponse", namespace = "http://student.kuali.org/wsdl/brms/RuleRepository")

public class FetchRuleSetSnapshotsByCategoryResponse {

    @XmlElement(name = "return")
    private java.util.List _return;

    public java.util.List getReturn() {
        return this._return;
    }

    public void setReturn(java.util.List new_return)  {
        this._return = new_return;
    }

}

