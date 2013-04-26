package org.kuali.student.loader.organization;

import org.kuali.student.r2.core.organization.dto.OrgPositionRestrictionInfo;

public class OrgPositionRestriction extends OrgPositionRestrictionInfo {
	private String orgShortName;
	private String durationUnit;
	private Integer durationNo;

	public String getOrgShortName() {
		return orgShortName;
	}

	public void setOrgShortName(String orgShortName) {
		this.orgShortName = orgShortName;
	}

	public String getDurationUnit() {
		return durationUnit;
	}

	public void setDurationUnit(String durationUnit) {
		this.durationUnit = durationUnit;
	}

	public Integer getDurationNo() {
		return durationNo;
	}

	public void setDurationNo(Integer durationNo) {
		this.durationNo = durationNo;
	}

		
}