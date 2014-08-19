When(/^I perform a blank search for Courses$/) do
  @course = make CmCourseObject, :search_term => nil
  @course.search_for_course
end


Then(/^I get a course code required validation error$/) do
  on CmFindACoursePage do |error|
    error.course_code_dirty_error.exists?.should be_true
    error.page_validation_text.should include "Course Code: Required"
    error.growl_text.should include "The form contains errors. Please correct these errors and try again."
    error.growl_message_div.wait_while_present
    return_to_cm_home
  end
end


When(/^I search for Courses by entering partial course code$/) do
  @course = make CmCourseObject, :search_term => "HIST2", :course_code => "HIST2"
  @course.search_for_course
end


Then(/^I get the results matching the search criteria$/) do
  on CmFindACoursePage do |result_table|
    result_table.results_list_course_code.each do |result|
      result.should include @course.course_code
    end
  end
end


When(/^I search for Courses by entering complete course code$/) do
  @course = make CmCourseObject, :search_term => "BSCI106", :course_code => "BSCI106"
  @course.search_for_course
end


Then(/^I get correct course returned on the search$/) do
  on CmFindACoursePage do |result_table|
    result_table.results_list_course_code.each do |result|
      result.should == @course.course_code
    end
  end
end


When(/^I perform an invalid search for Courses$/) do
  @course = make CmCourseObject, :search_term => "invalid search"
  @course.search_for_course
end


Then(/^a message indicating no matching records is displayed\.$/) do
  on CmFindACoursePage do |error|
    error.no_lookup_results.exists?.should be_true
    error.no_lookup_results_text.should include "did not match any records"
  end
end

When(/^I view the details of a course using Find a Course$/) do
  outcome = (make CmOutcomeObject, :outcome_level => 1, :outcome_type => "Fixed", :credit_value => 3)

  format = (make CmFormatsObject,  :format_level => 1,
                                   :activity_level => 1,
                                   :type => "Lecture",
                                   :contacted_hours => 3,
                                   :contact_frequency => "week",
                                   :duration_count => nil,
                                   :duration_type => nil,
                                   :class_size => 0 )

  @course = make CmCourseObject, :course_title => "The Rise of the West: 1500 - 1789",
                                 :transcript_course_title => "WEST 1500-1789",
                                 :search_term => "HIST112",
                                 :course_code => "HIST112",
                                 :description => "History of early modern Europe.",
                                 :campus_location => "North",
                                 :curriculum_oversight => "ARHU-History",
                                 :assessment_scale => "Letter; Pass/Fail Grading",
                                 :audit => "Yes",
                                 :pass_fail_transcript_grade => "Yes",
                                 :final_exam_status => "Standard Final Exam",
                                 :outcome_list => [outcome],
                                 :format_list => [format],
                                 :start_term => "Fall 2007",
                                 :pilot_course => "No",
                                 :course_state => "Active"



  @course.view_course
end




Then(/^I can view all the details of the course$/) do
    on CmReviewProposal do |review|
      review.course_state_review.capitalize.should include @course.course_state
      #COURSE INFORMATION
      review.course_title_review.should include @course.course_title
      review.transcript_course_title.should include @course.transcript_course_title
      "#{review.subject_code_review}""#{review.course_number_review}".should include @course.course_code
      review.description_review.should include @course.description
      #GOVERNANCE
      review.campus_locations_review.should include @course.campus_location
      review.curriculum_oversight_review.should include @course.curriculum_oversight
      #COURSE LOGISTICS
      review.assessment_scale_review.should include @course.assessment_scale
      review.audit_review.should include @course.audit
      review.pass_fail_transcript_review.should include @course.pass_fail_transcript_grade
      review.final_exam_status_review.should include @course.final_exam_status
      #OUTCOMES
      review.outcome_level_review(1).should include "#{@course.outcome_list[0].outcome_level}"
      review.outcome_type_review(1).should include @course.outcome_list[0].outcome_type
      review.outcome_credit_review(1).should include "#{@course.outcome_list[0].credit_value}"
      #FORMATS
      review.activity_level_review(@course.format_list[0].format_level, @course.format_list[0].activity_level).should include "#{@course.format_list[0].activity_level}"
      review.activity_type_review(@course.format_list[0].format_level, @course.format_list[0].activity_level).should include @course.format_list[0].type
      review.activity_contact_hours_frequency_review(@course.format_list[0].format_level, @course.format_list[0].activity_level).should include "#{@course.format_list[0].contacted_hours}"
      review.activity_contact_hours_frequency_review(@course.format_list[0].format_level, @course.format_list[0].activity_level).should include @course.format_list[0].contact_frequency
      review.activity_class_size_review(@course.format_list[0].format_level, @course.format_list[0].activity_level).should include "#{@course.format_list[0].class_size}"

    end
end
