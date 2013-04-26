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

import org.kuali.student.r2.core.organization.dto.OrgOrgRelationInfo;


/**
 *
 * @author nwright
 */
public class OrgOrgRelToOrgOrgRelInfoConverter
{


 private OrgOrgRelation orgRel;

 public OrgOrgRelToOrgOrgRelInfoConverter (OrgOrgRelation orgRel)
 {
  this.orgRel = orgRel;
 }
 public OrgOrgRelationInfo convert ()
 {
	 OrgOrgRelationInfo orgRelInfo = new OrgOrgRelationInfo ();
	 orgRelInfo.setOrgId(orgRel.getOrgId());
	 orgRelInfo.setRelatedOrgId(orgRel.getRelatedOrgId());
	 orgRelInfo.setEffectiveDate(orgRel.getEffectiveDate());
	 orgRelInfo.setState(orgRel.getState());
	 orgRelInfo.setType(orgRel.getType());
  
	 return orgRelInfo;
 }

}
