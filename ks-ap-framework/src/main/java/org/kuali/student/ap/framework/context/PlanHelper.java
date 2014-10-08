package org.kuali.student.ap.framework.context;

import java.math.BigDecimal;
import java.util.List;
import java.util.Set;

import org.kuali.student.ap.academicplan.constants.AcademicPlanServiceConstants.ItemCategory;
import org.kuali.student.ap.academicplan.dto.LearningPlanInfo;
import org.kuali.student.ap.academicplan.dto.PlanItemInfo;
import org.kuali.student.ap.academicplan.infc.DegreeMapRequirement;
import org.kuali.student.ap.academicplan.infc.LearningPlan;
import org.kuali.student.ap.academicplan.infc.Placeholder;
import org.kuali.student.ap.academicplan.infc.PlaceholderInstance;
import org.kuali.student.ap.academicplan.infc.PlanItem;
import org.kuali.student.ap.academicplan.infc.TypedObjectReference;
import org.kuali.student.ap.academicplan.service.AcademicPlanService;
import org.kuali.student.enrollment.academicrecord.dto.StudentCourseRecordInfo;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.core.acal.infc.Term;
import org.kuali.student.r2.lum.course.infc.Course;

/**
 * Helper that handles configurable actions for accessing learning plans and
 * Plan items.
 */
public interface PlanHelper {

	/**
	 * Retrieves the default learning plan.
	 *
	 * @return Default Learning Plan
	 */
	LearningPlanInfo getDefaultLearningPlan();

	/**
	 * Update the default learning plan for the current session.
	 * 
	 * @param learningPlanId
	 *            learning plan ID
	 */
	void setDefaultLearningPlan(String learningPlanId);

	/**
	 * Retrieves a learning plan for the current student by ID.
	 *
	 * @param learningPlanId
	 *            plan ID
	 * @return Learning Plan
	 */
	LearningPlanInfo getLearningPlan(String learningPlanId);

	/**
	 * Update a learning plan.
	 * 
	 * @param learningPlan
	 *            The learning plan to update.
	 */
	void updateLearningPlan(LearningPlan learningPlan);

	/**
	 * Gets the plan items in a learning plan.
	 *
	 * @param planId
	 *            The learning plan ID.
	 * @return Default Learning Plan
	 */
	List<PlanItem> getPlanItems(String planId);

	/**
	 * Load a plan item from any of the student's learning plans by ID.
	 * 
	 * @param planItemId
	 *            plan item ID
	 * @return a plan item from one of the student's learning plans by ID
	 */
	PlanItem getPlanItem(String planItemId);

	/**
	 * Adds a plan item to a learning plan.
	 * 
	 * @param learningPlanId
	 *            learning plan ID
	 * @param category
	 *            item category
	 * @param descr
	 *            plan item description (course note)
	 * @param units
	 *            number of credits/units
	 * @param termIds
	 *            planned term IDs
	 * @param ref
	 *            course/placeholder reference data
	 * @return
	 */
	PlanItem addPlanItem(String learningPlanId, ItemCategory category,
			String descr, BigDecimal units, List<String> termIds,
			TypedObjectReference ref);

	/**
	 * Updates a plan item in a learning plan.
	 * 
	 * <p>
	 * In addition to calling
	 * {@link AcademicPlanService#updatePlanItem(String, PlanItemInfo, ContextInfo)}
	 * , this method should ensure that session state and cached data are
	 * updated accordingly. and/or cleared as needed to reflect the update.
	 * </p>
	 * 
	 * @param planItem
	 *            plan item
	 */
	PlanItem updatePlanItem(PlanItem item);

	/**
	 * Removes a plan item.
	 * 
	 * <p>
	 * In addition to calling
	 * {@link AcademicPlanService#deletePlanItem(String, ContextInfo)}, this
	 * method should ensure that session state and cached data are updated
	 * accordingly. and/or cleared as needed to reflect the update.
	 * </p>
	 * 
	 * @param planItemId
	 *            plan item ID
	 */
	void removePlanItem(String planItemId);

	/**
	 * Updates a term note for a learning plan.
	 * 
	 * @param learningPlanId
	 *            learning plan ID
	 * @param termId
	 *            term ID
	 * @param note
	 *            updated term note. May be null to remove the note.
	 */
	void editTermNote(String learningPlanId, String termId, String note);

	/**
	 * Gets the completed course records (via AcademicRecordService) for the
	 * student by ID.
	 * 
	 * @param studentId
	 *            The student principal ID.
	 * @return completed course records
	 */
	List<StudentCourseRecordInfo> getCompletedRecords();

	/**
	 * Gets the id of the term that the planner should display first.
	 *
	 * @return Term Id
	 */
	String getPlannerFirstTermId();

	/**
	 * Determines if two typed object references refer to the same object.
	 * 
	 * @param ref1
	 *            typed reference
	 * @param ref2
	 *            typed reference
	 * @return True if ref1 and ref2 both refer to the same typed object.
	 */
	boolean isSame(TypedObjectReference ref1, TypedObjectReference ref2);

	/**
	 * Determines if one typed object reference is encompassed by another.
	 * 
	 * @param inner
	 *            typed reference
	 * @param outer
	 *            typed reference
	 * @return True if all courses referred to by inner are also referred to by
	 *         outer.
	 */
	boolean isEncompassed(TypedObjectReference inner, TypedObjectReference outer);

	/**
	 * Gets the list of Terms to use in the Planner Calendar using a Start Term.
	 *
	 * @param startTerm
	 *            - Term that the calendar starts around
	 * @return A full List of terms to display in the calendar.
	 */
	List<Term> getPlannerCalendarTerms(Term startTerm);

	/**
	 * Retrieve the list of plan items for this course in the student's plan
	 *
	 * @param course
	 *            - Course that is being displayed
	 * @return A List of plan items related to the course.
	 */
	List<PlanItem> loadStudentsPlanItemsForCourse(String courseId);

	/**
	 * Get a set of possible course IDs for a TypedOjbectReference
	 * 
	 * @param ref
	 * @return list of course IDs
	 */
	Set<String> getCourseIds(TypedObjectReference ref);

	/**
	 * Get the course from a TypedOjbectReference
	 * 
	 * @param ref
	 * @return course or null if the reference is not for a placeholder.
	 */
	Course getCourse(TypedObjectReference ref);

	/**
	 * Get the placeholder from a TypedOjbectReference
	 * 
	 * @param ref
	 * @return placeholder or null if the reference is not for a placeholder.
	 */
	Placeholder getPlaceHolder(TypedObjectReference ref);

	/**
	 * Get the placeholder instance from a TypedOjbectReference
	 * 
	 * @param ref
	 * @return placeholder instance or null if the reference is not for a
	 *         placeholder instance.
	 */
	PlaceholderInstance getPlaceHolderInstance(TypedObjectReference ref);

	/**
	 * Get the course IDs for courses that satisfy a given PlaceHolder
	 * 
	 * @param ph
	 *            the Placeholder to resolve
	 * @return a set of one or more course IDs
	 */
	Set<String> getCourseIdsForPlaceHolder(Placeholder ph);

	/**
	 * Get the degree map requirement from a TypedOjbectReference
	 *
	 * <p>
	 * TODO: Move to DegreeMapHelper
	 * </p>
	 *
	 * @param ref
	 * @return degree map requirement or null if the reference is not for a
	 *         degree map requirement
	 */
	DegreeMapRequirement getRequirement(TypedObjectReference ref);

}
