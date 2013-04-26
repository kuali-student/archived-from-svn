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

import java.util.Date;

/**
 *
 * @author nwright
 */
public class Program
{
private String code;
private String universityClassification;
private String type;
private String variationOf;
private Boolean isVariationRequired;
private String corePrograms;
private String credentialProgram;
private String credentialProgramId;
private String id;
private String shortTitle;
private String longTitle;
private String transcriptTitle;
private String accreditingAgencies;
private String campusLocations;
private String catalogPublicationTargets;
private String cip2000Code;
private String cip2010Code;
private String hegisCode;
private String descr;
private String catalogDescr;
private String diplomaTitle;
private String unitsContentOwner;
private String divisionsContentOwner;
private String unitsDeployment;
private String divisionsDeployment;
private String unitsFinancialControl;
private String divisionsFinancialControl;
private String unitsFinancialResources;
private String divisionsFinancialResources;
private String unitsStudentOversight;
private String divisionsStudentOversight;
private String institution;
private String unitsContentOwnerId;
private String divisionsContentOwnerId;
private String unitsDeploymentId;
private String divisionsDeploymentId;
private String unitsFinancialControlId;
private String divisionsFinancialControlId;
private String unitsFinancialResourcesId;
private String divisionsFinancialResourcesId;
private String unitsStudentOversightId;
private String divisionsStudentOversightId;
private String institutionId;
private String stdDuration;
private String durationNotes;
private String startTerm;
private String endTerm;
private String state;
private String endInstAdmitTerm;
private String endProgramEntryTerm;
private String intensity;
private Date lastReviewDate;
private String nextReviewPeriod;
private String publishedInstructors;
private String coreFaculties;
private String referenceURL;
private String resultOptions;
private String selectiveEnrollmentCode;
private String versionInfo;
private String programLevel;
private String programRequirements;
private String learningObjectives;


 public String getId ()
 {
  return id;
 }

 public void setId (String id)
 {
  this.id = id;
 }

 
 public String getCode ()
 {
  return code;
 }

 public void setCode (String code)
 {
  this.code = code;
 }

 public String getVariationOf ()
 {
  return variationOf;
 }

 public void setVariationOf (String variationOf)
 {
  this.variationOf = variationOf;
 }

 
 public String getLongTitle ()
 {
  return longTitle;
 }

 public void setLongTitle (String longTitle)
 {
  this.longTitle = longTitle;
 }

 public String getShortTitle ()
 {
  return shortTitle;
 }

 public void setShortTitle (String shortTitle)
 {
  this.shortTitle = shortTitle;
 }

 public String getTranscriptTitle ()
 {
  return transcriptTitle;
 }

 public void setTranscriptTitle (String transcriptTitle)
 {
  this.transcriptTitle = transcriptTitle;
 }

 public String getType ()
 {
  return type;
 }

 public void setType (String type)
 {
  this.type = type;
 }

 public String getUniversityClassification ()
 {
  return universityClassification;
 }

 public void setUniversityClassification (String universityClassification)
 {
  this.universityClassification = universityClassification;
 }

 public String getDescr ()
 {
  return descr;
 }

 public void setDescr (String descr)
 {
  this.descr = descr;
 }

 public String getAccreditingAgencies ()
 {
  return accreditingAgencies;
 }

 public void setAccreditingAgencies (String accreditingAgencies)
 {
  this.accreditingAgencies = accreditingAgencies;
 }

 public String getCampusLocations ()
 {
  return campusLocations;
 }

 public void setCampusLocations (String campusLocations)
 {
  this.campusLocations = campusLocations;
 }

 public String getCatalogDescr ()
 {
  return catalogDescr;
 }

 public void setCatalogDescr (String catalogDescr)
 {
  this.catalogDescr = catalogDescr;
 }

 public String getCatalogPublicationTargets ()
 {
  return catalogPublicationTargets;
 }

 public void setCatalogPublicationTargets (String catalogPublicationTargets)
 {
  this.catalogPublicationTargets = catalogPublicationTargets;
 }

 public String getCip2000Code ()
 {
  return cip2000Code;
 }

 public void setCip2000Code (String cip2000Code)
 {
  this.cip2000Code = cip2000Code;
 }

 public String getCip2010Code ()
 {
  return cip2010Code;
 }

 public void setCip2010Code (String cip2010Code)
 {
  this.cip2010Code = cip2010Code;
 }

 public String getCorePrograms ()
 {
  return corePrograms;
 }

 public void setCorePrograms (String corePrograms)
 {
  this.corePrograms = corePrograms;
 }

 public String getCredentialProgram ()
 {
  return credentialProgram;
 }

 public void setCredentialProgram (String credentialProgram)
 {
  this.credentialProgram = credentialProgram;
 }

 public String getCredentialProgramId ()
 {
  return credentialProgramId;
 }

 public void setCredentialProgramId (String credentialProgramId)
 {
  this.credentialProgramId = credentialProgramId;
 }

 public String getDiplomaTitle ()
 {
  return diplomaTitle;
 }

 public void setDiplomaTitle (String diplomaTitle)
 {
  this.diplomaTitle = diplomaTitle;
 }

 public String getDivisionsContentOwner ()
 {
  return divisionsContentOwner;
 }

 public void setDivisionsContentOwner (String divisionsContentOwner)
 {
  this.divisionsContentOwner = divisionsContentOwner;
 }

 public String getDivisionsDeployment ()
 {
  return divisionsDeployment;
 }

 public void setDivisionsDeployment (String divisionsDeployment)
 {
  this.divisionsDeployment = divisionsDeployment;
 }

 public String getDivisionsFinancialControl ()
 {
  return divisionsFinancialControl;
 }

 public void setDivisionsFinancialControl (String divisionsFinancialControl)
 {
  this.divisionsFinancialControl = divisionsFinancialControl;
 }

 public String getDivisionsFinancialResources ()
 {
  return divisionsFinancialResources;
 }

 public void setDivisionsFinancialResources (String divisionsFinancialResources)
 {
  this.divisionsFinancialResources = divisionsFinancialResources;
 }

 public String getDivisionsStudentOversight ()
 {
  return divisionsStudentOversight;
 }

 public void setDivisionsStudentOversight (String divisionsStudentOversight)
 {
  this.divisionsStudentOversight = divisionsStudentOversight;
 }

 public String getDurationNotes ()
 {
  return durationNotes;
 }

 public void setDurationNotes (String durationNotes)
 {
  this.durationNotes = durationNotes;
 }

 public String getEndInstAdmitTerm ()
 {
  return endInstAdmitTerm;
 }

 public void setEndInstAdmitTerm (String endInstAdmitTerm)
 {
  this.endInstAdmitTerm = endInstAdmitTerm;
 }

 public String getEndProgramEntryTerm ()
 {
  return endProgramEntryTerm;
 }

 public void setEndProgramEntryTerm (String endProgramEntryTerm)
 {
  this.endProgramEntryTerm = endProgramEntryTerm;
 }

 public String getEndTerm ()
 {
  return endTerm;
 }

 public void setEndTerm (String endTerm)
 {
  this.endTerm = endTerm;
 }

 public String getHegisCode ()
 {
  return hegisCode;
 }

 public void setHegisCode (String hegisCode)
 {
  this.hegisCode = hegisCode;
 }

 public String getInstitution ()
 {
  return institution;
 }

 public void setInstitution (String institution)
 {
  this.institution = institution;
 }

 public String getIntensity ()
 {
  return intensity;
 }

 public void setIntensity (String intensity)
 {
  this.intensity = intensity;
 }

 public Boolean getIsVariationRequired ()
 {
  return isVariationRequired;
 }

 public void setIsVariationRequired (Boolean isVariationRequired)
 {
  this.isVariationRequired = isVariationRequired;
 }

 public Date getLastReviewDate ()
 {
  return lastReviewDate;
 }

 public void setLastReviewDate (Date lastReviewDate)
 {
  this.lastReviewDate = lastReviewDate;
 }

 public String getLearningObjectives ()
 {
  return learningObjectives;
 }

 public void setLearningObjectives (String learningObjectives)
 {
  this.learningObjectives = learningObjectives;
 }

 public String getNextReviewPeriod ()
 {
  return nextReviewPeriod;
 }

 public void setNextReviewPeriod (String nextReviewPeriod)
 {
  this.nextReviewPeriod = nextReviewPeriod;
 }

 public String getProgramLevel ()
 {
  return programLevel;
 }

 public void setProgramLevel (String programLevel)
 {
  this.programLevel = programLevel;
 }

 public String getProgramRequirements ()
 {
  return programRequirements;
 }

 public void setProgramRequirements (String programRequirements)
 {
  this.programRequirements = programRequirements;
 }

 public String getPublishedInstructors ()
 {
  return publishedInstructors;
 }

 public void setPublishedInstructors (String publishedInstructors)
 {
  this.publishedInstructors = publishedInstructors;
 }

 public String getCoreFaculties ()
 {
  return coreFaculties;
 }

 public void setCoreFaculties (String coreFaculties)
 {
  this.coreFaculties = coreFaculties;
 }

 public String getReferenceURL ()
 {
  return referenceURL;
 }

 public void setReferenceURL (String referenceURL)
 {
  this.referenceURL = referenceURL;
 }

 public String getResultOptions ()
 {
  return resultOptions;
 }

 public void setResultOptions (String resultOptions)
 {
  this.resultOptions = resultOptions;
 }

 public String getSelectiveEnrollmentCode ()
 {
  return selectiveEnrollmentCode;
 }

 public void setSelectiveEnrollmentCode (String selectiveEnrollmentCode)
 {
  this.selectiveEnrollmentCode = selectiveEnrollmentCode;
 }

 public String getStartTerm ()
 {
  return startTerm;
 }

 public void setStartTerm (String startTerm)
 {
  this.startTerm = startTerm;
 }

 public String getState ()
 {
  return state;
 }

 public void setState (String state)
 {
  this.state = state;
 }

 public String getStdDuration ()
 {
  return stdDuration;
 }

 public void setStdDuration (String stdDuration)
 {
  this.stdDuration = stdDuration;
 }

 public String getUnitsContentOwner ()
 {
  return unitsContentOwner;
 }

 public void setUnitsContentOwner (String unitsContentOwner)
 {
  this.unitsContentOwner = unitsContentOwner;
 }

 public String getUnitsDeployment ()
 {
  return unitsDeployment;
 }

 public void setUnitsDeployment (String unitsDeployment)
 {
  this.unitsDeployment = unitsDeployment;
 }

 public String getUnitsFinancialControl ()
 {
  return unitsFinancialControl;
 }

 public void setUnitsFinancialControl (String unitsFinancialControl)
 {
  this.unitsFinancialControl = unitsFinancialControl;
 }

 public String getUnitsFinancialResources ()
 {
  return unitsFinancialResources;
 }

 public void setUnitsFinancialResources (String unitsFinancialResources)
 {
  this.unitsFinancialResources = unitsFinancialResources;
 }

 public String getUnitsStudentOversight ()
 {
  return unitsStudentOversight;
 }

 public void setUnitsStudentOversight (String unitsStudentOversight)
 {
  this.unitsStudentOversight = unitsStudentOversight;
 }

 public String getDivisionsContentOwnerId ()
 {
  return divisionsContentOwnerId;
 }

 public void setDivisionsContentOwnerId (String divisionsContentOwnerId)
 {
  this.divisionsContentOwnerId = divisionsContentOwnerId;
 }

 public String getDivisionsDeploymentId ()
 {
  return divisionsDeploymentId;
 }

 public void setDivisionsDeploymentId (String divisionsDeploymentId)
 {
  this.divisionsDeploymentId = divisionsDeploymentId;
 }

 public String getDivisionsFinancialControlId ()
 {
  return divisionsFinancialControlId;
 }

 public void setDivisionsFinancialControlId (String divisionsFinancialControlId)
 {
  this.divisionsFinancialControlId = divisionsFinancialControlId;
 }

 public String getDivisionsFinancialResourcesId ()
 {
  return divisionsFinancialResourcesId;
 }

 public void setDivisionsFinancialResourcesId (String divisionsFinancialResourcesId)
 {
  this.divisionsFinancialResourcesId = divisionsFinancialResourcesId;
 }

 public String getDivisionsStudentOversightId ()
 {
  return divisionsStudentOversightId;
 }

 public void setDivisionsStudentOversightId (String divisionsStudentOversightId)
 {
  this.divisionsStudentOversightId = divisionsStudentOversightId;
 }

 public String getInstitutionId ()
 {
  return institutionId;
 }

 public void setInstitutionId (String institutionId)
 {
  this.institutionId = institutionId;
 }

 public String getUnitsContentOwnerId ()
 {
  return unitsContentOwnerId;
 }

 public void setUnitsContentOwnerId (String unitsContentOwnerId)
 {
  this.unitsContentOwnerId = unitsContentOwnerId;
 }

 public String getUnitsDeploymentId ()
 {
  return unitsDeploymentId;
 }

 public void setUnitsDeploymentId (String unitsDeploymentId)
 {
  this.unitsDeploymentId = unitsDeploymentId;
 }

 public String getUnitsFinancialControlId ()
 {
  return unitsFinancialControlId;
 }

 public void setUnitsFinancialControlId (String unitsFinancialControlId)
 {
  this.unitsFinancialControlId = unitsFinancialControlId;
 }

 public String getUnitsFinancialResourcesId ()
 {
  return unitsFinancialResourcesId;
 }

 public void setUnitsFinancialResourcesId (String unitsFinancialResourcesId)
 {
  this.unitsFinancialResourcesId = unitsFinancialResourcesId;
 }

 public String getUnitsStudentOversightId ()
 {
  return unitsStudentOversightId;
 }

 public void setUnitsStudentOversightId (String unitsStudentOversightId)
 {
  this.unitsStudentOversightId = unitsStudentOversightId;
 }

 

 public String getVersionInfo ()
 {
  return versionInfo;
 }

 public void setVersionInfo (String versionInfo)
 {
  this.versionInfo = versionInfo;
 }

 
 
}
