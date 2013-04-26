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

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNotSame;
import static org.junit.Assert.fail;

import java.util.List;

import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.kuali.student.loader.util.AttributeInfoHelper;
import org.kuali.student.loader.util.ContextInfoHelper;
import org.kuali.student.loader.util.DateHelper;
import org.kuali.student.loader.util.RichTextInfoHelper;
import org.kuali.student.r2.common.dto.AttributeInfo;
import org.kuali.student.r2.common.dto.StatusInfo;
import org.kuali.student.r2.common.dto.ValidationResultInfo;
import org.kuali.student.r2.common.exceptions.DataValidationErrorException;
import org.kuali.student.r2.common.exceptions.DoesNotExistException;
import org.kuali.student.r2.lum.course.dto.CourseInfo;
import org.kuali.student.r2.lum.course.service.CourseService;

public class CourseServiceTest
{

 public CourseServiceTest ()
 {
 }
 private static CourseService courseService;

 static ContextInfoHelper ctxInfoHelper ;
 @Before
 public void setUp () throws Exception
 {
 }

 @BeforeClass
 public static void setUpClass () throws Exception
 {
  CourseServiceFactory factory = new CourseServiceFactory ();
  factory.setHostUrl (CourseServiceFactory.LOCAL_HOST_EMBEDDED_URL);
  //factory.setHostUrl("http://localhost:9080/ks-embedded-dev");
  courseService = factory.getCourseService ();
  ctxInfoHelper = new ContextInfoHelper();
 }

 @AfterClass
 public static void tearDownClass () throws Exception
 {
 }

 /**
  * Test of getCourse method, of class CourseService.
  */
 @Test
 public void testGetCourse ()
 {
  System.out.println ("getCourse");
  String id = "a079e6e4-9d4c-4296-8db3-5fa353fcfec9";
  CourseInfo result = null;
  try
  {
   result = courseService.getCourse (id, ctxInfoHelper.getDefaultContextInfo());
  }
  catch (DoesNotExistException ex)
  {
   fail ("should exist if impex was run properly");
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }
  assertNotNull (result);
 }

 /**
  * Test of createCourse method, of class CourseService.
  */
 //@Test
 /**public void testCreateCourse ()
 {
  System.out.println ("createCourse");
  CourseInfo info = new CourseInfo ();
  info.setId ("TESTLIFECYCLECOURSE");

  // delete test course if it is there left over from previous test
  try
  {
   StatusInfo status = courseService.deleteCourse (info.getId (), ctxInfoHelper.getDefaultContextInfo());
  }
  catch (Exception ex)
  {
   // ignore because it may ore may not be there
  }

  info.setSubjectArea ("ENGL");
//  info.setCode ("ENGL111");
  info.setStateKey ("draft");
  info.setTypeKey ("kuali.lu.type.CreditCourse");
  info.setCourseNumberSuffix ("111");
  info.setCourseTitle ("Intro to English");
  info.setEffectiveDate (new DateHelper ().asDate ("2010-01-01"));
  info.setAttributes (new AttributeInfoHelper ().setValue ("audit", true, info.getAttributes ()));

  CourseInfo result = null;
  try
  {
   result = courseService.createCourse (info,  ctxInfoHelper.getDefaultContextInfo());
   assertNotNull (result);
   assertNotSame (info, result);
   assertNotNull (result.getId ());
   assertEquals ("ENGL111", result.getCode ());
   assertEquals (info.getSubjectArea (), result.getSubjectArea ());
   assertEquals (info.getCourseNumberSuffix (), result.getCourseNumberSuffix ());
   assertEquals (info.getCourseTitle (), result.getCourseTitle ());
   boolean audit = false;
   for (AttributeInfo attInfo : result.getAttributes() ) {
	   if (attInfo.getKey().equalsIgnoreCase("audit")) {
		   audit = true;
	   }
   }
   assertEquals ("true", audit);
  }
  catch (DataValidationErrorException ex)
  {
   for (ValidationResultInfo vri : ex.getValidationResults ())
   {
    System.out.println (vri.getElement () + " " + vri.getMessage ());
   }
   fail ("got validation exception");
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }

  // get
  info = result;
  try
  {
   result = courseService.getCourse (info.getId (), ctxInfoHelper.getDefaultContextInfo());
  }
  catch (DoesNotExistException ex)
  {
   fail ("should exist");
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }
  assertNotNull (result);
  assertNotSame (info, result);
  assertNotNull (result.getId ());
  assertEquals (info.getId (), result.getId ());
  assertEquals (info.getCode (), result.getCode ());
  assertEquals (info.getSubjectArea (), result.getSubjectArea ());
  assertEquals (info.getCourseNumberSuffix (), result.getCourseNumberSuffix ());
  assertEquals (info.getCourseTitle (), result.getCourseTitle ());
  boolean audit = false;
  for (AttributeInfo attInfo : result.getAttributes() ) {
	   if (attInfo.getKey().equalsIgnoreCase("audit")) {
		   audit = true;
	   }
  }
  assertEquals ("true", audit);
  
  // update
  info = result;
  info.setSubjectArea ("MATH");
  info.setCode (null);
  info.setStateKey ("Draft");
//  info.setType ("kuali.lu.type.CreditCourse");
  info.setCourseNumberSuffix ("222");
  info.setCourseTitle ("Intro to math");
  info.setEffectiveDate (new DateHelper ().asDate ("2010-02-02"));
  info.setDescr (new RichTextInfoHelper ().getFromPlain (
    "this is the description of the course which is required when active"));
  try
  {
   result = courseService.updateCourse (info.getId(), info, ctxInfoHelper.getDefaultContextInfo());
  }
  catch (DoesNotExistException ex)
  {
   fail ("should exist");
  }
  catch (DataValidationErrorException ex)
  {
   List<ValidationResultInfo> vris = ex.getValidationResults ();
   if (vris == null)
   {
    System.out.println (
      "got DataValidationErrorException but no validation results");
    try
    {
     vris = courseService.validateCourse ("system", info, ctxInfoHelper.getDefaultContextInfo());
    }
    catch (Exception ex2)
    {
     throw new RuntimeException (ex2);
    }
   }
   for (ValidationResultInfo vri : vris)
   {
    System.out.println (vri.getElement () + " " + vri.getMessage ());
   }

   fail ("got validation exception");
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }
  assertNotNull (result);
  assertNotSame (info, result);
  assertNotNull (result.getId ());
  assertEquals (info.getId (), result.getId ());
  assertNotNull (result.getCode ());
  assertEquals ("MATH222", result.getCode ());
  assertEquals (info.getSubjectArea (), result.getSubjectArea ());
  assertEquals (info.getCourseNumberSuffix (), result.getCourseNumberSuffix ());
  assertEquals (info.getCourseTitle (), result.getCourseTitle ());
  audit = false;
  for (AttributeInfo attInfo : result.getAttributes() ) {
	   if (attInfo.getKey().equalsIgnoreCase("audit")) {
		   audit = true;
	   }
  }
  assertEquals ("true", audit);

  // get
  info = result;
  try
  {
   result = courseService.getCourse (info.getId (), ctxInfoHelper.getDefaultContextInfo());
  }
  catch (DoesNotExistException ex)
  {
   fail ("should exist");
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }
  assertNotNull (result);
  assertNotSame (info, result);
  assertNotNull (result.getId ());
  assertEquals (info.getId (), result.getId ());
  assertEquals (info.getCode (), result.getCode ());
  assertEquals (info.getSubjectArea (), result.getSubjectArea ());
  assertEquals (info.getCourseNumberSuffix (), result.getCourseNumberSuffix ());
  assertEquals (info.getCourseTitle (), result.getCourseTitle ());
  audit = false;
  for (AttributeInfo attInfo : result.getAttributes() ) {
	   if (attInfo.getKey().equalsIgnoreCase("audit")) {
		   audit = true;
	   }
  }
  assertEquals ("true", audit);
  
  // delete
//  info = result;
//  try
//  {
//   StatusInfo status = courseService.deleteCourse (info.getId ());
//   assertTrue (status.getSuccess ());
//  }
//  catch (DataValidationErrorException ex)
//  {
//   for (ValidationResultInfo vri : ex.getValidationResults ())
//   {
//    System.out.println (vri.getElement () + " " + vri.getMessage ());
//   }
//   fail ("got validation exception");
//  }
//  catch (Exception ex)
//  {
//   throw new RuntimeException (ex);
//  }
//
//  try
//  {
//   result = courseService.getCourse (info.getId ());
//   fail ("should have thrown does not exist exception");
//  }
//  catch (DoesNotExistException ex)
//  {
//   // as expected
//  }
//  catch (Exception ex)
//  {
//   throw new RuntimeException (ex);
//  }

 }*/
}
