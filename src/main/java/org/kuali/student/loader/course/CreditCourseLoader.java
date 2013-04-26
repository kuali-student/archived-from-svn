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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.kuali.student.loader.util.ContextInfoHelper;
import org.kuali.student.r2.common.dto.ValidationResultInfo;
import org.kuali.student.r2.common.exceptions.DataValidationErrorException;
import org.kuali.student.r2.lum.course.dto.CourseInfo;
import org.kuali.student.r2.lum.course.service.CourseService;

/**
 *
 * @author nwright
 */
public class CreditCourseLoader
{

 private CourseService courseService;
 private Map<String, Object> helperService = new HashMap<String, Object>();
 
 public CourseService getCourseService ()
 {
  return courseService;
 }

 public void setCourseService (CourseService courseService)
 {
  this.courseService = courseService;
 }

 public CreditCourseLoader ()
 {
 }
 private List<CreditCourse> inputDataSource;

 public List<CreditCourse> getInputDataSource ()
 {
  return inputDataSource;
 }

 public void setInputDataSource (List<CreditCourse> inputDataSource)
 {
  this.inputDataSource = inputDataSource;
 }

 public List<CreditCourseLoadResult> update ()
 {
	//TODO revisit ContextInfo.
	 ContextInfoHelper ctxInfoHelper = new ContextInfoHelper();
	 
	List<CreditCourseLoadResult> results = new CreditCoursesToCourseInfosConverter (inputDataSource, helperService).convert ();
  for (CreditCourseLoadResult result : results)
  {
   if (result.getStatus () != null)
   {
    continue;
   }
   CourseInfo info = result.getCourseInfo ();
   try
   {
//    System.out.println ("Debug: " + info.getAttributes ());
    CourseInfo createdInfo = courseService.createCourse (info,ctxInfoHelper.getDefaultContextInfo());
    result.setCourseInfo (createdInfo);
    result.setStatus (CreditCourseLoadResult.Status.CREATED);
   }
   catch (DataValidationErrorException ex)
   {
    List<ValidationResultInfo> vris = null;
    try
    {
     vris = courseService.validateCourse ("SYSTEM", info, ctxInfoHelper.getDefaultContextInfo());
    }
    catch (Exception ex1)
    {
     throw new RuntimeException (
       "Got an exception trying to get validation errors", ex1);
    }
    DataValidationErrorException dvex = new DataValidationErrorException (
      "got validation errors", vris, ex);
    result.setStatus (CreditCourseLoadResult.Status.VALIDATION_ERROR);
    result.setDataValidationErrorException (dvex);
   }
   catch (RuntimeException ex)
   {
    throw new RuntimeException (ex);
   }
   catch (Exception ex)
   {
    result.setStatus (CreditCourseLoadResult.Status.EXCEPTION);
    result.setException (ex);
   }
  }
  return results;
 }

public void setHelperService(Map<String, Object> helperService) {
	this.helperService = helperService;
}

public Map<String, Object> getHelperService() {
	return helperService;
}
}
