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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.kuali.student.r2.lum.program.dto.CoreProgramInfo;
import org.kuali.student.r2.lum.program.dto.CredentialProgramInfo;
import org.kuali.student.r2.lum.program.dto.MajorDisciplineInfo;
import org.kuali.student.r2.lum.program.dto.ProgramVariationInfo;

/**
 *
 * @author nwright
 */
public class ProgramsToMajorDisciplineInfosConverter
{

 private List<Program> progs;
 private Map<String, Object> helperService;

 public ProgramsToMajorDisciplineInfosConverter (List<Program> progs, Map<String, Object> thisServiceMap)
 {
  this.progs = progs;
  this.helperService = thisServiceMap;
 }
 public static final String ADMINISTRATION_ADMIN_ORG_TYPE =
                            "kuali.adminOrg.type.Administration";

 public List<ProgramLoadResult> convert ()
 {
  List<ProgramLoadResult> results = new ArrayList (this.progs.size ());
  int row = 0;
  Map<String, MajorDisciplineInfo> infos = new LinkedHashMap ();
  // do non-versions first
  for (Program prog : progs)
  {
   ProgramLoadResult result = new ProgramLoadResult ();
   results.add (result);
   result.setProgram (prog);
   result.setRow (row);
   row ++;
   if (prog.getType ().equals ("kuali.lu.type.Variation"))
   {
    continue;
   }
   if (prog.getType ().equals ("kuali.lu.type.CoreProgram"))
   {
    //result.setStatus (ProgramLoadResult.Status.CORE_PROGRAM_NOT_PROCESSED);
	   CoreProgramInfo core = new ProgramToCoreProgramInfoConverter(result, helperService).convert();
	   result.setCoreProgramInfo(core);
    continue;
   }
   if (prog.getType ().startsWith ("kuali.lu.type.credential."))
   {
    //result.setStatus (ProgramLoadResult.Status.CREDENTIAL_PROGRAM_NOT_PROCESSED);
	   CredentialProgramInfo bacc = new ProgramToCredentialProgramInfoConverter(result, helperService).convert();
	   result.setCredentialProgramInfo(bacc);
    continue;
   }
   if (prog.getType ().equals ("kuali.lu.type.MajorDiscipline"))
   {
    MajorDisciplineInfo info =
                        new ProgramToMajorDisciplineInfoConverter (result, helperService).convert ();
    infos.put (info.getCode (), info);
    result.setMajorDisciplineInfo (info);
    continue;
   }
   throw new IllegalArgumentException ("Invalid/unhandled type="
                                       + prog.getType ());
  }

  // now process versions
  // do non-versions first
  row = 0;
  for (Program prog : progs)
  {
   ProgramLoadResult result = results.get (row);
   row ++;
   if ( ! prog.getType ().equals ("kuali.lu.type.Variation"))
   {
    continue;
   }
   String code = prog.getVariationOf ();
   MajorDisciplineInfo info = infos.get (code);
   if (info == null)
   {
    result.setStatus (ProgramLoadResult.Status.VALIDATION_ERROR);
    result.setException (new RuntimeException (
      "A variation was defined but could not find the major discipline program"));
    continue;
   }
   result.setMajorDisciplineInfo (info);
   result.setStatus (
     ProgramLoadResult.Status.VARIATION_PROCESSED_WITH_MAJOR_DISCIPLINE);
   if (info.getVariations () == null)
   {
    info.setVariations (new ArrayList ());
   }
   ProgramVariationInfo varInfo = new ProgramToProgramVariationInfoConverter (
     result, helperService).convert ();
   info.getVariations ().add (varInfo);
  }
  return results;
 }
}
