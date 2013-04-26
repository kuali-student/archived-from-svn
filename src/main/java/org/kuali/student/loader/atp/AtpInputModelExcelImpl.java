/*
 * Copyright 2010 The Kuali Foundation
 *
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may	obtain a copy of the License at
 *
 * 	http://www.osedu.atp/licenses/ECL-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.kuali.student.loader.atp;

import java.util.ArrayList;
import java.util.List;
import org.kuali.student.loader.util.ExcelLoaderHelper;
import org.kuali.student.loader.util.RichTextInfoHelper;
import org.kuali.student.spreadsheet.SpreadsheetReader;
import org.kuali.student.spreadsheet.WorksheetNotFoundException;
import org.kuali.student.spreadsheet.WorksheetReader;

/**
 *
 * @author nwright
 */
public class AtpInputModelExcelImpl implements AtpInputModel
{

 private SpreadsheetReader reader;

 public AtpInputModelExcelImpl (SpreadsheetReader reader)
 {
  this.reader = reader;
 }

 @Override
 public List<Atp> getAtps ()
 {
  WorksheetReader worksheetReader;
  try
  {
   worksheetReader = reader.getWorksheetReader ("Atps");
  }
  catch (WorksheetNotFoundException ex)
  {
   throw new IllegalArgumentException (ex);
  }
  ExcelLoaderHelper helper = new ExcelLoaderHelper (worksheetReader);
  helper.setMaxStringSize (500);
  List<Atp> list = new ArrayList (worksheetReader.getEstimatedRows ());
  int row = 0;
  while (worksheetReader.next ())
  {
   Atp atp = new Atp ();
   atp.setId (helper.getFixup ("key"));
   if (atp.getId () == null)
   {
    continue;
   }
   list.add (atp);
   row ++;
   atp.setDescr (new RichTextInfoHelper ().getFromPlain (helper.getFixup ("description")));
   atp.setName (helper.getFixup ("name"));
   atp.setType (helper.getFixup ("type"));
   atp.setState (helper.getFixup ("stateName"));
   atp.setStartDate (helper.getFixupDate ("startDate"));
   atp.setEndDate (helper.getFixupDate ("endDate"));
  }
  return list;
 }
}
