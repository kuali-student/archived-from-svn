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
import org.kuali.student.loader.util.ExcelLoaderHelper;
import org.kuali.student.spreadsheet.SpreadsheetReader;
import org.kuali.student.spreadsheet.WorksheetNotFoundException;
import org.kuali.student.spreadsheet.WorksheetReader;

/**
 * 
 * @author nwright
 */
public class CreditCourseInputModelExcelImpl implements CreditCourseInputModel {

	private SpreadsheetReader reader;

	public CreditCourseInputModelExcelImpl(SpreadsheetReader reader) {
		this.reader = reader;
	}

	@Override
	public List<CreditCourse> getCreditCourses() {
		WorksheetReader worksheetReader;
		try {
			worksheetReader = reader.getWorksheetReader("CreditCourses");
		} catch (WorksheetNotFoundException ex) {
			throw new IllegalArgumentException(ex);
		}
		ExcelLoaderHelper helper = new ExcelLoaderHelper(worksheetReader);
		helper.setMaxStringSize(2000);
		List<CreditCourse> list = new ArrayList(
				worksheetReader.getEstimatedRows());
		int row = 0;
		while (worksheetReader.next()) {
			CreditCourse cc = new CreditCourse();
			cc.setId(helper.getFixup("id"));
			cc.setCode(helper.getFixup("code"));
			if (cc.getCode() == null) {
				continue;
			}
			list.add(cc);
			row++;
			cc.setSubjectArea(helper.getFixup("subjectArea"));
			cc.setCourseNumberSuffix(helper.getFixup("courseNumberSuffix"));
			cc.setVariation(helper.getFixup("variation"));
			cc.setAdministeringOrgName(helper.getFixup("AdministeringOrgName"));
			cc.setAdministeringOrg(helper.getFixup("administeringOrg"));
			cc.setTranscriptTitle(helper.getFixup("TranscriptTitle"));
			cc.setCourseTitle(helper.getFixup("CourseTitle"));
			cc.setDescr(helper.getFixup("Descr"));
			cc.setMinCredits(helper.getFixup("minCredits"));
			cc.setMaxCredits(helper.getFixup("maxCredits"));
			cc.setRestrictions(helper.getFixup("restrictions"));
			cc.setPrereq(helper.getFixup("prereq"));
			cc.setPrereqNL(helper.getFixup("prereqNL"));
			cc.setCoreq(helper.getFixup("coreq"));
			cc.setCoreqNL(helper.getFixup("coreqNL"));
			cc.setEquivalencies(helper.getFixup("equivalencies"));
			cc.setGradingOptions(helper.getFixup("gradingOptions"));
			cc.setTermsOffered(helper.getFixup("TermsOffered"));
			cc.setRequirementsMet(helper.getFixup("requirementsMet"));
			cc.setLearningObjectives(helper.getFixup("learningObjectives"));
			cc.setFinalExam(helper.getFixup("FinalExam"));
			cc.setFinalExamRationale(helper.getFixup("FinalExamRationale"));
			cc.setStartTerm(helper.getFixup("startTerm"));
			cc.setEndTerm(helper.getFixup("endTerm"));
			cc.setFormatActivities(helper.getFixup("formatActivities"));
			cc.setLecHr(helper.getFixup("lecHr"));
			cc.setLabHr(helper.getFixup("labHr"));
			cc.setAudit(helper.getFixupBoolean("audit"));
			cc.setPassFail(helper.getFixupBoolean("passFail"));
			cc.setSpecialTopics(helper.getFixupBoolean("specialTopics"));
		}
		return list;
	}

}
