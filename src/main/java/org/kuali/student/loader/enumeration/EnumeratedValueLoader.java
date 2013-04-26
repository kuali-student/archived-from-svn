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

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import org.kuali.student.loader.util.ContextInfoHelper;
import org.kuali.student.r2.common.exceptions.AlreadyExistsException;
import org.kuali.student.r2.core.enumerationmanagement.dto.EnumeratedValueInfo;
import org.kuali.student.r2.core.enumerationmanagement.service.EnumerationManagementService;

/**
 *
 * @author nwright
 */
public class EnumeratedValueLoader
{

 private EnumerationManagementService enumerationManagementService;

 public EnumerationManagementService getEnumerationManagementService ()
 {
  return enumerationManagementService;
 }

 public void setEnumerationManagementService (EnumerationManagementService enumerationManagementService)
 {
  this.enumerationManagementService = enumerationManagementService;
 }

 public EnumeratedValueLoader ()
 {
 }
 private List<EnumeratedValue> inputDataSource;

 public List<EnumeratedValue> getInputDataSource ()
 {
  return inputDataSource;
 }

 public void setInputDataSource (List<EnumeratedValue> inputDataSource)
 {
  this.inputDataSource = inputDataSource;
 }

 public List<EnumeratedValueLoadResult> update ()
 {
  List<EnumeratedValueLoadResult> results = new ArrayList (500);
  int row = 0;
  for (EnumeratedValue ev : inputDataSource)
  {
   EnumeratedValueLoadResult result = new EnumeratedValueLoadResult ();
   results.add (result);
   row ++;
   EnumeratedValueInfo info = new EnumeratedValueToEnumeratedValueInfoConverter (ev).convert ();
   result.setRow (row);
   result.setEnumeratedValue (ev);
   result.setEnumeratedValueInfo (info);
   try
   {
	   ContextInfoHelper ctxInfoHelper = new ContextInfoHelper();
	   //TODO: verify
	   String code = null;
    EnumeratedValueInfo createdInfo = enumerationManagementService.addEnumeratedValue (info.getEnumerationKey (), info.getCode(), info, ctxInfoHelper.getDefaultContextInfo());
    result.setEnumeratedValueInfo (createdInfo);
    result.setStatus (EnumeratedValueLoadResult.Status.CREATED);
   }
   catch (AlreadyExistsException ex)
   {
    result.setStatus (EnumeratedValueLoadResult.Status.ALREADY_EXISTS);
    result.setException (ex);
   }
   // THERE IS NO DATA VALIDATION EXCEPTION THROWN!!!!!!!!
   // AND THERE IS NO VALIDATE METHOD!!!!!!!!
//   catch (DataValidationErrorException ex)
//   {
//    List<ValidationResultInfo> vris = null;
//    try
//    {
//     vris = enumerationManagementService.validateEnumeratedValue ("SYSTEM", info);
//    }
//    catch (Exception ex1)
//    {
//     throw new RuntimeException (
//       "Got an exception trying to get validation errors", ex1);
//    }
//    DataValidationErrorException dvex = new DataValidationErrorException (
//      "got validation errors", vris, ex);
//    result.setStatus (EnumeratedValueLoadResult.Status.VALIDATION_ERROR);
//    result.setDataValidationErrorException (dvex);
//   }
   catch (Exception ex)
   {
    result.setStatus (EnumeratedValueLoadResult.Status.EXCEPTION);
    result.setException (ex);
   }
  }
  return results;
 }

 public static EnumeratedValueInputModelFactory getInstance (String excelFile)
 {
  Properties props = new Properties ();
  props.putAll (EnumeratedValueInputModelFactory.getDefaultConfig ());
  props.put (EnumeratedValueInputModelFactory.EXCEL_FILES_DEFAULT_DIRECTORY_KEY, "src/main/"
   + EnumeratedValueInputModelFactory.RESOURCES_DIRECTORY);
  System.out.println ("Current Directory=" + System.getProperty ("user.dir"));
  EnumeratedValueInputModelFactory factory = new EnumeratedValueInputModelFactory ();
  factory.setConfig (props);
  return factory;
 }

 


}
