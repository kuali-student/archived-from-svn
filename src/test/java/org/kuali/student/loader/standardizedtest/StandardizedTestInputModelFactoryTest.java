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
package org.kuali.student.loader.standardizedtest;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.fail;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

/**
 *
 * @author nwright
 */
public class StandardizedTestInputModelFactoryTest
{

 public StandardizedTestInputModelFactoryTest ()
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

 public static StandardizedTestInputModelFactory getInstance ()
 {
  Properties props = new Properties ();
  props.putAll (StandardizedTestInputModelFactory.getDefaultConfig ());
  props.put (StandardizedTestInputModelFactory.EXCEL_FILES_DEFAULT_DIRECTORY_KEY, "src/main/"
   + StandardizedTestInputModelFactory.RESOURCES_DIRECTORY);
  System.out.println ("Current Directory=" + System.getProperty ("user.dir"));
  StandardizedTestInputModelFactory factory = new StandardizedTestInputModelFactory ();
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
  StandardizedTestInputModelFactory instance = getInstance ();
  StandardizedTestInputModel result = instance.getModel ();
  if (result.getStandardizedTests ().size () < 50)
  {
   fail (" too few standardized tests");
  }
  StandardizedTest st = result.getStandardizedTests ().get (1);
  assertEquals ("CLU-ID-SAT-COMPOSITE", st.getParentId ());
  assertEquals ("SAT", st.getTest ());
  assertEquals ("MATH", st.getComponent ());
  assertEquals ("kuali.lu.type.standardized.test.component", st.getType ());
  assertEquals ("Active", st.getState ());
  assertEquals (toDate ("2000-01-01"), st.getEffective ());
  assertNull (st.getExpiration ());
  assertEquals ("UND", st.getLevel ());
  assertEquals ("ETS", st.getOrgName ());
  assertEquals ("ORG-ID-ETS", st.getOrgId ());
  assertEquals ("Math", st.getShortName ());
  assertEquals ("SAT Math", st.getLongName ());
  assertEquals ("Math", st.getDescr ());
  assertEquals ("200", st.getMinScore ());
  assertEquals ("800", st.getMaxScore ());
 }


 private Date toDate (String str)
 {
  if (str == null)
  {
   return null;
  }
  SimpleDateFormat df = new SimpleDateFormat ("yyyy-MM-dd");
  try
  {
   return df.parse (str);
  }
  catch (ParseException ex)
  {
   throw new RuntimeException (ex);
  }
 }
}
