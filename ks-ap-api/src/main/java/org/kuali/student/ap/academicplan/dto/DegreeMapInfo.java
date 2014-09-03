package org.kuali.student.ap.academicplan.dto;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

import org.kuali.student.ap.academicplan.infc.DegreeMap;
import org.kuali.student.ap.academicplan.infc.DegreeMapRequirement;

/**
 * Degree Map message structure
 *
 * @Author mguilla Date: 1/21/14
 *
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "DegreeMapInfo", propOrder = { "requirementInfos" })
public class DegreeMapInfo extends LearningPlanInfo implements DegreeMap {

	private static final long serialVersionUID = 8024618591278071960L;

	@XmlElement
	private List<DegreeMapRequirementInfo> requirementInfos;

	public DegreeMapInfo() {
	}

	public DegreeMapInfo(DegreeMap copy) {
		super(copy);

		List<? extends DegreeMapRequirement> reqs = copy.getRequirements();
		if (reqs != null) {
			List<DegreeMapRequirementInfo> reqInfos = new ArrayList<DegreeMapRequirementInfo>(
					reqs.size());
			for (DegreeMapRequirement req : reqs)
				reqInfos.add(new DegreeMapRequirementInfo(req));
			this.setRequirementInfos(reqInfos);
		}
	}

	public List<DegreeMapRequirement> getRequirements() {
		if (requirementInfos == null) {
			return Collections.emptyList();
		} else {
			return Collections
					.<DegreeMapRequirement> unmodifiableList(requirementInfos);
		}
	}

	public List<DegreeMapRequirementInfo> getRequirementInfos() {
		return requirementInfos;
	}

	public void setRequirementInfos(
			List<DegreeMapRequirementInfo> requirementInfos) {
		this.requirementInfos = requirementInfos;
	}

}
