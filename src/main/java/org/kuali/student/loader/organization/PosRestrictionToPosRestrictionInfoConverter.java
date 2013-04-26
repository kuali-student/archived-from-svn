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

import org.kuali.student.r2.common.dto.TimeAmountInfo;
import org.kuali.student.r2.core.organization.dto.OrgPositionRestrictionInfo;


/**
 *
 * @author nwright
 */
public class PosRestrictionToPosRestrictionInfoConverter
{


 private OrgPositionRestriction posRestriction;

 public PosRestrictionToPosRestrictionInfoConverter (OrgPositionRestriction posRestriction)
 {
  this.posRestriction = posRestriction;
 }
 public OrgPositionRestrictionInfo convert ()
 {
	 OrgPositionRestrictionInfo info = new OrgPositionRestrictionInfo ();
	 info.setOrgId(posRestriction.getOrgId());
	 info.setOrgPersonRelationTypeKey(posRestriction.getOrgPersonRelationTypeKey());
	 info.setTitle(posRestriction.getTitle());
	 info.setDescr(posRestriction.getDescr());
	 info.setMinNumRelations(posRestriction.getMinNumRelations());
	 info.setMaxNumRelations(posRestriction.getMaxNumRelations());
	 TimeAmountInfo tai = new TimeAmountInfo();
	 tai.setAtpDurationTypeKey(posRestriction.getDurationUnit());
	 tai.setTimeQuantity(posRestriction.getDurationNo());
	 info.setStdDuration(tai);
	 
	 return info;
 }

}
