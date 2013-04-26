package org.kuali.student.loader.organization;

import org.kuali.student.r2.core.organization.dto.OrgOrgRelationInfo;

public class OrgOrgRelation extends OrgOrgRelationInfo{
	private String orgShortName;
	private String relatedOrgShortName;
	public String getOrgShortName() {
		return orgShortName;
	}
	public void setOrgShortName(String orgShortName) {
		this.orgShortName = orgShortName;
	}
	public String getRelatedOrgShortName() {
		return relatedOrgShortName;
	}
	public void setRelatedOrgShortName(String relatedOrgShortName) {
		this.relatedOrgShortName = relatedOrgShortName;
	}
}