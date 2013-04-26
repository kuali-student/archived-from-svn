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

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.fail;

import java.util.List;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.kuali.student.loader.util.ContextInfoHelper;
import org.kuali.student.r2.common.exceptions.InvalidParameterException;
import org.kuali.student.r2.common.exceptions.MissingParameterException;
import org.kuali.student.r2.common.exceptions.OperationFailedException;
import org.kuali.student.r2.common.exceptions.PermissionDeniedException;
import org.kuali.student.r2.core.enumerationmanagement.dto.EnumeratedValueInfo;
import org.kuali.student.r2.core.enumerationmanagement.dto.EnumerationInfo;
import org.kuali.student.r2.core.enumerationmanagement.service.EnumerationManagementService;

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
 static ContextInfoHelper ctxInfoHelper ;
 @BeforeClass
 public static void setUpClass () throws Exception
 {
  EnumerationManagementServiceFactory factory =
                                      new EnumerationManagementServiceFactory ();
  factory.setHostUrl (
    EnumerationManagementServiceFactory.LOCAL_HOST_EMBEDDED_URL);
  enumerationManagementService = factory.getEnumerationManagementService ();
  ctxInfoHelper = new ContextInfoHelper();
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
   result = enumerationManagementService.getEnumerations (ctxInfoHelper.getDefaultContextInfo());
  }
  catch (OperationFailedException ex)
  {
   throw new RuntimeException (ex);
  } catch (InvalidParameterException e) {
	// TODO Auto-generated catch block
	throw new RuntimeException(e);
} catch (MissingParameterException e) {
	// TODO Auto-generated catch block
	throw new RuntimeException(e);
} catch (PermissionDeniedException e) {
	// TODO Auto-generated catch block
	throw new RuntimeException(e);
}
  assertNotNull (result);
  if (result.size () == 0)
  {
   fail ("no metadata returned");
  }
  for (EnumerationInfo info : result)
  {
   System.out.println (info.getKey () + " - " + info.getName ());
  }
  for (EnumerationInfo meta : result)
  {
   System.out.println (meta.getKey () + " - " + meta.getName ());
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
     null, ctxInfoHelper.getDefaultContextInfo());
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
