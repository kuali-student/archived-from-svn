
package org.kuali.student.core.proposal.service.jaxws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

/**
 * This class was generated by Apache CXF 2.2
 * Wed Sep 02 14:48:07 EDT 2009
 * Generated source version: 2.2
 */

@XmlRootElement(name = "getProposalsByState", namespace = "http://student.kuali.org/wsdl/proposal")
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "getProposalsByState", namespace = "http://student.kuali.org/wsdl/proposal", propOrder = {"proposalState","proposalTypeKey"})

public class GetProposalsByState {

    @XmlElement(name = "proposalState")
    private java.lang.String proposalState;
    @XmlElement(name = "proposalTypeKey")
    private java.lang.String proposalTypeKey;

    public java.lang.String getProposalState() {
        return this.proposalState;
    }

    public void setProposalState(java.lang.String newProposalState)  {
        this.proposalState = newProposalState;
    }

    public java.lang.String getProposalTypeKey() {
        return this.proposalTypeKey;
    }

    public void setProposalTypeKey(java.lang.String newProposalTypeKey)  {
        this.proposalTypeKey = newProposalTypeKey;
    }

}

