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
import org.kuali.student.core.exceptions.AlreadyExistsException;
import org.kuali.student.core.exceptions.DataValidationErrorException;
import org.kuali.student.core.organization.dto.OrgPositionRestrictionInfo;
import org.kuali.student.core.organization.service.OrganizationService;
import org.kuali.student.core.validation.dto.ValidationResultInfo;

/**
 *
 * @author nwright
 */
public class PositionRestrictionLoader
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

 public PositionRestrictionLoader ()
 {
 }
 private List<OrgPositionRestriction> inputDataSource;

 public List<OrgPositionRestriction> getInputDataSource ()
 {
  return inputDataSource;
 }

 public void setInputDataSource (List<OrgPositionRestriction> inputDataSource)
 {
  this.inputDataSource = inputDataSource;
 }

 public List<PositionRestrictionLoadResult> load ()
 {
  List<PositionRestrictionLoadResult> results = new ArrayList (500);
  int row = 0;
  for (OrgPositionRestriction posRestriction : inputDataSource)
  {
   PositionRestrictionLoadResult result = new PositionRestrictionLoadResult ();
   results.add (result);
   row ++;
   OrgPositionRestrictionInfo posRestrictionInfo = new PosRestrictionToPosRestrictionInfoConverter (posRestriction).convert ();
   result.setRow (row);
   result.setPosRestriction(posRestriction);
   result.setPosRestrictionInfo(posRestrictionInfo);
   
   try{
   if(!hasPositionRestriction(posRestriction)){
	   try
	   {
		   OrgPositionRestrictionInfo createdInfo = getOrganizationService ().addPositionRestrictionToOrg(
				   posRestrictionInfo.getOrgId(), 
				   posRestrictionInfo.getOrgPersonRelationTypeKey(), 
				   posRestrictionInfo);
		   
		   result.setPosRestrictionInfo(createdInfo);
		   result.setStatus (PositionRestrictionLoadResult.Status.CREATED);
	   }
	   catch (AlreadyExistsException ex)
	   {
	    //TODO update if already exists?
	    result.setStatus (PositionRestrictionLoadResult.Status.NOT_PROCESSED_ALREADY_EXISTS);
	    result.setException (ex);
	   }
	   catch (DataValidationErrorException ex)
	   {
	    List<ValidationResultInfo> vris = null;
	    try
	    {
	     vris = organizationService.validateOrgPositionRestriction("SYSTEM", posRestrictionInfo);
	    }
	    catch (Exception ex1)
	    {
	     throw new RuntimeException (
	       "Got an exception trying to get validation errors", ex1);
	    }
	    DataValidationErrorException dvex = new DataValidationErrorException (
	      "got validation errors", vris, ex);
	    result.setStatus (PositionRestrictionLoadResult.Status.VALIDATION_ERROR);
	    result.setDataValidationErrorException (dvex);
	   }
	   catch (Exception ex)
	   {
	    result.setStatus (PositionRestrictionLoadResult.Status.EXCEPTION);
	    result.setException (ex);
	   }
   }
   else{
	   result.setStatus (PositionRestrictionLoadResult.Status.NOT_PROCESSED_ALREADY_EXISTS);
   }
  }
  catch (Exception ex)
  {
	  System.out.println("error in checking relation: " + ex.getMessage());
  }
  }
  return results;
 }

 private boolean hasPositionRestriction(OrgPositionRestriction posRestriction){
	 try {
		List<OrgPositionRestrictionInfo> pris = getOrganizationService ().getPositionRestrictionsByOrg(posRestriction.getOrgId());
		if(pris != null && !pris.isEmpty()){
			String personRelationTypeKey = posRestriction.getOrgPersonRelationTypeKey();
			for (OrgPositionRestrictionInfo pri : pris){
				if(personRelationTypeKey.equals(pri.getOrgPersonRelationTypeKey()))
					return true;
			}
		}
	} catch (Exception e) {
		return false;
	} 
	
	 return false;
 }
 
 public static PositionRestrictionInputModelFactory getInstance (String excelFile)
 {
  Properties props = new Properties ();
  props.putAll (PositionRestrictionInputModelFactory.getDefaultConfig ());
  props.put (PositionRestrictionInputModelFactory.EXCEL_FILES_DEFAULT_DIRECTORY_KEY,
             "src/main/"
             + PositionRestrictionInputModelFactory.RESOURCES_DIRECTORY);
  System.out.println ("Current Directory=" + System.getProperty ("user.dir"));
  PositionRestrictionInputModelFactory factory = new PositionRestrictionInputModelFactory ();
  factory.setConfig (props);
  return factory;
 }
}
