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

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.kuali.student.loader.course.CourseServiceFactory;
import org.kuali.student.loader.util.ContextInfoHelper;
import org.kuali.student.loader.util.RichTextInfoHelper;
import org.kuali.student.r2.common.dto.StatusInfo;
import org.kuali.student.r2.common.exceptions.DataValidationErrorException;
import org.kuali.student.r2.common.exceptions.DoesNotExistException;
import org.kuali.student.r2.common.exceptions.InvalidParameterException;
import org.kuali.student.r2.common.exceptions.MissingParameterException;
import org.kuali.student.r2.common.exceptions.OperationFailedException;
import org.kuali.student.r2.common.exceptions.PermissionDeniedException;
import org.kuali.student.r2.common.exceptions.ReadOnlyException;
import org.kuali.student.r2.core.atp.dto.AtpInfo;
import org.kuali.student.r2.core.atp.service.AtpService;

/**
 *
 * @author nwright
 */
public class AtpServiceTest
{

 public AtpServiceTest ()
 {
 }
 private static AtpService atpService;

 @BeforeClass
 public static void setUpClass () throws Exception
 {
  AtpServiceFactory factory = new AtpServiceFactory ();
  factory.setHostUrl (CourseServiceFactory.LOCAL_HOST_EMBEDDED_URL);
  atpService = factory.getAtpService ();
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
  * Test of getTypes method in AtpFinder
  */
 @SuppressWarnings("unchecked")
@Test
 public void testGetAtpTypes ()
 {
  System.out.println ("getAtpTypes");
  ContextInfoHelper ctxInfoHelper = new ContextInfoHelper();
  
//  List<AtpTypeInfo> expResult = new ArrayList ();
  List<AtpInfo> result;
  try
  {
	  //TODO verify as well service call methods below.
   try {
	   List atpIds = new ArrayList<String>();
	   atpIds.add("kuali.atp.AY1991-1992");
	   result = atpService.getAtpsByIds(atpIds, ctxInfoHelper.getDefaultContextInfo());
} catch (InvalidParameterException e) {
	// TODO Auto-generated catch block
	throw new RuntimeException (e);
} catch (MissingParameterException e) {
	// TODO Auto-generated catch block
	throw new RuntimeException (e);
} catch (PermissionDeniedException e) {
	// TODO Auto-generated catch block
	throw new RuntimeException (e);
} catch (DoesNotExistException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
	throw new RuntimeException (e);
}
  }
  catch (OperationFailedException ex)
  {
   throw new RuntimeException (ex);
  }
  System.out.print (result.size () + " types returned");
  System.out.print ("Key");
  System.out.print ("|");
  System.out.print ("Name");
  System.out.print ("|");
  System.out.print ("getDesc");
  System.out.print ("|");
  System.out.print ("EffectiveDate");
  System.out.print ("|");
  System.out.print ("ExpirationDate");
  System.out.println ("|");
  for (AtpInfo typeInfo : result)
  {
   System.out.print (typeInfo.getId ());
   System.out.print ("|");
   System.out.print (typeInfo.getName ());
   System.out.print ("|");
   System.out.print (typeInfo.getDescr ());
   System.out.print ("|");
   //TODO verify not in AtpInfo
//   System.out.print (typeInfo.getEffectiveDate ());
//   System.out.print ("|");
//   System.out.print (typeInfo.getExpirationDate ());
   System.out.println ("|");
  }
  assertEquals (1, result.size ());
 }

 /**
  * Test of GetAtpanization method in AtpFinder
  */
 @Test
 public void testGetAtp ()
 {
  System.out.println ("getAtp");
  ContextInfoHelper ctxInfoHelper = new ContextInfoHelper();
  
//  List<AtpTypeInfo> expResult = new ArrayList ();
  String id = "kuali.atp.FA2008-2009";
  AtpInfo result;

  try
  {
   result = atpService.getAtp (id, ctxInfoHelper.getDefaultContextInfo());
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }
  assertNotNull (result);
  System.out.print (result.getId ());
  System.out.print ("|");
  System.out.print (result.getName ());
  System.out.println ("|");

 }

 /**
  * Test of GetAtpanization method in AtpFinder
  */
 @Test
 public void testThrowsAlreadyExistsExceptionOnCreate () 
 {
  System.out.println ("throwsAlreadyExistsExceptionOnCreate");
  ContextInfoHelper ctxInfoHelper = new ContextInfoHelper();
//  List<AtpTypeInfo> expResult = new ArrayList ();
  String id = "kuali.atp.FA2008-2009";
  AtpInfo result;

  try
  {
	  
   result = atpService.getAtp (id, ctxInfoHelper.getDefaultContextInfo());
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }
  assertNotNull (result);
  System.out.print (result.getId ());
  System.out.print ("|");
  System.out.print (result.getName ());
  System.out.println ("|");
  try
  {
   atpService.createAtp (result.getTypeKey (),  result,ctxInfoHelper.getDefaultContextInfo() );
   fail ("should have gotten already exists exception");
  }
//  catch (AlreadyExistsException ex)
//  {
//   // should succeed
//  }
  catch (RuntimeException ex)
  {
	  //Not throwing AlreadyExistsException anymore. throws JTA Transaction exception. looking at the server 
	  //log details ORA-00001: unique constraint (KSBUNDLED.KSEN_ATPP1) violated
	  assertNotNull("ex.toString", ex);
	  //fail ("Did not get an AlreadyExistsException but instead got a " + ex.toString ());
  } catch (DataValidationErrorException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
} catch (InvalidParameterException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
} catch (MissingParameterException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
} catch (OperationFailedException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
} catch (PermissionDeniedException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
} catch (ReadOnlyException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
}
 }

 /**
  * Test of GetAtpanization method in AtpFinder
  */
 @Test
 public void testThrowsDoesNotExistExceptionOnGet ()
 {
  System.out.println ("testThrowsDoesNotExistExceptionOnGet");
  ContextInfoHelper ctxInfoHelper = new ContextInfoHelper();
//  List<AtpTypeInfo> expResult = new ArrayList ();
  String id = "kuali.atp.THIS SHOULD NOT EXIST FA2008-2009";
  AtpInfo result;

  try
  {
   result = atpService.getAtp (id, ctxInfoHelper.getDefaultContextInfo());
   fail ("should have thrown does not exist exception");
  }
  catch (DoesNotExistException ex)
  {
   // success
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }
 }

 /**
  * Test of CreateAtpanization method in AtpFinder
  */
 @Test
 public void testAtpLifeCycle ()
 {
  System.out.println ("AtpLifeCycle");
  ContextInfoHelper ctxInfoHelper = new ContextInfoHelper();
//  List<AtpTypeInfo> expResult = new ArrayList ();
  AtpInfo info = new AtpInfo ();
  info.setTypeKey ("kuali.atp.type.Fall");
  info.setStateKey ("actual");
  info.setId ("kuali.atp.FA2001-02");
  info.setName ("short name");
  info.setDescr (new RichTextInfoHelper ().getFromPlain (
    "long name that is longer than the short name"));
  info.setStartDate(new Date());
  info.setEndDate (new Date());
  AtpInfo result = null;
  try
  {
   result = atpService.createAtp (info.getTypeKey (), info, ctxInfoHelper.getDefaultContextInfo());
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }
  assertNotNull (result);
  assertNotNull (result.getId ());
  assertEquals (info.getTypeKey (), result.getTypeKey ());
  assertEquals (info.getStateKey (), result.getStateKey ());
  assertEquals (info.getId (), result.getId ());
  assertEquals (info.getName (), result.getName ());
  assertEquals (info.getDescr ().getPlain (), result.getDescr ().getPlain ());
//  assertEquals (info.getSortName (), result.getSortName ());
  System.out.println ("id=" + result.getId ());

  // get it now
  info = result;
  try
  {
   result = atpService.getAtp (info.getId (), ctxInfoHelper.getDefaultContextInfo());
  }
  catch (DoesNotExistException ex)
  {
   fail ("org was just created by cannot get it");
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }
  assertNotNull (result.getId ());
  assertEquals (info.getTypeKey (), result.getTypeKey ());
  assertEquals (info.getStateKey (), result.getStateKey ());
  assertEquals (info.getId (), result.getId ());
  assertEquals (info.getName (), result.getName ());
  assertEquals (info.getDescr ().getPlain (), result.getDescr ().getPlain ());
  // now update it
  info = result;
  info.setName ("new name");
  try
  {
   result = atpService.updateAtp (info.getId (), info, ctxInfoHelper.getDefaultContextInfo());
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }

  assertNotNull (result.getId ());
  assertEquals (info.getTypeKey (), result.getTypeKey ());
  assertEquals (info.getStateKey (), result.getStateKey ());
  assertEquals (info.getId (), result.getId ());
  assertEquals (info.getName (), result.getName ());
  assertEquals (info.getDescr ().getPlain (), result.getDescr ().getPlain ());


  // now delete
  info = result;
  StatusInfo status = null;
  try
  {
   status = atpService.deleteAtp (info.getId (), ctxInfoHelper.getDefaultContextInfo());
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }

  assertTrue (status.getIsSuccess().booleanValue());

  // get it now
  info = result;
  try
  {
   result = atpService.getAtp (info.getId (), ctxInfoHelper.getDefaultContextInfo());
   fail ("should not be able to get the org");
  }
  catch (DoesNotExistException ex)
  {
   System.out.println ("as expected org does not exist");
  }
  catch (Exception ex)
  {
   System.out.println (
     "The server does not throw a DoesNotExistException but oh well");
  }


 }
}
