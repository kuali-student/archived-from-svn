
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

@XmlRootElement(name = "changeRuleSetState", namespace = "http://student.kuali.org/wsdl/brms/RuleRepository")
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "changeRuleSetState", namespace = "http://student.kuali.org/wsdl/brms/RuleRepository", propOrder = {"ruleSetUUID","newState"})

public class ChangeRuleSetState {

    @XmlElement(name = "ruleSetUUID")
    private java.lang.String ruleSetUUID;
    @XmlElement(name = "newState")
    private java.lang.String newState;

    public java.lang.String getRuleSetUUID() {
        return this.ruleSetUUID;
    }

    public void setRuleSetUUID(java.lang.String newRuleSetUUID)  {
        this.ruleSetUUID = newRuleSetUUID;
    }

    public java.lang.String getNewState() {
        return this.newState;
    }

    public void setNewState(java.lang.String newNewState)  {
        this.newState = newNewState;
    }

}

