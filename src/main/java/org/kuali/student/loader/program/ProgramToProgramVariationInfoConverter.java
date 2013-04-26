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

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.kuali.student.loader.util.AttributeInfoHelper;
import org.kuali.student.loader.util.GetAtpHelper;
import org.kuali.student.loader.util.GetOrgHelper;
import org.kuali.student.loader.util.RichTextInfoHelper;
import org.kuali.student.loader.util.TimeAmountInfoHelper;
import org.kuali.student.r2.core.atp.dto.AtpInfo;
import org.kuali.student.r2.core.atp.service.AtpService;
import org.kuali.student.r2.core.organization.dto.OrgInfo;
import org.kuali.student.r2.core.organization.service.OrganizationService;
import org.kuali.student.r2.lum.program.dto.ProgramVariationInfo;

/**
 *
 * @author nwright
 */
public class ProgramToProgramVariationInfoConverter
{

 private ProgramLoadResult result;
 private Program prog;
 private Map<String, Object> helperService;

 public ProgramToProgramVariationInfoConverter (ProgramLoadResult result, Map<String, Object> thisServiceMap)
 {
  this.result = result;
  this.prog = result.getProgram ();
  this.helperService = thisServiceMap;
 }
 public static final String ADMINISTRATION_ADMIN_ORG_TYPE =
                            "kuali.adminOrg.type.Administration";

 public ProgramVariationInfo convert ()
 {
  ProgramVariationInfo info = new ProgramVariationInfo ();
  info.setCode (prog.getCode ());
  info.setUniversityClassification (prog.getUniversityClassification ());
  info.setType (prog.getType ());
  info.setAttributes (
    new AttributeInfoHelper ().setValue (
    "isVariationRequired", prog.getIsVariationRequired (), info.getAttributes ()));
//  info.setOrgCoreProgram (prog.getCorePrograms ());
  // Convert this to an Id by looking it up in the rest file
//  info.setCredentialProgramId (prog.getCredentialProgram ());
  info.setId (prog.getId ());
  info.setShortTitle (prog.getShortTitle ());
  info.setLongTitle (prog.getLongTitle ());
  info.setTranscriptTitle (prog.getTranscriptTitle ());
//info.setAccreditingAgencies          (prog.getAccreditingAgencies ());
  if (prog.getCampusLocations () != null)
  {
   List<String> campuses =
                Arrays.asList (prog.getCampusLocations ().split (" "));
   info.setCampusLocations (campuses);
  }
  if (prog.getCatalogPublicationTargets () != null)
  {
   info.setCatalogPublicationTargets (Arrays.asList (prog.getCatalogPublicationTargets ().split (
     " ")));
  }
  info.setCip2000Code (new CIPCodeHelper ().formatCIP (prog.getCip2000Code ()));
  info.setCip2010Code (new CIPCodeHelper ().formatCIP (prog.getCip2010Code ()));
  info.setHegisCode (prog.getHegisCode ());
  info.setDescr (new RichTextInfoHelper ().getFromPlain (prog.getDescr ()));
  info.setCatalogDescr (new RichTextInfoHelper ().getFromPlain (
    prog.getCatalogDescr ()));
  info.setDiplomaTitle (prog.getDiplomaTitle ());
  
  //set adminOrgs
  if ( ! setAdminOrgs(info))
  {
	// if failed stop processing
	  return info;
  }
  
//  info.setInstitution (prog.getInstitution ());
  info.setStdDuration (new TimeAmountInfoHelper ().getWith1InTimeQuantity (
    prog.getStdDuration ()));
  info.setAttributes (
    new AttributeInfoHelper ().setValue ("durationNotes",
                                         prog.getDurationNotes (),
                                         info.getAttributes ()));
  AtpService atpService = (AtpService)helperService.get("atp");
  if (prog.getStartTerm () != null)
  {
   info.setStartTerm (prog.getStartTerm ());
   AtpInfo atp = new GetAtpHelper (atpService).getAtp (info.getStartTerm ());
   if (atp == null)
   {
    result.setException (new RuntimeException ("startTerm was not found: "
                                               + prog.getStartTerm ()));
    result.setStatus (ProgramLoadResult.Status.VALIDATION_ERROR);
    return info;
   }
   info.setEffectiveDate (atp.getStartDate ());
  }
  if (prog.getEndTerm () != null)
  {
   info.setEndTerm (prog.getEndTerm ());
   AtpInfo atp = new GetAtpHelper (atpService).getAtp (info.getStartTerm ());
   if (atp == null)
   {
    result.setException (new RuntimeException ("endTerm was not found: "
                                               + prog.getEndTerm ()));
    result.setStatus (ProgramLoadResult.Status.VALIDATION_ERROR);
    return info;
   }
  }
  info.setState (prog.getState ());
  info.setAttributes (
    new AttributeInfoHelper ().setValue ("endInstAdmitTerm",
                                         prog.getEndInstAdmitTerm (),
                                         info.getAttributes ()));
  info.setEndProgramEntryTerm (prog.getEndProgramEntryTerm ());
  info.setIntensity (prog.getIntensity ());
  info.setAttributes (
    new AttributeInfoHelper ().setValue ("lastReviewDate",
                                         prog.getLastReviewDate (),
                                         info.getAttributes ()));
//  info.setNextReviewPeriod (prog.getNextReviewPeriod ());
//  info.setPublishedInstructors (toCluInstructors (
//    prog.getPublishedInstructors ()));
  info.setReferenceURL (prog.getReferenceURL ());
  if (prog.getResultOptions () != null)
  {
   info.setResultOptions (Arrays.asList (prog.getResultOptions ().split ("\n")));
  }
  info.setSelectiveEnrollmentCode (prog.getSelectiveEnrollmentCode ());
//  info.setVersionInfo (prog.getVersionInfo ());
//  info.setProgramLevel (prog.getProgramLevel ());
//  info.setProgramRequirements (prog.getProgramRequirements ());
  // TODO: load learning objectives
//  info.setLearningObjectives (prog.getLearningObjectives ());

  return info;
 }
 private boolean setAdminOrgs(ProgramVariationInfo info) {
	 if(helperService != null && !helperService.isEmpty()){
		 OrganizationService orgService = (OrganizationService)helperService.get("org");
		 if (orgService != null){
			 if(prog.getUnitsContentOwnerId () != null && !prog.getUnitsContentOwnerId ().isEmpty()){
				 if( getAdminOrg(orgService, prog.getUnitsContentOwnerId ()) != null )
					 info.setUnitsContentOwner (Arrays.asList (prog.getUnitsContentOwnerId ())); 
				 else
					 return false;
			 }

			 if(prog.getDivisionsContentOwnerId () != null && !prog.getDivisionsContentOwnerId ().isEmpty()){
				 if( getAdminOrg(orgService, prog.getDivisionsContentOwnerId ()) != null )
					 info.setDivisionsContentOwner (Arrays.asList (prog.getDivisionsContentOwnerId ()));
				 else
					 return false;
			 }
			 
			 if(prog.getUnitsDeploymentId () != null && !prog.getUnitsDeploymentId ().isEmpty()){
				 if( getAdminOrg(orgService, prog.getUnitsDeploymentId ()) != null )
					 info.setUnitsDeployment (Arrays.asList (prog.getUnitsDeploymentId ()));
				 else
					 return false;
			 }

			 if(prog.getDivisionsDeploymentId () != null && !prog.getDivisionsDeploymentId ().isEmpty()){
				 if( getAdminOrg(orgService, prog.getDivisionsDeploymentId ()) != null )
					 info.setDivisionsDeployment (Arrays.asList (prog.getDivisionsDeploymentId ()));
				 else
					 return false;
			 }
			 
			 if(prog.getUnitsFinancialControlId () != null && !prog.getUnitsFinancialControlId ().isEmpty()){
				 if( getAdminOrg(orgService, prog.getUnitsFinancialControlId ()) != null )
					 info.setUnitsFinancialControl (Arrays.asList (prog.getUnitsFinancialControlId ()));
				 else
					 return false;
			 }
			  
			if(prog.getDivisionsFinancialControlId () != null && !prog.getDivisionsFinancialControlId ().isEmpty()){
				 if( getAdminOrg(orgService, prog.getDivisionsFinancialControlId ()) != null )
					 info.setDivisionsFinancialControl (Arrays.asList (prog.getDivisionsFinancialControlId ()));
				 else
					 return false;
			 }
			
			if(prog.getUnitsFinancialResourcesId () != null && !prog.getUnitsFinancialResourcesId ().isEmpty()){
				 if( getAdminOrg(orgService, prog.getUnitsFinancialResourcesId ()) != null )
					 info.setUnitsFinancialResources (Arrays.asList (prog.getUnitsFinancialResourcesId ()));
				 else
					 return false;
			 }
			  
			if(prog.getDivisionsFinancialResourcesId () != null && !prog.getDivisionsFinancialResourcesId ().isEmpty()){
				 if( getAdminOrg(orgService, prog.getDivisionsFinancialResourcesId ()) != null )
					 info.setDivisionsFinancialResources (Arrays.asList (prog.getDivisionsFinancialResourcesId ()));
				 else
					 return false;
			 }

			if(prog.getUnitsStudentOversightId () != null && !prog.getUnitsStudentOversightId ().isEmpty()){
				 if( getAdminOrg(orgService, prog.getUnitsStudentOversightId ()) != null )
					 info.setUnitsStudentOversight (Arrays.asList (prog.getUnitsStudentOversightId ()));
				 else
					 return false;
			 }
			
			if(prog.getDivisionsStudentOversightId () != null && !prog.getDivisionsStudentOversightId ().isEmpty()){
				 if( getAdminOrg(orgService, prog.getDivisionsStudentOversightId ()) != null )
					 info.setDivisionsStudentOversight (Arrays.asList (prog.getDivisionsStudentOversightId ()));	
				 else
					 return false;
			 }		 
		 }
	 }
	 
	 return true;
 }
 
 private OrgInfo getAdminOrg(OrganizationService orgService, String orgId){

	 OrgInfo adminOrg = new GetOrgHelper (orgService).getOrg(orgId);
	 
     if (adminOrg == null) {
	      result.setException (new RuntimeException ("AdministeringOrg was not found: " + orgId));
	      result.setStatus (ProgramLoadResult.Status.VALIDATION_ERROR);
     }	
     
     return adminOrg;
 }
}
