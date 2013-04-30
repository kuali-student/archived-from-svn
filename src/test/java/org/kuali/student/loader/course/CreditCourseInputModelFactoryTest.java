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

import java.util.Properties;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author nwright
 */
public class CreditCourseInputModelFactoryTest
{

 public CreditCourseInputModelFactoryTest ()
 {
 }

 @BeforeClass
 public static void setUpClass ()
   throws Exception
 {
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

 public static CreditCourseInputModelFactory getInstance ()
 {
  Properties props = new Properties ();
  props.putAll (CreditCourseInputModelFactory.getDefaultConfig ());
  props.put (CreditCourseInputModelFactory.EXCEL_FILES_DEFAULT_DIRECTORY_KEY,
             "src/main/" + CreditCourseInputModelFactory.RESOURCES_DIRECTORY);
  System.out.println ("Current Directory=" + System.getProperty ("user.dir"));
  CreditCourseInputModelFactory factory = new CreditCourseInputModelFactory ();
  factory.setConfig (props);
  return factory;
 }

 /**
  * Test of getModel method, of class DataModelFactory.
  */
 @Test
 public void testGetModel ()
 {
  System.out.println ("getModel");
  CreditCourseInputModelFactory instance = getInstance ();
  CreditCourseInputModel result = instance.getModel (CreditCourseInputModelFactory.CREDIT_COURSE_LOADER);
  if (result.getCreditCourses ().size () < 100)
  {
   fail (" too few courses");
  }
  boolean found = false;
  for (CreditCourse cc : result.getCreditCourses ())
  {
   if ("AACH 101".equals (cc.getCode ()))
   {
    found = true;
    assertEquals ("AACH", cc.getSubjectArea ());
    assertEquals ("101", cc.getCourseNumberSuffix ());
    assertEquals ("Art & Architecture", cc.getAdministeringOrgName ());
    assertEquals ("Survey Art & Arch I", cc.getTranscriptTitle ());
    assertEquals ("Survey of Art & Arch I", cc.getCourseTitle ());
    assertEquals (
      "Principles of art. Relation of styles to cultural context. Art and architecture from ancient times to the end of the Middle Ages.",
      cc.getDescr ());
    assertEquals ("3", cc.getMaxCredits ());
    assertEquals (
      "kuali.resultComponent.grade.letter kuali.resultComponent.grade.passFail",
                  cc.getGradingOptions ());
    assertEquals (
      "kuali.atp.season.Fall kuali.atp.season.Spring kuali.atp.season.Winter",
      cc.getTermsOffered ());
    assertEquals ("ALT", cc.getFinalExam ());
    assertEquals ("Has Exhibit instead", cc.getFinalExamRationale ());
    assertEquals (true, cc.isAudit ());
    assertEquals (true, cc.isPassFail ());
    assertEquals (false, cc.isSpecialTopics ());
   }
  }
  if ( ! found)
  {
   fail ("Could not find AACH 101");
  }
 }
}
