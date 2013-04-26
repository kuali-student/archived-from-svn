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
package org.kuali.student.loader.course;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.kuali.student.r2.core.atp.service.AtpService;
import org.kuali.student.r2.lum.course.dto.CourseInfo;
import org.kuali.student.r2.lum.course.dto.CourseVariationInfo;
import org.kuali.student.r2.lum.clu.dto.CluIdentifierInfo;


/**
 *
 * @author nwright
 */
public class CreditCoursesToCourseInfosConverter
{


 private List<CreditCourse> ccs;
 private Map<String, Object> helperService;
 
 public CreditCoursesToCourseInfosConverter (List<CreditCourse> ccs)
 {
  this.ccs = ccs;
 }

 public CreditCoursesToCourseInfosConverter (List<CreditCourse> ccs, Map<String, Object> thisServiceMap)
 {
  this.ccs = ccs;
  this.helperService = thisServiceMap;
 }
 
 public static final String ADMINISTRATION_ADMIN_ORG_TYPE = "kuali.adminOrg.type.Administration";

 public List<CreditCourseLoadResult> convert ()
 {
  List<CreditCourseLoadResult> results = new ArrayList (this.ccs.size ());
  int row = 0;
  Map<String, CourseInfo> infos = new LinkedHashMap ();
  // do non-versions first
  for (CreditCourse cc : ccs)
  {
   CreditCourseLoadResult result = new CreditCourseLoadResult ();
   results.add (result);
   result.setCreditCourse (cc);
   result.setRow (row);
   row++;
   if (cc.getVariation () != null)
   {
    continue;
   }
   CourseInfo info = new CreditCourseToCourseInfoConverter (result, helperService).convert ();
   infos.put (info.getCode (), info);
   result.setCourseInfo (info);
  }

  // now process versions
  // do non-versions first
  row = 0;
  for (CreditCourse cc : ccs)
  {
   CreditCourseLoadResult result = results.get (row);
   row++;
   if (cc.getVariation () == null)
   {
    continue;
   }
   String code = cc.getSubjectArea () + cc.getCourseNumberSuffix ();
   CourseInfo info = infos.get (code);
   if (info == null)
   {
    result.setStatus (CreditCourseLoadResult.Status.VALIDATION_ERROR);
    result.setException (new RuntimeException ("A variation was defined but could not find the base course"));
    continue;
   }
   result.setCourseInfo (info);
   result.setStatus (CreditCourseLoadResult.Status.COURSE_VARIATION_PROCESSED_WITH_MAIN_COURSE);
   if (info.getVariations () == null)   {
    info.setVariations (new ArrayList ());
   }
   CourseVariationInfo varInfo = new CourseVariationInfo ();
   varInfo.setSubjectArea (cc.getSubjectArea ());
   varInfo.setCourseNumberSuffix (cc.getCourseNumberSuffix ());
   varInfo.setVariationCode (cc.getVariation ());
   varInfo.setVariationTitle (cc.getCourseTitle ());
   varInfo.setType ("kuali.lu.type.CreditCourse.identifier.variation");
   info.getVariations ().add (varInfo);
  }
 return results;
 }

}
