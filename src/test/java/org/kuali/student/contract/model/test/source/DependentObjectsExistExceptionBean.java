/**
 * Copyright 2004-2014 The Kuali Foundation
 *
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.opensource.org/licenses/ecl2.php
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.kuali.student.contract.model.test.source;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

/**
 * This class was generated by the CXF 2.0.4-incubator Thu Mar 20 11:20:16 EDT 2008 Generated source version: 2.0.4-incubator
 */

@XmlRootElement(name = "DependentObjectsExistException", namespace = "http://student.kuali.org/wsdl/exceptions")
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "DependentObjectsExistException", namespace = "http://student.kuali.org/wsdl/exceptions")
public class DependentObjectsExistExceptionBean {

    private java.lang.String message;

    public java.lang.String getMessage() {
        return message;
    }

    public void setMessage(java.lang.String newMessage) {
        message = newMessage;
    }

}
