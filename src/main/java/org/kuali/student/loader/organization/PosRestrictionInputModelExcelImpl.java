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
package org.kuali.student.loader.organization;

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
public class PosRestrictionInputModelExcelImpl implements PositionRestrictionInputModel
{

 private SpreadsheetReader reader;

 public PosRestrictionInputModelExcelImpl (SpreadsheetReader reader)
 {
  this.reader = reader;
 }

 @Override
 public List<OrgPositionRestriction> getOrgPositionRestrictions ()
 {
  WorksheetReader worksheetReader;
  try
  {
   worksheetReader = reader.getWorksheetReader ("PositionRestrictions");
  }
  catch (WorksheetNotFoundException ex)
  {
   throw new IllegalArgumentException (ex);
  }
  ExcelLoaderHelper helper = new ExcelLoaderHelper (worksheetReader);
  helper.setMaxStringSize (500);
  List<OrgPositionRestriction> list = new ArrayList (worksheetReader.getEstimatedRows ());
  int row = 0;
  while (worksheetReader.next ())
  {
   OrgPositionRestriction posRestriction = new OrgPositionRestriction ();
   posRestriction.setOrgId(helper.getFixup ("orgId"));
   if (posRestriction.getOrgId () == null)
   {
    continue;
   }
   list.add (posRestriction);
   row ++;
   posRestriction.setOrgShortName(helper.getFixup ("orgShortName"));
   posRestriction.setTitle(helper.getFixup ("Title"));
   posRestriction.setOrgPersonRelationTypeKey(helper.getFixup ("OrgPersonRelationTypeKey"));
   RichTextInfoHelper richTextInfoHelper = new RichTextInfoHelper();
   posRestriction.setDescr(richTextInfoHelper.getFromPlain(helper.getFixup ("Desc")));
   posRestriction.setMinNumRelations(helper.getFixupInteger("MinNum"));
   posRestriction.setMaxNumRelations(helper.getFixup("MaxNum"));
   posRestriction.setDurationUnit(helper.getFixup("DurationUnit"));
   posRestriction.setDurationNo(helper.getFixupInteger("DurationNo"));
  }
  return list;
 }
}
