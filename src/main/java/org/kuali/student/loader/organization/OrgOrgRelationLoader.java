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
import org.kuali.student.r2.core.organization.dto.OrgOrgRelationInfo;
import org.kuali.student.r2.core.organization.service.OrganizationService;

/**
 *
 * @author nwright
 */
public class OrgOrgRelationLoader
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

 public OrgOrgRelationLoader ()
 {
 }
 private List<OrgOrgRelation> inputDataSource;

 public List<OrgOrgRelation> getInputDataSource ()
 {
  return inputDataSource;
 }

 public void setInputDataSource (List<OrgOrgRelation> inputDataSource)
 {
  this.inputDataSource = inputDataSource;
 }

 public List<OrgOrgRelationLoadResult> load ()
 {
  List<OrgOrgRelationLoadResult> results = new ArrayList (500);
  int row = 0;
  for (OrgOrgRelation org : inputDataSource)
  {
   OrgOrgRelationLoadResult result = new OrgOrgRelationLoadResult ();
   results.add (result);
   row ++;
   OrgOrgRelationInfo relationInfo = new OrgOrgRelToOrgOrgRelInfoConverter (org).convert ();
   result.setRow (row);
   result.setOrgOrgRelation(org);
   result.setRelationInfo(relationInfo);
   ContextInfoHelper ctxInfoHelper = new ContextInfoHelper();
   
   try{
   if(!getOrganizationService ().hasOrgOrgRelation(relationInfo.getOrgId(), relationInfo.getRelatedOrgId(),
		   relationInfo.getTypeKey(), ctxInfoHelper.getDefaultContextInfo())){
	   try
	   {
		   OrgOrgRelationInfo createdInfo = getOrganizationService ().createOrgOrgRelation(
				   	relationInfo.getOrgId(), 
				   	relationInfo.getRelatedOrgId(), 
				   	relationInfo.getTypeKey(), 
				   	relationInfo,
				   	ctxInfoHelper.getDefaultContextInfo());
		   
		   result.setRelationInfo(createdInfo);
		   result.setStatus (OrgOrgRelationLoadResult.Status.CREATED);
	   }
//	   catch (AlreadyExistsException ex)
//	   {
//	    //TODO update if already exists?
//	    result.setStatus (OrgOrgRelationLoadResult.Status.NOT_PROCESSED_ALREADY_EXISTS);
//	    result.setException (ex);
//	   }
	   catch (DataValidationErrorException ex)
	   {
	    List<ValidationResultInfo> vris = null;
	    try
	    {
	    //TODO verify	
	     vris = organizationService.validateOrgOrgRelation("SYSTEM", null, null, null, relationInfo, ctxInfoHelper.getDefaultContextInfo());
	    }
	    catch (Exception ex1)
	    {
	     throw new RuntimeException (
	       "Got an exception trying to get validation errors", ex1);
	    }
	    DataValidationErrorException dvex = new DataValidationErrorException (
	      "got validation errors", vris, ex);
	    result.setStatus (OrgOrgRelationLoadResult.Status.VALIDATION_ERROR);
	    result.setDataValidationErrorException (dvex);
	   }
	   catch (Exception ex)
	   {
	    result.setStatus (OrgOrgRelationLoadResult.Status.EXCEPTION);
	    result.setException (ex);
	   }
   }
   else{
	   result.setStatus (OrgOrgRelationLoadResult.Status.NOT_PROCESSED_ALREADY_EXISTS);
   }
  }
  catch (Exception ex)
  {
	  System.out.println("error in checking relation: " + ex.getMessage());
  }
  }
  return results;
 }

 public static OrgOrgRelationInputModelFactory getInstance (String excelFile)
 {
  Properties props = new Properties ();
  props.putAll (OrganizationInputModelFactory.getDefaultConfig ());
  props.put (OrganizationInputModelFactory.EXCEL_FILES_DEFAULT_DIRECTORY_KEY,
             "src/main/"
             + OrganizationInputModelFactory.RESOURCES_DIRECTORY);
  System.out.println ("Current Directory=" + System.getProperty ("user.dir"));
  OrgOrgRelationInputModelFactory factory = new OrgOrgRelationInputModelFactory ();
  factory.setConfig (props);
  return factory;
 }
}
