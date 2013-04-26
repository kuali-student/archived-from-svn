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
import static org.junit.Assert.assertNotSame;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.util.List;

import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.kuali.student.loader.util.ContextInfoHelper;
import org.kuali.student.loader.util.DateHelper;
import org.kuali.student.r2.common.dto.StatusInfo;
import org.kuali.student.r2.common.dto.ValidationResultInfo;
import org.kuali.student.r2.common.exceptions.DataValidationErrorException;
import org.kuali.student.r2.common.exceptions.DoesNotExistException;
import org.kuali.student.r2.lum.program.dto.MajorDisciplineInfo;
import org.kuali.student.r2.lum.program.service.ProgramService;

public class ProgramServiceTest
{

 public ProgramServiceTest ()
 {
 }
 private static ProgramService programService;
 static ContextInfoHelper ctxInfoHelper ;
 @Before
 public void setUp () throws Exception
 {
 }

 @BeforeClass
 public static void setUpClass () throws Exception
 {
  ProgramServiceFactory factory = new ProgramServiceFactory ();
  factory.setHostUrl (ProgramServiceFactory.LOCAL_HOST_EMBEDDED_URL);
  programService = factory.getProgramService ();
  ctxInfoHelper = new ContextInfoHelper();
 }

 @AfterClass
 public static void tearDownClass () throws Exception
 {
 }


 /**
  * Test of createProgram method, of class ProgramService.
  */
 @Test
 public void testCreateProgram ()
 {
  System.out.println ("createProgram");
  MajorDisciplineInfo info = new MajorDisciplineInfo ();
  info.setCredentialProgramId ("d02dbbd3-20e2-410d-ab52-1bd6d362748b");
  info.setCode ("BSCI");
  info.setStateKey ("draft");
  info.setTypeKey ("kuali.lu.type.MajorDiscipline");
  info.setShortTitle ("Bio Sci");
  info.setEffectiveDate (new DateHelper ().asDate ("2010-01-01"));
  MajorDisciplineInfo result = null;
  try
  {
   result = programService.createMajorDiscipline (info.getTypeKey(), info, ctxInfoHelper.getDefaultContextInfo());
   assertNotNull (result);
   assertNotSame (info, result);
   assertNotNull (result.getId ());
   assertEquals ("BSCI", result.getCode ());
   assertEquals ("Bio Sci", result.getShortTitle ());
  
  }
  catch (DataValidationErrorException ex)
  {
   for (ValidationResultInfo vri : ex.getValidationResults ())
   {
    System.out.println (vri.getElement () + " " + vri.getMessage ());
   }
   fail ("got validation exception");
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }

  // get
  info = result;
  try
  {
   result = programService.getMajorDiscipline (info.getId (), ctxInfoHelper.getDefaultContextInfo());
  }
  catch (DoesNotExistException ex)
  {
   fail ("should exist");
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }
  assertNotNull (result);
  assertNotSame (info, result);
  assertNotNull (result.getId ());
  assertEquals (info.getId (), result.getId ());
  assertEquals (info.getCode (), result.getCode ());
  assertEquals (info.getShortTitle (), result.getShortTitle ());

  // update
  info = result;
  info.setShortTitle ("Bio Sci - Updated");
  try
  {
   result = programService.updateMajorDiscipline (info.getTypeKey(), info, ctxInfoHelper.getDefaultContextInfo());
  }
  catch (DoesNotExistException ex)
  {
   fail ("should exist");
  }
  catch (DataValidationErrorException ex)
  {
   List<ValidationResultInfo> vris = ex.getValidationResults ();
   if (vris == null)
   {
    System.out.println (
      "got DataValidationErrorException but no validation results");
    try
    {
     vris = programService.validateMajorDiscipline ("system", info, ctxInfoHelper.getDefaultContextInfo());
    }
    catch (Exception ex2)
    {
     throw new RuntimeException (ex2);
    }
   }
   for (ValidationResultInfo vri : vris)
   {
    System.out.println (vri.getElement () + " " + vri.getMessage ());
   }

   fail ("got validation exception");
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }
  assertNotNull (result);
  assertNotSame (info, result);
  assertNotNull (result.getId ());
  assertEquals (info.getId (), result.getId ());
  assertNotNull (result.getCode ());
  assertEquals (info.getCode (), result.getCode ());
  assertEquals (info.getShortTitle (), result.getShortTitle ());


  // get
  info = result;
  try
  {
   result = programService.getMajorDiscipline (info.getId (), ctxInfoHelper.getDefaultContextInfo());
  }
  catch (DoesNotExistException ex)
  {
   fail ("should exist");
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }
  assertNotNull (result);
  assertNotSame (info, result);
  assertNotNull (result.getId ());
  assertEquals (info.getId (), result.getId ());
  assertNotNull (result.getCode ());
  assertEquals (info.getCode (), result.getCode ());
  assertEquals (info.getShortTitle (), result.getShortTitle ());

  // delete
  info = result;
  try
  {
   StatusInfo status = programService.deleteMajorDiscipline (info.getId (), ctxInfoHelper.getDefaultContextInfo());
   assertTrue (status.getIsSuccess());
  }
//  catch (DataValidationErrorException ex)
//  {
//   for (ValidationResultInfo vri : ex.getValidationResults ())
//   {
//    System.out.println (vri.getElement () + " " + vri.getMessage ());
//   }
//   fail ("got validation exception");
//  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }

  try
  {
   result = programService.getMajorDiscipline (info.getId (), ctxInfoHelper.getDefaultContextInfo());
   fail ("should have thrown does not exist exception");
  }
  catch (DoesNotExistException ex)
  {
   // as expected
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }

 }
}
