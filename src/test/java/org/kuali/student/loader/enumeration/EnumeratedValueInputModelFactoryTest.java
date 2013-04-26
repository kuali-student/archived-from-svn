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
package org.kuali.student.loader.enumeration;

import org.kuali.student.loader.util.DateHelper;
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
public class EnumeratedValueInputModelFactoryTest
{

 public EnumeratedValueInputModelFactoryTest ()
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

 public static EnumeratedValueInputModelFactory getInstance ()
 {
  Properties props = new Properties ();
  props.putAll (EnumeratedValueInputModelFactory.getDefaultConfig ());
  props.put (EnumeratedValueInputModelFactory.EXCEL_FILES_DEFAULT_DIRECTORY_KEY, "src/main/"
   + EnumeratedValueInputModelFactory.RESOURCES_DIRECTORY);
  System.out.println ("Current Directory=" + System.getProperty ("user.dir"));
  EnumeratedValueInputModelFactory factory = new EnumeratedValueInputModelFactory ();
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
  EnumeratedValueInputModelFactory instance = getInstance ();
  EnumeratedValueInputModel result = instance.getModel ();
  if (result.getEnumeratedValues ().size () < 100)
  {
   System.out.println (result.getEnumeratedValues ().size () + " values found");
   fail (" too few enumerations");
  }
  EnumeratedValue ev = result.getEnumeratedValues ().get (0);
  assertEquals ("kuali.enum.type.cip2010", ev.getEnumerationKey ());
  assertEquals ("01", ev.getCode ());
  assertEquals ("01", ev.getAbbrevValue ());
  assertEquals ("AGRICULTURE, AGRICULTURE OPERATIONS, AND RELATED SCIENCES.", ev.getValue ());
  assertEquals (new DateHelper ().asDate ("2010-07-01"), ev.getEffectiveDate ());
  assertEquals (null, ev.getExpirationDate ());
  assertEquals ((Integer) 2, ev.getSortKey ());
  assertEquals (null, ev.getContexts ());
 }

}
