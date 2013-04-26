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
package org.kuali.student.loader.organization;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

import java.util.List;
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
public class PositionRestrictionInputModelFactoryTest
{

 public PositionRestrictionInputModelFactoryTest ()
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

 public static PositionRestrictionInputModelFactory getInstance ()
 {
  Properties props = new Properties ();
  props.putAll (PositionRestrictionInputModelFactory.getDefaultConfig ());
  props.put (PositionRestrictionInputModelFactory.EXCEL_FILES_DEFAULT_DIRECTORY_KEY, "src/main/"
   + PositionRestrictionInputModelFactory.RESOURCES_DIRECTORY);
  System.out.println ("Current Directory=" + System.getProperty ("user.dir"));
  PositionRestrictionInputModelFactory factory = new PositionRestrictionInputModelFactory ();
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
  PositionRestrictionInputModelFactory instance = getInstance ();
  PositionRestrictionInputModel result = instance.getModel ();
  List<OrgPositionRestriction> posRestrictions = result.getOrgPositionRestrictions();
  
  if (posRestrictions.size () < 16)
  {
   fail (" too few posRestrictions");
  }
  OrgPositionRestriction posRestriction = posRestrictions.get (1);
  assertEquals ("2", posRestriction.getOrgId());
 
 }

}
