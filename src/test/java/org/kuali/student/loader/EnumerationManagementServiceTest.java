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
package org.kuali.student.loader;

import java.util.List;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.kuali.student.core.enumerationmanagement.dto.EnumeratedValueInfo;
import org.kuali.student.core.enumerationmanagement.dto.EnumerationInfo;
import org.kuali.student.core.enumerationmanagement.service.EnumerationManagementService;
import static org.junit.Assert.*;
import org.kuali.student.core.exceptions.OperationFailedException;

/**
 *
 * @author nwright
 */
public class EnumerationManagementServiceTest
{

 public EnumerationManagementServiceTest ()
 {
 }
 private static EnumerationManagementService enumerationManagementService;

 @BeforeClass
 public static void setUpClass () throws Exception
 {
  EnumerationManagementServiceFactory factory =
                                      new EnumerationManagementServiceFactory ();
  factory.setHostUrl (EnumerationManagementServiceFactory.LOCAL_HOST_EMBEDDED_URL);
  enumerationManagementService = factory.getEnumerationManagementService ();
 }

 @AfterClass
 public static void tearDownClass () throws Exception
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
  * Test getting a list of possible enumerations
  */
 @Test
 public void testGetEnumerations ()
 {
  System.out.println ("testGetEnumerations");
  List<EnumerationInfo> result = null;
  try
  {
   result = enumerationManagementService.getEnumerations ();
  }
  catch (OperationFailedException ex)
  {
   throw new RuntimeException (ex);
  }
  assertNotNull (result);
  if (result.size () == 0)
  {
   fail ("no metadata returned");
  }
  for (EnumerationInfo info : result)
  {
   System.out.println (info.getId () + " - " + info.getName ());
  }
  for (EnumerationInfo meta : result)
  {
   System.out.println (meta.getId () + " - " + meta.getName ());
   System.out.println ("     Desc=" + meta.getDescr ());
   String contextsLabel = "     Contexts=";
   for (String context : meta.getContextDescriptors ())
   {
    System.out.println ("     " + contextsLabel + context);
    contextsLabel = "              ";
   }
  }
 }

 /**
  * Test getting a list of possible enumerations
  */
 @Test
 public void testGetEnumerationValues ()
 {
  System.out.println ("testGetEnumerations");
  List<EnumeratedValueInfo> result = null;
  try
  {
   result = enumerationManagementService.getEnumeratedValues (
     "kuali.atptype.duration",
     null,
     null,
     null);
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }
  assertNotNull (result);
  if (result.size () == 0)
  {
   fail ("no metadata returned");
  }
  for (EnumeratedValueInfo info : result)
  {
   System.out.println (info.getEnumerationKey ()
                       + " " + info.getAbbrevValue ()
                       + " - " + info.getCode ()
                       + " " + info.getSortKey ()
                       + " " + info.getValue ());
  }
 }
}
