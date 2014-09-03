package org.kuali.student.ap.academicplan.infc;

import java.util.Date;

import org.kuali.student.ap.academicplan.service.DegreeMapService;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.common.infc.TypeStateEntity;

/**
 * Ties a student's Learning Plan to a degree map
 */
public interface DegreeMapAssociation extends TypeStateEntity {

	/**
	 * Gets the learning plan ID.
	 * 
	 * @return learning plan ID
	 */
	String getLearningPlanId();

	/**
	 * Gets the degree map ID.
	 * 
	 * @return degree map ID
	 */
	String getDegreeMapId();

	/**
	 * Gets the degree map effective date.
	 * 
	 * @return the degree map effective date
	 */
	Date getDegreeMapEffectiveDate();

	/**
	 * Gets the degree map.
	 * 
	 * <p>
	 * Optional. When null, {@link #getDegreeMapId()} and #{link
	 * {@link #getDegreeMapEffectiveDate()} may be used with
	 * {@link DegreeMapService#getDegreeMap(String, Date, ContextInfo)} to look
	 * up the degree map record.
	 * </p>
	 * 
	 * @returns the degree map
	 */
	DegreeMap getDegreeMap();

	/**
	 * Determines whether or not the associated degree map has been flagged as
	 * primary by the student.
	 * 
	 * @return true if the degree map is flagged as primary, false if not.
	 */
	boolean isPrimary();

}
