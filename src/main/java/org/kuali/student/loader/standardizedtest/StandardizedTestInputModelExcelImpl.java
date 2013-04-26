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
package org.kuali.student.loader.standardizedtest;

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
public class StandardizedTestInputModelExcelImpl implements StandardizedTestInputModel
{

 private SpreadsheetReader reader;

 public StandardizedTestInputModelExcelImpl (SpreadsheetReader reader)
 {
  this.reader = reader;
 }



 @Override
 public List<StandardizedTest> getStandardizedTests ()
 {
  WorksheetReader worksheetReader;
  try
  {
   worksheetReader = reader.getWorksheetReader ("StandardizedTests");
  }
  catch (WorksheetNotFoundException ex)
  {
   throw new IllegalArgumentException (ex);
  }
  ExcelLoaderHelper helper = new ExcelLoaderHelper (worksheetReader);
  helper.setMaxStringSize (500);
  List<StandardizedTest> list = new ArrayList (worksheetReader.getEstimatedRows ());
  int row = 0;
  while (worksheetReader.next ())
  {
   StandardizedTest st = new StandardizedTest ();
   st.setId (helper.getFixup ("id"));
   st.setTest (helper.getFixup ("test"));
   if (st.getTest () == null)
   {
    continue;
   }
   list.add (st);
   row++;
   st.setParentId (helper.getFixup ("parentId"));
   st.setComponent (helper.getFixup ("component"));
   st.setType (helper.getFixup ("type"));
   st.setState (helper.getFixup ("State"));
   st.setMinScore (helper.getFixup ("minScore"));
   st.setMaxScore (helper.getFixup ("maxScore"));
   st.setEffective (helper.getFixupDate ("effective"));
   st.setExpiration (helper.getFixupDate ("expiration"));
   st.setLevel (helper.getFixup ("level"));
   st.setOrgName (helper.getFixup ("orgName"));
   st.setOrgId (helper.getFixup ("orgId"));
   st.setShortName (helper.getFixup ("shortName"));
   st.setLongName (helper.getFixup ("longName"));
   st.setDescr (helper.getFixup ("descr"));
  }
  return list;
 }

}
