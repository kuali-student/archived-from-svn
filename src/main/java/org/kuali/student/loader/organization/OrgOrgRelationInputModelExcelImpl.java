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
import org.kuali.student.spreadsheet.SpreadsheetReader;
import org.kuali.student.spreadsheet.WorksheetNotFoundException;
import org.kuali.student.spreadsheet.WorksheetReader;

/**
 *
 * @author nwright
 */
public class OrgOrgRelationInputModelExcelImpl implements OrgOrgRelationInputModel
{

 private SpreadsheetReader reader;

 public OrgOrgRelationInputModelExcelImpl (SpreadsheetReader reader)
 {
  this.reader = reader;
 }

 @Override
 public List<OrgOrgRelation> getOrgOrgRelations ()
 {
  WorksheetReader worksheetReader;
  try
  {
   worksheetReader = reader.getWorksheetReader ("OrgOrgRelations");
  }
  catch (WorksheetNotFoundException ex)
  {
   throw new IllegalArgumentException (ex);
  }
  ExcelLoaderHelper helper = new ExcelLoaderHelper (worksheetReader);
  helper.setMaxStringSize (500);
  List<OrgOrgRelation> list = new ArrayList (worksheetReader.getEstimatedRows ());
  int row = 0;
  while (worksheetReader.next ())
  {
   OrgOrgRelation orgRelation = new OrgOrgRelation ();
   orgRelation.setOrgId(helper.getFixup ("orgId"));
   if (orgRelation.getOrgId () == null)
   {
    continue;
   }
   list.add (orgRelation);
   row ++;
   orgRelation.setRelatedOrgId(helper.getFixup ("relatedOrgId"));
   orgRelation.setType (helper.getFixup ("type"));
   orgRelation.setState (helper.getFixup ("state"));
   orgRelation.setEffectiveDate (helper.getFixupDate ("effectiveDate"));
   orgRelation.setOrgShortName(helper.getFixup ("orgShortName"));
   orgRelation.setRelatedOrgShortName(helper.getFixup ("relatedOrgShortName"));
  }
  return list;
 }
}
