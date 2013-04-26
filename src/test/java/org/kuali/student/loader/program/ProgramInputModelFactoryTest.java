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
package org.kuali.student.loader.program;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.fail;

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
public class ProgramInputModelFactoryTest
{

 public ProgramInputModelFactoryTest ()
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

 public static ProgramInputModelFactory getInstance ()
 {
  Properties props = new Properties ();
  props.putAll (ProgramInputModelFactory.getDefaultConfig ());
  props.put (ProgramInputModelFactory.EXCEL_FILES_DEFAULT_DIRECTORY_KEY,
             "src/main/"
             + ProgramInputModelFactory.RESOURCES_DIRECTORY);
  System.out.println ("Current Directory=" + System.getProperty ("user.dir"));
  ProgramInputModelFactory factory = new ProgramInputModelFactory ();
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
  ProgramInputModelFactory instance = getInstance ();
  ProgramInputModel result = instance.getModel ();
  if (result.getPrograms ().size () < 5)
  {
   fail (" too few programs");
  }
  Program prog = result.getPrograms ().get (0);
  assertEquals ("BSCI", prog.getCode ());
  assertEquals ("BIOLOGICAL SCIENCES", prog.getTranscriptTitle ());
  assertEquals ("BIO SCI", prog.getShortTitle ());
  assertEquals (
    "The Biological Sciences major offers a rigorous exposure to the modern experimental disciplines within Biology. The major is jointly offered by the Departments of Biology, Cell Biology & Molecular Genetics, and Entomology. All Biological Sciences majors complete a common sequence of introductory and supporting courses referred to as the Basic Program. In addition, students must complete an Advanced Program within one of the following specialization areas: Cell Biology & Genetics, Ecology & Evolution, General Biology, Microbiology, Physiology & Neurobiology, Individualized Studies.",
                prog.getDescr ());
  assertEquals ("Active", prog.getState ());
//  System.out.println ("CoreFaculties=" + prog.getCoreFaculties ());
  assertNotNull (prog.getCoreFaculties ());
 }
}
