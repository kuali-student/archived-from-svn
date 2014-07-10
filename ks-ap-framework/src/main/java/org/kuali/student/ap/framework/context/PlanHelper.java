package org.kuali.student.ap.framework.context;

import java.util.List;
import java.util.Set;

import org.kuali.student.ap.academicplan.dto.LearningPlanInfo;
import org.kuali.student.ap.academicplan.infc.DegreeMapRequirement;
import org.kuali.student.ap.academicplan.infc.Placeholder;
import org.kuali.student.ap.academicplan.infc.PlaceholderInstance;
import org.kuali.student.ap.academicplan.infc.PlanItem;
import org.kuali.student.ap.academicplan.infc.TypedObjectReference;
import org.kuali.student.enrollment.academicrecord.dto.StudentCourseRecordInfo;
import org.kuali.student.r2.core.acal.infc.Term;
import org.kuali.student.r2.lum.course.infc.Course;

/**
 * Helper that handles configurable actions for accessing learning plans and Plan items.
 */
public interface PlanHelper {

    /**
     * Retrieves the default learning plan.
     *
     * @return Default Learning Plan
     */
    public LearningPlanInfo getDefaultLearningPlan();

	/**
	 * Gets the plan items in a learning plan.
	 *
	 * @param planId
	 *            The learning plan ID.
	 * @return Default Learning Plan
	 */
	public List<PlanItem> getPlanItems(String planId);

	/**
	 * Gets the completed course records (via AcademicRecordService) for the
	 * student by ID.
	 * 
	 * @param studentId
	 *            The student principal ID.
	 * @return completed course records
	 */
	public List<StudentCourseRecordInfo> getCompletedRecords(String studentId);      
    
    /**
     * Gets the id of the term that the planner should display first.
     *
     * @return Term Id
     */
    public String getPlannerFirstTermId();

    /**
     * Gets the list of Terms to use in the Planner Calendar using a Start Term.
     *
     * @param startTerm - Term that the calendar starts around
     * @return A full List of terms to display in the calendar.
     */
    public List<Term> getPlannerCalendarTerms(Term startTerm);


    /**
     * Retrieve the list of plan items for this course in the student's plan
     *
     * @param course - Course that is being displayed
     * @return A List of plan items related to the course.
     */
    public List<PlanItem> loadStudentsPlanItemsForCourse(Course course);

    /**
     * Get the placeholder from a TypedOjbectReference
     * @param ref
     * @return placeholder or null if the reference is not for a placeholder.
     */

    public Placeholder getPlaceHolder(TypedObjectReference ref);
    
    
    /**
     * Get the placeholder instance from a TypedOjbectReference
     * @param ref
     * @return placeholder instance or null if the reference is not for a placeholder instance.
     */

    public PlaceholderInstance getPlaceHolderInstance(TypedObjectReference ref);

    /**
     * Get the course IDs for courses that satisfy a given PlaceHolder
     * @param ph the Placeholder to resolve
     * @return a set of one or more course IDs
     */
    public Set<String> getCourseIdsForPlaceHolder(Placeholder ph); 
    
    /**
     * Get the degree map requirement from a TypedOjbectReference
     *
     * <p>TODO: Move to DegreeMapHelper</p>
     *
     * @param ref
     * @return degree map requirement or null if the reference is not for a degree map requirement
     */

    public DegreeMapRequirement getRequirement(TypedObjectReference ref);

}
