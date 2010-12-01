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
import java.util.List;
import java.util.Properties;

import org.kuali.student.core.atp.service.AtpService;
import org.kuali.student.core.exceptions.DataValidationErrorException;
import org.kuali.student.core.validation.dto.ValidationResultInfo;
import org.kuali.student.lum.course.dto.CourseInfo;
import org.kuali.student.lum.course.service.CourseService;

/**
 *
 * @author nwright
 */
public class CreditCourseLoader
{

 private CourseService courseService;
 private AtpService atpService;

 public AtpService getAtpService ()
 {
  return atpService;
 }

 public void setAtpService (AtpService atpService)
 {
  this.atpService = atpService;
 }

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
  List<CreditCourseLoadResult> results = new CreditCoursesToCourseInfosConverter (inputDataSource, atpService).convert ();
  for (CreditCourseLoadResult result : results)
  {
   if (result.getStatus () != null)
   {
    continue;
   }
   CourseInfo info = result.getCourseInfo ();
   try
   {
    CourseInfo createdInfo = courseService.createCourse (info);
    result.setCourseInfo (createdInfo);
    result.setStatus (CreditCourseLoadResult.Status.CREATED);
   }
   catch (DataValidationErrorException ex)
   {
    List<ValidationResultInfo> vris = null;
    try
    {
     vris = courseService.validateCourse ("SYSTEM", info);
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
}
