
package org.kuali.student.lum.lu.service.jaxws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

/**
 * This class was generated by Apache CXF 2.2
 * Thu Jan 21 10:05:23 PST 2010
 * Generated source version: 2.2
 */

@XmlRootElement(name = "getAllowedResultComponentTypesForResultUsageType", namespace = "http://student.kuali.org/wsdl/lu")
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "getAllowedResultComponentTypesForResultUsageType", namespace = "http://student.kuali.org/wsdl/lu")

public class GetAllowedResultComponentTypesForResultUsageType {

    @XmlElement(name = "resultUsageTypeKey")
    private java.lang.String resultUsageTypeKey;

    public java.lang.String getResultUsageTypeKey() {
        return this.resultUsageTypeKey;
    }

    public void setResultUsageTypeKey(java.lang.String newResultUsageTypeKey)  {
        this.resultUsageTypeKey = newResultUsageTypeKey;
    }

}

