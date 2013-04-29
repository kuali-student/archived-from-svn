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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.kuali.student.loader.util.ContextInfoHelper;
import org.kuali.student.r2.common.dto.StatusInfo;
import org.kuali.student.r2.common.exceptions.DoesNotExistException;
import org.kuali.student.r2.lum.course.dto.CourseInfo;
import org.kuali.student.r2.lum.course.service.CourseService;

/**
 * 
 * @author nwright
 */
public class CreditCourseDeleter {

	private CourseService courseService;
	private Map<String, Object> helperService = new HashMap<String, Object>();

	public CourseService getCourseService() {
		return courseService;
	}

	public void setCourseService(CourseService courseService) {
		this.courseService = courseService;
	}

	public CreditCourseDeleter() {
	}

	private List<CreditCourse> inputDataSource;

	public List<CreditCourse> getInputDataSource() {
		return inputDataSource;
	}

	public void setInputDataSource(List<CreditCourse> inputDataSource) {
		this.inputDataSource = inputDataSource;
	}

	List<CreditCourseDeleteResult> results = new ArrayList<CreditCourseDeleteResult>();
	public List<CreditCourseDeleteResult> update() {
		// TODO revisit ContextInfo.
		ContextInfoHelper ctxInfoHelper = new ContextInfoHelper();

		if (results.isEmpty()) {
			results = new CreditCoursesToCreditCourseDeleteConverter(inputDataSource).convert();
		}
		ArrayList<CreditCourse> errList = new ArrayList<CreditCourse>();
		for (CreditCourseDeleteResult result : results) {
			if (result.getStatus() != null) {
				continue;
			}
			
			CreditCourse course = result.getCreditCourse();
			CourseInfo courseInfo = null;
			try {
				courseInfo = courseService.getCourse(course.getId(), ctxInfoHelper.getDefaultContextInfo());
				result.setCourseInfo(courseInfo);
				StatusInfo statusInfo = courseService.deleteCourse(
						course.getId(), ctxInfoHelper.getDefaultContextInfo());
				result.setStatusInfo(statusInfo);
				result.setStatus(CreditCourseDeleteResult.Status.DELETED);
			} catch (DoesNotExistException dneex) {
				result.setStatus(CreditCourseDeleteResult.Status.DOES_NOT_EXISTS);
				result.setDoesNotExistException(dneex);
			} catch (RuntimeException ex) {
				String code = "No Course Code Found ";
				if (null != courseInfo && null != courseInfo.getCode()) {
					code = courseInfo.getCode();
				} 
				CreditCourse errCreditCourse = new CreditCourse();
				errCreditCourse.setId(course.getId());
				errList.add(errCreditCourse);
				System.out.println("code = " + code + "courseId = " + courseInfo.getId());
				//throw new RuntimeException("code = " + code + "courseId = " + courseInfo.getId(), ex);
				result.setStatus(CreditCourseDeleteResult.Status.EXCEPTION);
				result.setException(ex);
			} catch (Exception ex) {
				result.setStatus(CreditCourseDeleteResult.Status.EXCEPTION);
				result.setException(ex);
			}
		}
//		if (!errList.isEmpty()) {
//			this.setInputDataSource(errList);
//			this.update();
//		}
		return results;
	}

	public void setHelperService(Map<String, Object> helperService) {
		this.helperService = helperService;
	}

	public Map<String, Object> getHelperService() {
		return helperService;
	}
}
