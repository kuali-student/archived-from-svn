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
public class CreditCourseDeleterInputModelExcelImpl implements CreditCourseInputModel {

	private SpreadsheetReader reader;

	public CreditCourseDeleterInputModelExcelImpl(SpreadsheetReader reader) {
		this.reader = reader;
	}

	@SuppressWarnings("rawtypes")
	@Override
	public List<CreditCourse> getCreditCourses() {
		WorksheetReader worksheetReader;
		try {
			worksheetReader = reader.getWorksheetReader("DeleteCourses");
		} catch (WorksheetNotFoundException ex) {
			throw new IllegalArgumentException(ex);
		}
		ExcelLoaderHelper helper = new ExcelLoaderHelper(worksheetReader);
		helper.setMaxStringSize(2000);
		@SuppressWarnings("unchecked")
		List<CreditCourse> list = new ArrayList(worksheetReader.getEstimatedRows());
		while (worksheetReader.next()) {
			CreditCourse cc = new CreditCourse();
			cc.setId(helper.getFixup("id"));
			list.add(cc);
		}
		return list;
	}

}
