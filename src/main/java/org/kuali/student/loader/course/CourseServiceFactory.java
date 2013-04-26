/*
 * Copyright 2010 The Kuali Foundation
 *
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may	obtain a copy of the License at
 *
 * 	http://www.osedu.org/licenses/ECL-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.kuali.student.loader.course;

import java.net.MalformedURLException;
import java.net.URL;
import javax.xml.namespace.QName;
import org.kuali.student.r2.lum.course.service.CourseService;

/**
 *
 * @author nwright
 */
public class CourseServiceFactory
{

 private static final String COURSE_SERVICE_NAME = "CourseService";
 private static final QName COURSE_SERVICE_QNAME =
                            CourseService_Service.SERVICE;
 public static final String DEV_EMBEDDED_URL =
                            "http://dev.ks.kuali.org";
  //public static final String LOCAL_HOST_EMBEDDED_URL = "http://localhost:8081/ks-with-rice-bundled-dev";
 
 
 public static final String LOCAL_HOST_EMBEDDED_URL ="http://localhost:8081/ks-with-rice-bundled-dev";
		  //                         
 private String hostUrl = LOCAL_HOST_EMBEDDED_URL;

 public String getHostUrl ()
 {
  return hostUrl;
 }

 public void setHostUrl (String hostUrl)
 {
  this.hostUrl = hostUrl;
 }

 private String calcWsdlUrl (String serviceName)
 {
  String url = getHostUrl () + "/services/" + serviceName + "?wsdl";
//  System.out.println ("url is " + url);
  return url;
 }

 public CourseService getCourseService ()
 {
  URL wsdlURL;
  try
  {
   wsdlURL = new URL (calcWsdlUrl (COURSE_SERVICE_NAME));
  }
  catch (MalformedURLException ex)
  {
   throw new IllegalArgumentException (ex);
  }

//  System.out.println (wsdlURL);
  CourseService_Service oss =
                        new CourseService_Service (wsdlURL,
                                                   COURSE_SERVICE_QNAME);
  CourseService port = oss.getCourseServicePort ();
  return port;
 }

}
