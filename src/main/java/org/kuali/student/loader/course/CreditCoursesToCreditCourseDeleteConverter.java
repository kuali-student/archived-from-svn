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

import org.kuali.student.r2.lum.course.dto.CourseInfo;

/**
 * 
 * @author nwright
 */
public class CreditCoursesToCreditCourseDeleteConverter {

	private List<CreditCourse> ccs;

	public CreditCoursesToCreditCourseDeleteConverter(List<CreditCourse> ccs) {
		this.ccs = ccs;
	}

	public static final String ADMINISTRATION_ADMIN_ORG_TYPE = "kuali.adminOrg.type.Administration";

	public List<CreditCourseDeleteResult> convert() {
		List<CreditCourseDeleteResult> results = new ArrayList(this.ccs.size());
		int row = 0;
		Map<String, CourseInfo> infos = new LinkedHashMap();
		// do non-versions first
		for (CreditCourse cc : ccs) {
			CreditCourseDeleteResult result = new CreditCourseDeleteResult();
			results.add(result);
			result.setCreditCourse(cc);
			result.setRow(row);
			row++;
		}
		return results;
	}

}
