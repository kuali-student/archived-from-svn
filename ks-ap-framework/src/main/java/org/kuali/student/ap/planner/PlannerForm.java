package org.kuali.student.ap.planner;

import java.math.BigDecimal;
import java.util.List;
import org.kuali.student.r2.lum.course.infc.Course;

public interface PlannerForm extends PlanItemForm {

	boolean isBackup();
    boolean isBookmarked();
    void setBookmarked(boolean bookmarked);

    boolean isKeepBookmarked();
    void setKeepBookmarked(boolean keepBookmarked);

	String getCourseNote();

	BigDecimal getCreditsForPlanItem();
    BigDecimal getCreditsForPlanItem(Course course);

	void populateFromPlanItem();

	String getTermNote();

	String getTargetTermId();

	String getCourseCd();

	List<PlannerTerm> getTerms();

    String getPlannedMessage();
    void setPlannedMessage(String plannedMessage);
}