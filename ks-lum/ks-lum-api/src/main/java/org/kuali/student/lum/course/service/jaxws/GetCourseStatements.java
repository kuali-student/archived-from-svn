
package org.kuali.student.lum.course.service.jaxws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

/**
 * This class was generated by Apache CXF 2.2
 * Tue May 18 13:33:13 PDT 2010
 * Generated source version: 2.2
 */

@XmlRootElement(name = "getCourseStatements", namespace = "http://student.kuali.org/wsdl/course")
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "getCourseStatements", namespace = "http://student.kuali.org/wsdl/course")

public class GetCourseStatements {

    @XmlElement(name = "courseId")
    private java.lang.String courseId;

    public java.lang.String getCourseId() {
        return this.courseId;
    }

    public void setCourseId(java.lang.String newCourseId)  {
        this.courseId = newCourseId;
    }

}

