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

import java.util.Date;
import java.util.List;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.kuali.student.r2.core.atp.service.AtpService;

/**
 *
 * @author nwright
 */
public class AtpLoaderTest
{

 public AtpLoaderTest ()
 {
 }
 private static AtpService atpService;

 @BeforeClass
 public static void setUpClass () throws Exception
 {
  AtpServiceFactory factory = new AtpServiceFactory ();
  factory.setHostUrl (AtpServiceFactory.LOCAL_HOST_EMBEDDED_URL);
  atpService = factory.getAtpService ();
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
 public void testLoadAtps ()
   throws Exception
 {
  System.out.println (new Date () + " load atps");

  AtpLoader atpLoader = new AtpLoader ();
  atpLoader.setAtpService (atpService);
  AtpInputModel atpModel = AtpInputModelFactoryTest.getInstance ().
    getModel ();

  System.out.println (new Date () + " getting atps...");
  List<Atp> atps = atpModel.getAtps ();

  System.out.println (new Date () + " loading " + atps.size ()
                      + " atps");
//  ccLoader.setInputDataSource (orgs.subList (372, 373).iterator ());
  atpLoader.setInputDataSource (atps);
  List<AtpLoadResult> results = atpLoader.load ();
  // output good results
  for (AtpLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case CREATED:
     System.out.println (result.getAtpInfo ().getId ()
                         + " " + result.getStatus ());
   }
  }
  for (AtpLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case UPDATED:
     System.out.println (result.getAtpInfo ().getId ()
                         + " " + result.getStatus ());
   }
  }


  // output summary
  for (AtpLoadResult result : results)
  {
   result.getStatus ().increment ();
  }
  System.out.println (atps.size () + " atps");
  for (AtpLoadResult.Status status :
       AtpLoadResult.Status.values ())
  {
   System.out.println ("Total with status of " + status + " = "
                       + status.getCount ());
  }

  // output errors
  for (AtpLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case CREATED:
    case UPDATED:
    case NO_CHANGE:
     break;
    default:
     System.out.println (result);
   }
  }
  if (AtpLoadResult.Status.VALIDATION_ERROR.getCount () > 0)
  {
   throw new RuntimeException (AtpLoadResult.Status.VALIDATION_ERROR.getCount ()
                               + " records failed to load");
  }
  if (AtpLoadResult.Status.EXCEPTION.getCount () > 0)
  {
   throw new RuntimeException (AtpLoadResult.Status.EXCEPTION.getCount ()
                               + " records failed to load");
  }
 }
}
