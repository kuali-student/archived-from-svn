
package org.kuali.student.core.messages.service.jaxws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

import org.kuali.student.core.messages.dto.MessageGroupKeyList;

/**
 * This class was generated by Apache CXF 2.1.3
 * Fri Jan 09 10:52:53 PST 2009
 * Generated source version: 2.1.3
 */

@XmlRootElement(name = "getMessageGroupsResponse", namespace = "http://student.kuali.org/core/messages")
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "getMessageGroupsResponse", namespace = "http://student.kuali.org/core/messages")

public class GetMessageGroupsResponse {

    @XmlElement(name = "return")
    private MessageGroupKeyList _return;

    public MessageGroupKeyList getReturn() {
        return this._return;
    }

    public void setReturn(MessageGroupKeyList new_return)  {
        this._return = new_return;
    }

}

