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

import org.kuali.student.r2.common.dto.StatusInfo;
import org.kuali.student.r2.common.dto.ValidationResultInfo;
import org.kuali.student.r2.common.exceptions.DataValidationErrorException;
import org.kuali.student.r2.common.exceptions.DoesNotExistException;
import org.kuali.student.r2.lum.course.dto.CourseInfo;

/**
 * 
 * @author nwright
 */
public class CreditCourseDeleteResult {

	public enum Status {

		DELETED, DOES_NOT_EXISTS, EXCEPTION;

		private int count = 0;

		public int getCount() {
			return count;
		}

		public void setCount(int count) {
			this.count = count;
		}

		public void increment() {
			this.count++;
		}
	};

	private Status status;
	private int row;
	private CreditCourse creditCourse;
	private StatusInfo statusInfo;
	private DoesNotExistException doesNotExistException;
	private Exception exception;
	private CourseInfo courseInfo;
	 
	public CourseInfo getCourseInfo() {
		return courseInfo;
	}

	public void setCourseInfo(CourseInfo courseInfo) {
		this.courseInfo = courseInfo;
	}

	public StatusInfo getStatusInfo() {
		return statusInfo;
	}

	public void setStatusInfo(StatusInfo statusInfo) {
		this.statusInfo = statusInfo;
	}

	public CreditCourse getCreditCourse() {
		return creditCourse;
	}

	public void setCreditCourse(CreditCourse creditCourse) {
		this.creditCourse = creditCourse;
	}

	public DoesNotExistException getDoesNotExistException() {
		return doesNotExistException;
	}

	public void setDoesNotExistException(
			DoesNotExistException doesNotExistException) {
		this.doesNotExistException = doesNotExistException;
	}

	public Exception getException() {
		return exception;
	}

	public void setException(Exception exception) {
		this.exception = exception;
	}

	public int getRow() {
		return row;
	}

	public void setRow(int row) {
		this.row = row;
	}

	public Status getStatus() {
		return status;
	}

	public void setStatus(Status status) {
		this.status = status;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append(row);
		builder.append(". ");
		builder.append(status);
		builder.append(": ");
		builder.append(this.creditCourse.getCode());
		builder.append(": ");
		if (this.exception != null) {
			builder.append(this.exception.getClass().getName());
			builder.append(": ");
			builder.append(this.exception.getMessage());
		}
		if (this.doesNotExistException != null) {
			builder.append(" ");
			builder.append(this.doesNotExistException.getMessage());
		}
		return builder.toString();
	}
}
