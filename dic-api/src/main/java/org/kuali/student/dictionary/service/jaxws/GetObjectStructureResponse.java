
package org.kuali.student.dictionary.service.jaxws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

/**
 * This class was generated by Apache CXF 2.1
 * Mon Oct 20 13:37:48 EDT 2008
 * Generated source version: 2.1
 */

@XmlRootElement(name = "getObjectStructureResponse", namespace = "http://org.kuali.student/dictonary")
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "getObjectStructureResponse", namespace = "http://org.kuali.student/dictonary")

public class GetObjectStructureResponse {

    @XmlElement(name = "return")
    private org.kuali.student.dictionary.dto.ObjectStructure _return;

    public org.kuali.student.dictionary.dto.ObjectStructure getReturn() {
        return this._return;
    }

    public void setReturn(org.kuali.student.dictionary.dto.ObjectStructure new_return)  {
        this._return = new_return;
    }

}

