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
package org.kuali.student.loader.atp;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
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
public class AtpInputModelFactoryTest
{

 public AtpInputModelFactoryTest ()
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

 public static AtpInputModelFactory getInstance ()
 {
  Properties props = new Properties ();
  props.putAll (AtpInputModelFactory.getDefaultConfig ());
  props.put (AtpInputModelFactory.EXCEL_FILES_DEFAULT_DIRECTORY_KEY,
             "src/main/"
             + AtpInputModelFactory.RESOURCES_DIRECTORY);
  System.out.println ("Current Directory=" + System.getProperty ("user.dir"));
  AtpInputModelFactory factory = new AtpInputModelFactory ();
  factory.setConfig (props);
  return factory;
 }

 /**
  * Test of getModel method, of class DataModelFactory.
  */
 @Test
 public void testGetModel ()
   throws Exception
 {
  System.out.println ("getModel");
  AtpInputModelFactory instance = getInstance ();
  AtpInputModel result = instance.getModel ();
  if (result.getAtps ().size () < 50)
  {
   fail (" too few courses");
  }
  boolean found = false;
  for (Atp atp : result.getAtps ())
  {
   if ("kuali.atp.AY2008-2009".equals (atp.getId ()))
   {
    found = true;
    assertEquals ("AY 2008-2009", atp.getName ());
    assertEquals ("Academic Year 2008-2009", atp.getDescr ().getPlain ());
    assertEquals ("kuali.atp.type.AY", atp.getTypeKey ());
    assertEquals ("Actual", atp.getStateKey ());
    DateFormat format = new SimpleDateFormat ("yyyy-MM-dd");

    assertEquals (format.parse ("2008-09-01"), atp.getStartDate ());
    assertEquals (format.parse ("2009-08-31"), atp.getEndDate ());
   }
  }
  if ( ! found)
  {
   fail ("could not find " + "kuali.atp.AY2008-2009");
  }
 }
}
