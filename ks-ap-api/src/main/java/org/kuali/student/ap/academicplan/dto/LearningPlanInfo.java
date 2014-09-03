/*
 * Copyright 2014 The Kuali Foundation Licensed under the
 * Educational Community License, Version 2.0 (the "License"); you may
 * not use this file except in compliance with the License. You may
 * obtain a copy of the License at
 *
 * http://www.osedu.org/licenses/ECL-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an "AS IS"
 * BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */
package org.kuali.student.ap.academicplan.dto;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAnyElement;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

import org.kuali.student.ap.academicplan.infc.DegreeMapAssociation;
import org.kuali.student.ap.academicplan.infc.LearningPlan;
import org.kuali.student.r2.common.dto.IdEntityInfo;
import org.kuali.student.r2.common.dto.RichTextInfo;
import org.w3c.dom.Element;

/**
 * LearningPlan message structure
 *
 * @author Kuali Student Team
 * @version 1.0 (Dev)
 *
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "LearningPlanInfo", propOrder = { "studentId", "id", "typeKey",
		"degreeMapAssociationInfos", "stateKey", "shared", "programId",
		"effectiveDate", "expirationDate", "name", "descr", "meta",
		"attributes", "_futureElements" })
public class LearningPlanInfo extends IdEntityInfo implements LearningPlan {

	private static final long serialVersionUID = -754256998953998213L;

	@XmlElement
	private String studentId;

	@XmlElement
	private Boolean shared;

	@XmlAttribute
	private String programId;

	@XmlAttribute
	private Date effectiveDate;

	@XmlAttribute
	private Date expirationDate;

	@XmlElement
	private List<DegreeMapAssociationInfo> degreeMapAssociationInfos;

	@XmlAnyElement
	private List<Element> _futureElements;

	public LearningPlanInfo() {
	}

	public LearningPlanInfo(LearningPlan plan) {
		super(plan);

		if (null != plan) {
			this.setId(plan.getId());
			this.studentId = plan.getStudentId();
			this.setDescr((null != plan.getDescr()) ? new RichTextInfo(plan
					.getDescr()) : null);
			this.setShared(plan.getShared());

			List<? extends DegreeMapAssociation> assocs = plan
					.getDegreeMapAssociations();
			if (assocs != null) {
				List<DegreeMapAssociationInfo> assocInfos = new ArrayList<DegreeMapAssociationInfo>(
						assocs.size());
				for (DegreeMapAssociation assoc : assocs)
					assocInfos.add(new DegreeMapAssociationInfo(assoc));
				this.setDegreeMapAssociationInfos(assocInfos);
			}
		}
	}

	@Override
	public String getStudentId() {
		return studentId;
	}

	public void setStudentId(String studentId) {
		this.studentId = studentId;
	}

	@Override
	public Boolean getShared() {
		return shared;
	}

	public void setShared(Boolean shared) {
		this.shared = shared;
	}

	public String getProgramId() {
		return programId;
	}

	public void setProgramId(String credentialProgramId) {
		this.programId = credentialProgramId;
	}

	public Date getEffectiveDate() {
		return effectiveDate;
	}

	public void setEffectiveDate(Date effectiveDate) {
		this.effectiveDate = effectiveDate;
	}

	public Date getExpirationDate() {
		return expirationDate;
	}

	public void setExpirationDate(Date expirationDate) {
		this.expirationDate = expirationDate;
	}

	@Override
	public List<DegreeMapAssociation> getDegreeMapAssociations() {
		return degreeMapAssociationInfos == null ? null
				: Collections
						.<DegreeMapAssociation> unmodifiableList(degreeMapAssociationInfos);
	}

	public List<DegreeMapAssociationInfo> getDegreeMapAssociationInfos() {
		return degreeMapAssociationInfos;
	}

	public void setDegreeMapAssociationInfos(
			List<DegreeMapAssociationInfo> degreeMapAssociationInfos) {
		this.degreeMapAssociationInfos = degreeMapAssociationInfos;
	}

}
