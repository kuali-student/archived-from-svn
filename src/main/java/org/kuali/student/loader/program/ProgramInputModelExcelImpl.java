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

import java.util.ArrayList;
import java.util.List;
import org.kuali.student.loader.util.ExcelLoaderHelper;
import org.kuali.student.spreadsheet.SpreadsheetReader;
import org.kuali.student.spreadsheet.WorksheetNotFoundException;
import org.kuali.student.spreadsheet.WorksheetReader;

/**
 *
 * @author nwright
 */
public class ProgramInputModelExcelImpl implements ProgramInputModel
{

 private SpreadsheetReader reader;

 public ProgramInputModelExcelImpl (SpreadsheetReader reader)
 {
  this.reader = reader;
 }

 @Override
 public List<Program> getPrograms ()
 {
  WorksheetReader worksheetReader;
  try
  {
   worksheetReader = reader.getWorksheetReader ("Programs");
  }
  catch (WorksheetNotFoundException ex)
  {
   throw new IllegalArgumentException (ex);
  }
  ExcelLoaderHelper helper = new ExcelLoaderHelper (worksheetReader);
  helper.setMaxStringSize (2000);
  List<Program> list = new ArrayList (worksheetReader.getEstimatedRows ());
  int row = 0;
  while (worksheetReader.next ())
  {
   Program prog = new Program ();
   prog.setCode (helper.getFixup ("code"));
   if (prog.getCode () == null)
   {
    continue;
   }
   prog.setUniversityClassification (
     helper.getFixup ("universityClassification"));
   prog.setType (helper.getFixup ("type"));
   prog.setVariationOf (helper.getFixup ("variationOf"));
   prog.setIsVariationRequired (helper.getFixupBoolean ("isVariationRequired"));
   prog.setCorePrograms (helper.getFixup ("corePrograms"));
   prog.setCredentialProgram (helper.getFixup ("credentialProgram"));
   prog.setCredentialProgramId (helper.getFixup ("credentialProgramId"));
   prog.setId (helper.getFixup ("id"));
   prog.setShortTitle (helper.getFixup ("shortTitle"));
   prog.setLongTitle (helper.getFixup ("longTitle"));
   prog.setTranscriptTitle (helper.getFixup ("transcriptTitle"));
   prog.setAccreditingAgencies (helper.getFixup ("accreditingAgencies"));
   prog.setCampusLocations (helper.getFixup ("campusLocations"));
   prog.setCatalogPublicationTargets (helper.getFixup (
     "catalogPublicationTargets"));
   prog.setCip2000Code (helper.getFixup ("cip2000Code"));
   prog.setCip2010Code (helper.getFixup ("cip2010Code"));
   prog.setHegisCode (helper.getFixup ("hegisCode"));
   prog.setDescr (helper.getFixup ("descr"));
   prog.setCatalogDescr (helper.getFixup ("catalogDescr"));
   prog.setDiplomaTitle (helper.getFixup ("diplomaTitle"));
   prog.setUnitsContentOwner (helper.getFixup ("unitsContentOwner"));
   prog.setDivisionsContentOwner (helper.getFixup ("divisionsContentOwner"));
   prog.setUnitsDeployment (helper.getFixup ("unitsDeployment"));
   prog.setDivisionsDeployment (helper.getFixup ("divisionsDeployment"));
   prog.setUnitsFinancialControl (helper.getFixup ("unitsFinancialControl"));
   prog.setDivisionsFinancialControl (helper.getFixup (
     "divisionsFinancialControl"));
   prog.setUnitsFinancialResources (helper.getFixup ("unitsFinancialResources"));
   prog.setDivisionsFinancialResources (helper.getFixup (
     "divisionsFinancialResources"));
   prog.setUnitsStudentOversight (helper.getFixup ("unitsStudentOversight"));
   prog.setDivisionsStudentOversight (helper.getFixup (
     "divisionsStudentOversight"));
   prog.setInstitution (helper.getFixup ("institution"));

   prog.setUnitsContentOwnerId (helper.getFixup ("unitsContentOwnerId"));
   prog.setDivisionsContentOwnerId (helper.getFixup ("divisionsContentOwnerId"));
   prog.setUnitsDeploymentId (helper.getFixup ("unitsDeploymentId"));
   prog.setDivisionsDeploymentId (helper.getFixup ("divisionsDeploymentId"));
   prog.setUnitsFinancialControlId (helper.getFixup ("unitsFinancialControlId"));
   prog.setDivisionsFinancialControlId (helper.getFixup (
     "divisionsFinancialControlId"));
   prog.setUnitsFinancialResourcesId (helper.getFixup ("unitsFinancialResourcesId"));
   prog.setDivisionsFinancialResourcesId (helper.getFixup (
     "divisionsFinancialResourcesId"));
   prog.setUnitsStudentOversightId (helper.getFixup ("unitsStudentOversightId"));
   prog.setDivisionsStudentOversightId (helper.getFixup (
     "divisionsStudentOversightId"));
   prog.setInstitutionId (helper.getFixup ("institutionId"));

   prog.setStdDuration (helper.getFixup ("stdDuration"));
   prog.setDurationNotes (helper.getFixup ("durationNotes"));
   prog.setStartTerm (helper.getFixup ("startTerm"));
   prog.setEndTerm (helper.getFixup ("endTerm"));
   prog.setState (helper.getFixup ("state"));
   prog.setEndInstAdmitTerm (helper.getFixup ("endInstAdmitTerm"));
   prog.setEndProgramEntryTerm (helper.getFixup ("endProgramEntryTerm"));
   prog.setIntensity (helper.getFixup ("intensity"));
   prog.setLastReviewDate (helper.getFixupDate ("lastReviewDate"));
   prog.setNextReviewPeriod (helper.getFixup ("nextReviewPeriod"));
   prog.setPublishedInstructors (helper.getFixup ("publishedInstructors"));
   prog.setCoreFaculties (helper.getFixup ("coreFaculties"));
   prog.setReferenceURL (helper.getFixup ("referenceURL"));
   prog.setResultOptions (helper.getFixup ("resultOptions"));
   prog.setSelectiveEnrollmentCode (helper.getFixup ("selectiveEnrollmentCode"));
   prog.setVersionInfo (helper.getFixup ("versionInfo"));
   prog.setProgramLevel (helper.getFixup ("programLevel"));
   prog.setProgramRequirements (helper.getFixup ("programRequirements"));
   prog.setLearningObjectives (helper.getFixup ("learningObjectives"));

   list.add (prog);
   row ++;

  }
  return list;
 }
}
