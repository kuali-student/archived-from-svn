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
package org.kuali.student.loader.organization;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import org.kuali.student.loader.util.ContextInfoHelper;
import org.kuali.student.r2.common.dto.ValidationResultInfo;
import org.kuali.student.r2.common.exceptions.AlreadyExistsException;
import org.kuali.student.r2.common.exceptions.DataValidationErrorException;
import org.kuali.student.r2.core.organization.dto.OrgInfo;
import org.kuali.student.r2.core.organization.service.OrganizationService;

/**
 *
 * @author nwright
 */
public class OrganizationLoader
{

 private OrganizationService organizationService;

 public OrganizationService getOrganizationService ()
 {
  return organizationService;
 }

 public void setOrganizationService (OrganizationService organizationService)
 {
  this.organizationService = organizationService;
 }

 public OrganizationLoader ()
 {
 }
 private List<Organization> inputDataSource;

 public List<Organization> getInputDataSource ()
 {
  return inputDataSource;
 }

 public void setInputDataSource (List<Organization> inputDataSource)
 {
  this.inputDataSource = inputDataSource;
 }

 public List<OrganizationLoadResult> load ()
 {
	 ContextInfoHelper ctxInfoHelper = new ContextInfoHelper();
  List<OrganizationLoadResult> results = new ArrayList (500);
  int row = 0;
  for (Organization org : inputDataSource)
  {
   OrganizationLoadResult result = new OrganizationLoadResult ();
   results.add (result);
   row ++;
   OrgInfo info = new OrganizationToOrgInfoConverter (org).convert ();
   result.setRow (row);
   result.setOrganization (org);
   result.setOrgInfo (info);
   try
   {
	   
    OrgInfo createdInfo = getOrganizationService ().createOrg (
      info.getTypeKey (), info, ctxInfoHelper.getDefaultContextInfo());
    result.setOrgInfo (createdInfo);
    result.setStatus (OrganizationLoadResult.Status.CREATED);
   }
//   catch (AlreadyExistsException ex)
//   {
//    //TODO update if already exists?
//    result.setStatus (OrganizationLoadResult.Status.NOT_PROCESSED_ALREADY_EXISTS);
//    result.setException (ex);
//   }
   catch (DataValidationErrorException ex)
   {
    List<ValidationResultInfo> vris = null;
    try
    {
    	//TODO verify first and second arguments
     vris = organizationService.validateOrg ("SYSTEM", info.getTypeKey (), info, ctxInfoHelper.getDefaultContextInfo());
    }
    catch (Exception ex1)
    {
     throw new RuntimeException (
       "Got an exception trying to get validation errors", ex1);
    }
    DataValidationErrorException dvex = new DataValidationErrorException (
      "got validation errors", vris, ex);
    result.setStatus (OrganizationLoadResult.Status.VALIDATION_ERROR);
    result.setDataValidationErrorException (dvex);
   }
   catch (Exception ex)
   {
    result.setStatus (OrganizationLoadResult.Status.EXCEPTION);
    result.setException (ex);
   }
  }
  return results;
 }

 public static OrganizationInputModelFactory getInstance (String excelFile)
 {
  Properties props = new Properties ();
  props.putAll (OrganizationInputModelFactory.getDefaultConfig ());
  props.put (OrganizationInputModelFactory.EXCEL_FILES_DEFAULT_DIRECTORY_KEY,
             "src/main/"
             + OrganizationInputModelFactory.RESOURCES_DIRECTORY);
  System.out.println ("Current Directory=" + System.getProperty ("user.dir"));
  OrganizationInputModelFactory factory = new OrganizationInputModelFactory ();
  factory.setConfig (props);
  return factory;
 }
}
