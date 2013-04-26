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

import java.util.Date;
import java.util.List;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.kuali.student.r2.lum.clu.service.CluService;

/**
 *
 * @author nwright
 */
public class StandardizedTestLoaderTest
{

 private static CluService cluService;

 public StandardizedTestLoaderTest ()
 {
 }

 @BeforeClass
 public static void setUpClass ()
   throws Exception
 {
  LuServiceFactory factory = new LuServiceFactory ();
  factory.setHostUrl (LuServiceFactory.LOCAL_HOST_EMBEDDED_URL);
  cluService = factory.getCluService ();
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
 public void testLoadStandardizedTests ()
   throws Exception
 {
  System.out.println (new Date () + " load standardized tests");

  StandardizedTestLoader ccLoader = new StandardizedTestLoader ();
  ccLoader.setLuService (cluService);
  StandardizedTestInputModel ccModel = StandardizedTestInputModelFactoryTest.getInstance ().
    getModel ();

  System.out.println (new Date () + " getting standardized tests...");
  List<StandardizedTest> standardizedTests = ccModel.getStandardizedTests ();
//  List<StandardizedTest> list = standardizedTests.subList (400, 500);
  List<StandardizedTest> list = standardizedTests;
  System.out.println (new Date () + " loading " + list.size ()
                      + " standardized tests");

  ccLoader.setInputDataSource (list);
//  ccLoader.setInputDataSource (standardizedTests);
  List<StandardizedTestLoadResult> results = ccLoader.update ();

  // output good results
  for (StandardizedTestLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case CREATED_BOTH:
    case NOT_PROCESSED_BOTH_ALREADY_EXISTS:
     System.out.println (result.getCluInfo ().getOfficialIdentifier ().getCode ()
                         + " " + result.getStatus () + " id = "
                         + result.getCluInfo ().getId ());
   }
  }

  // output summary
  for (StandardizedTestLoadResult result : results)
  {
   result.getStatus ().increment ();
  }
  System.out.println (list.size () + " standardized tests");
  for (StandardizedTestLoadResult.Status status :
       StandardizedTestLoadResult.Status.values ())
  {
   System.out.println ("Total with status of " + status + " = "
                       + status.getCount ());
  }

  // output errors
  for (StandardizedTestLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case CREATED_BOTH:
    case NOT_PROCESSED_BOTH_ALREADY_EXISTS:
     break;
    default:
     System.out.println (result);
   }
  }
  if (StandardizedTestLoadResult.Status.CLU_VALIDATION_ERROR.getCount () > 0)
  {
   throw new RuntimeException (StandardizedTestLoadResult.Status.CLU_VALIDATION_ERROR.getCount ()
                               + " records failed to load");
  }
  if (StandardizedTestLoadResult.Status.EXCEPTION.getCount () > 0)
  {
   throw new RuntimeException (StandardizedTestLoadResult.Status.EXCEPTION.getCount ()
                               + " records failed to load");
  }
 }
}
