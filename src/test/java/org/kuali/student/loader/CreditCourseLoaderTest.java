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
package org.kuali.student.loader;

import java.util.Date;
import java.util.List;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.kuali.student.lum.course.service.CourseService;
import static org.junit.Assert.*;

/**
 *
 * @author nwright
 */
public class CreditCourseLoaderTest
{

 private static CourseService courseService;

 public CreditCourseLoaderTest ()
 {
 }

 @BeforeClass
 public static void setUpClass ()
   throws Exception
 {
  CourseServiceFactory factory = new CourseServiceFactory ();
  factory.setHostUrl (CourseServiceFactory.LOCAL_HOST_EMBEDDED_URL);
  courseService = factory.getCourseService ();
 }

 @AfterClass
 public static void tearDownClass ()
   throws Exception
 {
 }

 @Before
 public void setUp ()
 {
 }

 @After
 public void tearDown ()
 {
 }

 /**
  * Test of load method, of class OrgLoader.
  */
 @Test
 public void testLoadCreditCourses ()
   throws Exception
 {
  System.out.println (new Date () + " load credit courses");

  CreditCourseLoader ccLoader = new CreditCourseLoader ();
  ccLoader.setCourseService (courseService);
  CreditCourseInputModel ccModel = CreditCourseInputModelFactoryTest.getInstance ().
    getModel ();

  System.out.println (new Date () + " getting credit courses...");
  List<CreditCourse> creditCourses = ccModel.getCreditCourses ();

  System.out.println (new Date () + " loading " + creditCourses.size ()
                      + " credit courses");
  ccLoader.setInputDataSource (creditCourses.subList (372, 373).iterator ());
//  ccLoader.setInputDataSource (creditCourses.iterator ());
  List<CreditCourseLoadResult> results = ccLoader.update ();
  int created = 0;
  int failures = 0;
  for (CreditCourseLoadResult result : results)
  {
   if (result.isSuccess ())
   {
    created ++;
    System.out.println (result.getCourseInfo ().getCode () + " id = "
                        + result.getCourseInfo ().getId ());
   }
   else
   {
    failures ++;
   }
  }
  System.out.println (created + " recordes created out of "
                      + creditCourses.size () + " credit courses");
  System.out.println (failures + " records failed to load");
  for (CreditCourseLoadResult result : results)
  {
   if ( ! result.isSuccess ())
   {
    System.out.println (result);
   }
  }
  if (failures > 0)
  {
   fail (failures + " records failed to load");
  }
 }
}
