package org.kuali.student.ap.academicplan.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAnyElement;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

import org.kuali.student.ap.academicplan.infc.DegreeMapAssociation;
import org.kuali.student.r2.common.dto.TypeStateEntityInfo;
import org.w3c.dom.Element;

/**
 * Degree Map Association DTO
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "DegreeMapAssociationInfo", propOrder = { "learningPlanId",
		"degreeMapId", "degreeMapEffectiveDate", "degreeMap", "typeKey",
		"stateKey", "meta", "attributes", "_futureElements" })
public class DegreeMapAssociationInfo extends TypeStateEntityInfo implements
		DegreeMapAssociation, Serializable {

	private static final long serialVersionUID = 6019908398241577527L;

	@XmlAttribute
	private String learningPlanId;

	@XmlAttribute
	private String degreeMapId;

	@XmlAttribute
	private Date degreeMapEffectiveDate;

	@XmlAttribute
	private boolean primary;

	@XmlElement
	private DegreeMapInfo degreeMap;

	@XmlAnyElement
	private List<Element> _futureElements;

	public DegreeMapAssociationInfo() {
	}

	public DegreeMapAssociationInfo(DegreeMapAssociation copy) {
		super(copy);
		learningPlanId = copy.getLearningPlanId();
		degreeMapId = copy.getDegreeMapId();
		degreeMapEffectiveDate = copy.getDegreeMapEffectiveDate();
		primary = copy.isPrimary();
		degreeMap = copy.getDegreeMap() == null ? null : new DegreeMapInfo(
				copy.getDegreeMap());
	}

	@Override
	public String getLearningPlanId() {
		return learningPlanId;
	}

	public void setLearningPlanId(String learningPlanId) {
		this.learningPlanId = learningPlanId;
	}

	@Override
	public String getDegreeMapId() {
		return degreeMapId;
	}

	public void setDegreeMapId(String degreeMapId) {
		this.degreeMapId = degreeMapId;
	}

	@Override
	public Date getDegreeMapEffectiveDate() {
		return degreeMapEffectiveDate;
	}

	public void setDegreeMapEffectiveDate(Date degreeMapEffectiveDate) {
		this.degreeMapEffectiveDate = degreeMapEffectiveDate;
	}

	@Override
	public boolean isPrimary() {
		return primary;
	}

	public void setPrimary(boolean primary) {
		this.primary = primary;
	}

	@Override
	public DegreeMapInfo getDegreeMap() {
		return degreeMap;
	}

	public void setDegreeMap(DegreeMapInfo degreeMap) {
		this.degreeMap = degreeMap;
	}

}
