
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

@XmlRootElement(name = "checkinRuleSetResponse", namespace = "http://student.kuali.org/wsdl/brms/RuleRepository")
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "checkinRuleSetResponse", namespace = "http://student.kuali.org/wsdl/brms/RuleRepository")

public class CheckinRuleSetResponse {

    @XmlElement(name = "return")
    private long _return;

    public long getReturn() {
        return this._return;
    }

    public void setReturn(long new_return)  {
        this._return = new_return;
    }

}

