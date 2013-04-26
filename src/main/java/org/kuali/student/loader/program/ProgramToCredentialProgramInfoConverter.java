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
import java.util.Map;

import org.kuali.student.loader.util.GetOrgHelper;
import org.kuali.student.loader.util.RichTextInfoHelper;
import org.kuali.student.r2.core.organization.dto.OrgInfo;
import org.kuali.student.r2.core.organization.service.OrganizationService;
import org.kuali.student.r2.lum.clu.dto.AdminOrgInfo;
import org.kuali.student.r2.lum.program.dto.CredentialProgramInfo;

/**
 *
 * @author nwright
 */
public class ProgramToCredentialProgramInfoConverter
{

 private ProgramLoadResult result;
 private Program prog;
 private Map<String, Object> helperService;

 public ProgramToCredentialProgramInfoConverter (ProgramLoadResult result, Map<String, Object> thisServiceMap)
 {
  this.result = result;
  this.prog = result.getProgram ();
  this.helperService = thisServiceMap;
 }
 public static final String INSTITUTION_ADMIN_ORG_TYPE =
                            "kuali.adminOrg.type.Institution";

 public CredentialProgramInfo convert ()
 {
  CredentialProgramInfo info = new CredentialProgramInfo ();
  info.setCode (prog.getCode ());
  info.setUniversityClassification (prog.getUniversityClassification ());
  info.setType (prog.getType ());
  info.setId (prog.getId ());
  info.setShortTitle (prog.getShortTitle ());
  info.setLongTitle (prog.getLongTitle ());
  info.setTranscriptTitle (prog.getTranscriptTitle ());
  info.setCip2000Code (new CIPCodeHelper ().formatCIP (prog.getCip2000Code ()));
  info.setCip2010Code (new CIPCodeHelper ().formatCIP (prog.getCip2010Code ()));
  info.setHegisCode (prog.getHegisCode ());
  info.setDescr (new RichTextInfoHelper ().getFromPlain (prog.getDescr ()));
  info.setDiplomaTitle (prog.getDiplomaTitle ());
  
  //set adminOrgs
  if ( ! setAdminOrgs(info))
  {
	// if failed stop processing
	  return info;
  }
 
  info.setStartTerm (prog.getStartTerm ());
  info.setEndTerm (prog.getEndTerm ());
  info.setState (prog.getState ());
  info.setEndProgramEntryTerm (prog.getEndProgramEntryTerm ());
  if (prog.getResultOptions () != null)
  {
   info.setResultOptions (Arrays.asList (prog.getResultOptions ().split ("\n")));
  }
  info.setSelectiveEnrollmentCode (prog.getSelectiveEnrollmentCode ());
//  info.setVersionInfo (prog.getVersionInfo ());
  info.setProgramLevel (prog.getProgramLevel ());
//  info.setProgramRequirements (prog.getProgramRequirements ());
  info.setLearningObjectives (new SingleUseLoDisplayInfoHelper ().parse (
		    prog.getLearningObjectives (), null));

  return info;
 }
 private boolean setAdminOrgs(CredentialProgramInfo info) {
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

   	if(prog.getInstitutionId () != null && !prog.getInstitutionId ().isEmpty()){
				 if( getAdminOrg(orgService, prog.getInstitutionId ()) != null )
     {
      AdminOrgInfo aoi = new AdminOrgInfo ();
      aoi.setOrgId (prog.getInstitutionId ());
      aoi.setType (INSTITUTION_ADMIN_ORG_TYPE);
					 info.setInstitution (aoi);
     }
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
