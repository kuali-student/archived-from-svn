/*
 * Copyright 2010 The Kuali Foundation
 *
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may	obtain a copy of the License at
 *
 * 	http://www.osedu.atp/licenses/ECL-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.kuali.student.loader.atp;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import org.kuali.student.loader.util.ContextInfoHelper;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.common.dto.RichTextInfo;
import org.kuali.student.r2.common.dto.ValidationResultInfo;
import org.kuali.student.r2.common.exceptions.AlreadyExistsException;
import org.kuali.student.r2.common.exceptions.DataValidationErrorException;
import org.kuali.student.r2.common.exceptions.DoesNotExistException;
import org.kuali.student.r2.core.atp.dto.AtpInfo;
import org.kuali.student.r2.core.atp.service.AtpService;

/**
 *
 * @author nwright
 */
public class AtpLoader
{

 private AtpService atpService;

 public AtpService getAtpService ()
 {
  return atpService;
 }

 public void setAtpService (AtpService atpService)
 {
  this.atpService = atpService;
 }

 ContextInfo contextInfo;
 
 public AtpLoader ()
 {
	 ContextInfoHelper ctxInfoHelper = new ContextInfoHelper();
	 contextInfo = ctxInfoHelper.getDefaultContextInfo();
 }
 private List<Atp> inputDataSource;

 public List<Atp> getInputDataSource ()
 {
  return inputDataSource;
 }

 public void setInputDataSource (List<Atp> inputDataSource)
 {
  this.inputDataSource = inputDataSource;
 }

 public List<AtpLoadResult> load ()
 {
  List<AtpLoadResult> results = new ArrayList (500);
  int row = 0;
  for (Atp atp : inputDataSource)
  {
   AtpLoadResult result = new AtpLoadResult ();
   results.add (result);
   row ++;
   AtpInfo info = new AtpToAtpInfoConverter (atp).convert ();
   result.setRow (row);
   result.setAtp (atp);
   result.setAtpInfo (info);
   getIfNotFoundCreateElseUpdate (result);
  }
  return results;
 }

 private void getIfNotFoundCreateElseUpdate (AtpLoadResult result)
 {
  AtpInfo oldInfo = this.get (result.getAtpInfo ().getId ());
  if (oldInfo == null)
  {
   create (result);
   return;
  }
  updateIfDifferent (result, oldInfo);
  return;
 }

 private void create (AtpLoadResult result)
 {
  AtpInfo info = result.getAtpInfo ();
  try
  {

	  
   AtpInfo createdInfo = getAtpService ().createAtp (
     info.getId (),
     info,
     contextInfo);
   result.setAtpInfo (createdInfo);
   result.setStatus (AtpLoadResult.Status.CREATED);
   return;
  }
  catch (DataValidationErrorException ex)
  {
   validate (result);
  }
//  catch (AlreadyExistsException ex)
//  {
//   AtpInfo oldInfo = this.get (result.getAtpInfo ().getId ());
//   if (oldInfo == null)
//   {
//    result.setStatus (AtpLoadResult.Status.EXCEPTION);
//    result.setException (new RuntimeException (
//      "could not get after getting already exists exception"));
//    return;
//   }
//   updateIfDifferent (result, oldInfo);
//  }
  catch (Exception ex)
  {
   result.setStatus (AtpLoadResult.Status.EXCEPTION);
   result.setException (ex);
  }
 }

 private AtpInfo get (String key)
 {
  try
  {
	  
   AtpInfo oldInfo = getAtpService ().getAtp (key, contextInfo);
   if (oldInfo == null)
   {
    return null;
   }
   return oldInfo;
  }
  catch (DoesNotExistException ex)
  {
   return null;
  }
  catch (Exception ex)
  {
   // TODO: remove this hack when the services gets fixed to throw the right exceptions
   return null;
  }
 }

 private void updateIfDifferent (AtpLoadResult result, AtpInfo oldInfo)
 {
  if (matches (oldInfo, result.getAtpInfo ()))
  {
   result.setStatus (AtpLoadResult.Status.NO_CHANGE);
   return;
  }
  copy (oldInfo, result.getAtpInfo ());
  result.setAtpInfo (oldInfo);
  update (result);
 }

 private void copy (AtpInfo oldInfo, AtpInfo newInfo)
 {
  oldInfo.setAttributes (newInfo.getAttributes ());
  oldInfo.setDescr (newInfo.getDescr ());
  oldInfo.setEndDate (newInfo.getEndDate ());
  oldInfo.setName (newInfo.getName ());
  oldInfo.setStartDate (newInfo.getStartDate ());
  oldInfo.setStateKey (newInfo.getStateKey ());
  oldInfo.setTypeKey (newInfo.getTypeKey ());
 }


 private void update (AtpLoadResult result)
 {
  AtpInfo info = result.getAtpInfo ();
  try
  {
   AtpInfo updatedInfo = getAtpService ().updateAtp (info.getId (), info, contextInfo);
   result.setAtpInfo (updatedInfo);
   result.setStatus (AtpLoadResult.Status.UPDATED);
  }
  catch (DataValidationErrorException ex)
  {
   validate (result);
  }
  catch (Exception ex)
  {
   result.setStatus (AtpLoadResult.Status.EXCEPTION);
   result.setException (ex);
  }
 }

 private void validate (AtpLoadResult result)
 {
  List<ValidationResultInfo> vris = null;
  try
  {
	  //TODO verify the second arg.
	  AtpInfo info = result.getAtpInfo ();
	  vris = atpService.validateAtp ("SYSTEM", info.getId(), result.getAtp (), contextInfo);
  }
  catch (Exception ex1)
  {
   throw new RuntimeException (
     "Got an exception trying to get validation errors", ex1);
  }
  DataValidationErrorException dvex = new DataValidationErrorException (
    "got validation errors", vris);
  result.setStatus (AtpLoadResult.Status.VALIDATION_ERROR);
  result.setDataValidationErrorException (dvex);
  return;
 }

 private boolean matches (AtpInfo oldInfo, AtpInfo newInfo)
 {
  if ( ! matches (oldInfo.getId (), newInfo.getId ()))
  {
   return false;
  }
  if ( ! matches (oldInfo.getName (), newInfo.getName ()))
  {
   return false;
  }
  if ( ! matches (oldInfo.getType (), newInfo.getType ()))
  {
   return false;
  }
  if ( ! matches (oldInfo.getState (), newInfo.getState ()))
  {
   return false;
  }
  if ( ! matches (oldInfo.getStartDate (), newInfo.getStartDate ()))
  {
   return false;
  }
  if ( ! matches (oldInfo.getEndDate (), newInfo.getEndDate ()))
  {
   return false;
  }
  if ( ! matches (oldInfo.getDescr (), newInfo.getDescr ()))
  {
   return false;
  }
  return true;


 }

 private boolean matches (String oldStr, String newStr)
 {
  if (oldStr == null && newStr == null)
  {
   return true;
  }
  if (oldStr == null)
  {
   return false;
  }
  if (newStr == null)
  {
   return false;
  }
  return oldStr.equals (newStr);
 }

 private boolean matches (Date oldDate, Date newDate)
 {
  if (oldDate == null && newDate == null)
  {
   return true;
  }
  if (oldDate == null)
  {
   return false;
  }
  if (newDate == null)
  {
   return false;
  }
  return oldDate.equals (newDate);
 }

 private boolean matches (RichTextInfo oldInfo, RichTextInfo newInfo)
 {
  if (oldInfo == null && newInfo == null)
  {
   return true;
  }
  if (oldInfo == null)
  {
   return false;
  }
  if (newInfo == null)
  {
   return false;
  }
  if ( ! matches (oldInfo.getPlain (), newInfo.getPlain ()))
  {
   return false;
  }
  if ( ! matches (oldInfo.getFormatted (), newInfo.getFormatted ()))
  {
   return false;
  }
  return true;
 }

 public static AtpInputModelFactory getInstance (String excelFile)
 {
  Properties props = new Properties ();
  props.putAll (AtpInputModelFactory.getDefaultConfig ());
  props.put (AtpInputModelFactory.EXCEL_FILES_DEFAULT_DIRECTORY_KEY,
             "src/main/"
             + AtpInputModelFactory.RESOURCES_DIRECTORY);
  System.out.println ("Current Directory=" + System.getProperty ("user.dir"));
  AtpInputModelFactory factory = new AtpInputModelFactory ();
  factory.setConfig (props);
  return factory;
 }
}
