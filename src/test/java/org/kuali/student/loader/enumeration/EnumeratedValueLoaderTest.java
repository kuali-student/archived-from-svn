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

import java.util.Date;
import java.util.List;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.kuali.student.r2.core.enumerationmanagement.service.EnumerationManagementService;

/**
 *
 * @author nwright
 */
public class EnumeratedValueLoaderTest
{

 public EnumeratedValueLoaderTest ()
 {
 }
 private static EnumerationManagementService enumerationManagementService;

 @BeforeClass
 public static void setUpClass () throws Exception
 {
  EnumerationManagementServiceFactory factory =
                                      new EnumerationManagementServiceFactory ();
  factory.setHostUrl (
    EnumerationManagementServiceFactory.LOCAL_HOST_EMBEDDED_URL);
  enumerationManagementService = factory.getEnumerationManagementService ();
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
 public void testLoadEnumeratedValues ()
   throws Exception
 {
  System.out.println (new Date () + " load enumerated values");

  EnumeratedValueLoader ccLoader = new EnumeratedValueLoader ();
  ccLoader.setEnumerationManagementService (enumerationManagementService);
  EnumeratedValueInputModel ccModel = EnumeratedValueInputModelFactoryTest.getInstance ().
    getModel ();

  System.out.println (new Date () + " getting enumerated values...");
  List<EnumeratedValue> enumeratedValues = ccModel.getEnumeratedValues ();

  System.out.println (new Date () + " loading " + enumeratedValues.size ()
                      + " enumerated values");
  ccLoader.setInputDataSource (enumeratedValues);
//  ccLoader.setInputDataSource (creditCourses.iterator ());
  List<EnumeratedValueLoadResult> results = ccLoader.update ();
  // output good results
  for (EnumeratedValueLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case CREATED:
     System.out.println (result.getEnumeratedValueInfo ().getCode ()
                         + " " + result.getStatus () + " id = "
                         + result.getEnumeratedValueInfo ().getValue ());
   }
  }

  // output summary
  for (EnumeratedValueLoadResult result : results)
  {
   result.getStatus ().increment ();
  }
  System.out.println (enumeratedValues.size () + " enumerated values");
  for (EnumeratedValueLoadResult.Status status :
       EnumeratedValueLoadResult.Status.values ())
  {
   System.out.println ("Total with status of " + status + " = "
                       + status.getCount ());
  }

  // output errors
  for (EnumeratedValueLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case VALIDATION_ERROR:
    case EXCEPTION:
     System.out.println (result);
   }
  }
  if (EnumeratedValueLoadResult.Status.VALIDATION_ERROR.getCount () > 0)
  {
   throw new RuntimeException (EnumeratedValueLoadResult.Status.VALIDATION_ERROR.getCount ()
                               + " records failed to load");
  }
  if (EnumeratedValueLoadResult.Status.EXCEPTION.getCount () > 0)
  {
   throw new RuntimeException (EnumeratedValueLoadResult.Status.EXCEPTION.getCount ()
                               + " records failed to load");
  }
 }
}
