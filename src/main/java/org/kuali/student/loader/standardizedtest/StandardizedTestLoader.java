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

import java.util.Arrays;
import java.util.List;

import org.kuali.student.loader.util.ContextInfoHelper;
import org.kuali.student.loader.util.RichTextInfoHelper;
import org.kuali.student.r2.common.dto.ValidationResultInfo;
import org.kuali.student.r2.common.exceptions.AlreadyExistsException;
import org.kuali.student.r2.common.exceptions.DataValidationErrorException;
import org.kuali.student.r2.common.exceptions.DoesNotExistException;
import org.kuali.student.r2.core.class1.type.dto.TypeInfo;
import org.kuali.student.r2.lum.clu.dto.CluInfo;
import org.kuali.student.r2.lum.clu.dto.CluSetInfo;
import org.kuali.student.r2.lum.clu.service.CluService;

/**
 *
 * @author nwright
 */
public class StandardizedTestLoader
{

 private CluService cluService;

 public CluService getCluService ()
 {
  return cluService;
 }

 public void setLuService (CluService cluService)
 {
  this.cluService = cluService;
 }

 public StandardizedTestLoader ()
 {
 }
 private List<StandardizedTest> inputDataSource;

 public List<StandardizedTest> getInputDataSource ()
 {
  return inputDataSource;
 }

 public void setInputDataSource (List<StandardizedTest> inputDataSource)
 {
  this.inputDataSource = inputDataSource;
 }

 public List<StandardizedTestLoadResult> update ()
 {
	 ContextInfoHelper ctxInfoHelper = new ContextInfoHelper();
	 
  List<StandardizedTestLoadResult> results = new StandardizedTestsToCluInfosConverter (
    inputDataSource).convert ();
  for (StandardizedTestLoadResult result : results)
  {
   if (result.getStatus () != null)
   {
    continue;
   }
   CluInfo info = result.getCluInfo ();
   CluInfo oldClu = null;
   try
   {
    oldClu = cluService.getClu (info.getId (), ctxInfoHelper.getDefaultContextInfo());
   }
   catch (DoesNotExistException ex)
   {
    // ignore because that is what we are trying to find out
   }
   catch (Exception ex)
   {
    result.setStatus (StandardizedTestLoadResult.Status.EXCEPTION);
    result.setException (ex);
    continue;
   }
   if (oldClu != null)
   {
    result.setStatus (
      StandardizedTestLoadResult.Status.NOT_PROCESSED_BOTH_ALREADY_EXISTS);
    result.setCluInfo (oldClu);
    this.createCluSet (result);
    continue;
   }
   try
   {
    CluInfo createdInfo = cluService.createClu (info.getTypeKey (), info, ctxInfoHelper.getDefaultContextInfo());
    // I don't think I have to do this
//    luService.createNewCluVersion (createdInfo.getId (), "Initial Version");
    result.setCluInfo (createdInfo);
    result.setStatus (StandardizedTestLoadResult.Status.CREATED_JUST_CLU);
    this.createCluSet (result);
    continue;
   }
   catch (DataValidationErrorException ex)
   {
    List<ValidationResultInfo> vris = null;
    try
    {
     vris = cluService.validateClu ("SYSTEM", info, ctxInfoHelper.getDefaultContextInfo());
    }
    catch (Exception ex1)
    {
     throw new RuntimeException (
       "Got an exception trying to get validation errors", ex1);
    }
    DataValidationErrorException dvex = new DataValidationErrorException (
      "got validation errors", vris, ex);
    result.setStatus (StandardizedTestLoadResult.Status.CLU_VALIDATION_ERROR);
    result.setDataValidationErrorException (dvex);
    continue;
   }
   catch (Exception ex)
   {
    result.setStatus (StandardizedTestLoadResult.Status.EXCEPTION);
    result.setException (ex);
    continue;
   }

  }
  return results;
 }

 private void createCluSet (StandardizedTestLoadResult result)
 {
	 ContextInfoHelper ctxInfoHelper = new ContextInfoHelper();
  CluSetInfo info = new CluSetInfo ();
  CluInfo cluInfo = result.getCluInfo ();
//  CLU-ID-SAT-SUBJ-SPANISH-LISTENING-SET
//  123456789012345678901234567890123456
//  0        1         2         3

  info.setId (cluInfo.getId () + "-SET");
  result.setCluSetInfo (info);
  CluSetInfo oldInfo = null;
  try
  {
	  //TODO: verify
	  TypeInfo typeInfo = cluService.getCluSetType (info.getId (), ctxInfoHelper.getDefaultContextInfo());
  }
  catch (DoesNotExistException ex)
  {
   // ignore because that is what we are checking
  }
  catch (Exception ex)
  {
   result.setException (ex);
   result.setStatus (StandardizedTestLoadResult.Status.EXCEPTION);
   return;
  }
  if (oldInfo != null)
  {
   result.setCluSetInfo (oldInfo);
   if (result.getStatus ().equals (
     StandardizedTestLoadResult.Status.CREATED_JUST_CLU))
   {
    result.setStatus (StandardizedTestLoadResult.Status.CREATED_JUST_CLU);
    return;
   }
   else
   {
    result.setStatus (
      StandardizedTestLoadResult.Status.NOT_PROCESSED_BOTH_ALREADY_EXISTS);
    return;
   }
  }
  //  don't do this
//  info.setCluIds (Arrays.asList (cluInfo.getId ()));
  // instead do this
  info.setCluIds (Arrays.asList (cluInfo.getVersion ().getVersionIndId ()));
  System.out.println ("Version Independent Id is " + cluInfo.getVersion ().getVersionIndId ());
  info.setIsReusable (Boolean.TRUE);
  info.setEffectiveDate (cluInfo.getEffectiveDate ());
  info.setExpirationDate (cluInfo.getExpirationDate ());
  info.setTypeKey ("kuali.cluSet.type.Test");
  info.setStateKey ("active");
  info.setName (cluInfo.getOfficialIdentifier ().getLongName ());
  String descr = "Set that holds just the one standardized test "
                 + cluInfo.getOfficialIdentifier ().getLongName ();
  info.setDescr (new RichTextInfoHelper ().getFromPlain (descr));
  try
  {
   System.out.println ("before.id=" + info.getId ());
   CluSetInfo createdCluSetInfo = cluService.createCluSet (info.getTypeKey (), info, ctxInfoHelper.getDefaultContextInfo());
   System.out.println ("after.id=" + createdCluSetInfo.getId ());
   result.setCluSetInfo (createdCluSetInfo);
   if (result.getStatus ().equals (
     StandardizedTestLoadResult.Status.CREATED_JUST_CLU))
   {
    result.setStatus (StandardizedTestLoadResult.Status.CREATED_BOTH);
    return;
   }
   else
   {
    result.setStatus (StandardizedTestLoadResult.Status.CREATED_JUST_CLUSET);
    return;
   }
  }
//  catch (AlreadyExistsException ex)
//  {
//   result.setStatus (
//     StandardizedTestLoadResult.Status.NOT_PROCESSED_BOTH_ALREADY_EXISTS);
//   return;
//  }
  catch (DataValidationErrorException ex)
  {
   List<ValidationResultInfo> vris = null;
   try
   {
    vris = cluService.validateCluSet ("SYSTEM", descr, info, ctxInfoHelper.getDefaultContextInfo());
   }
   catch (Exception ex1)
   {
    throw new RuntimeException (
      "Got an exception trying to get validation errors", ex1);
   }
   DataValidationErrorException dvex = new DataValidationErrorException (
     "got validation errors", vris, ex);
   result.setStatus (StandardizedTestLoadResult.Status.CLUSET_VALIDATION_ERROR);
   result.setDataValidationErrorException (dvex);
   return;
  }
  catch (Exception ex)
  {
   result.setException (ex);
   result.setStatus (StandardizedTestLoadResult.Status.EXCEPTION);
   return;
  }

 }
}
