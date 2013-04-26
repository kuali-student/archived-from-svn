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

import java.util.Date;
import java.util.List;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.kuali.student.r2.lum.program.service.ProgramService;

/**
 *
 * @author nwright
 */
public class ProgramLoaderTest
{

 private static ProgramService programService;

 public ProgramLoaderTest ()
 {
 }

 @BeforeClass
 public static void setUpClass ()
   throws Exception
 {
  ProgramServiceFactory factory = new ProgramServiceFactory ();
  factory.setHostUrl (ProgramServiceFactory.LOCAL_HOST_EMBEDDED_URL);
  programService = factory.getProgramService ();
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
 public void testLoadPrograms ()
   throws Exception
 {
  System.out.println (new Date () + " load programs");

  ProgramLoader progLoader = new ProgramLoader ();
  progLoader.setProgramService (programService);
  ProgramInputModel progModel = ProgramInputModelFactoryTest.getInstance ().
    getModel ();

  System.out.println (new Date () + " getting programs...");
  List<Program> programs = progModel.getPrograms ();
//  List<Program> list = programs.subList (400, 500);
  List<Program> list = programs;
  System.out.println (new Date () + " loading " + list.size ()
                      + " programs");

  progLoader.setInputDataSource (list);
//  progLoader.setInputDataSource (programs);
  List<ProgramLoadResult> results = progLoader.update ();

  // output good results
  for (ProgramLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case MAJOR_DISCIPLINE_CREATED:
    case VARIATION_PROCESSED_WITH_MAJOR_DISCIPLINE:
     System.out.println (result.getMajorDisciplineInfo ().getCode ()
                         + " " + result.getStatus () + " id = "
                         + result.getMajorDisciplineInfo ().getId ());
   }
  }

  // output summary
  for (ProgramLoadResult result : results)
  {
   result.getStatus ().increment ();
  }
  System.out.println (list.size () + " programs");
  for (ProgramLoadResult.Status status :
       ProgramLoadResult.Status.values ())
  {
   System.out.println ("Total with status of " + status + " = "
                       + status.getCount ());
  }

  // output errors
  for (ProgramLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case MAJOR_DISCIPLINE_CREATED:
    case VARIATION_PROCESSED_WITH_MAJOR_DISCIPLINE:
     break;
    default:
     System.out.println (result);
   }
  }
  if (ProgramLoadResult.Status.VALIDATION_ERROR.getCount () > 0)
  {
   throw new RuntimeException (ProgramLoadResult.Status.VALIDATION_ERROR.getCount ()
                               + " records failed to load");
  }
  if (ProgramLoadResult.Status.EXCEPTION.getCount () > 0)
  {
   throw new RuntimeException (ProgramLoadResult.Status.EXCEPTION.getCount ()
                               + " records failed to load");
  }
 }
}
