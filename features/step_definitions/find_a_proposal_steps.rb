When(/^I perform a blank search for Courses$/) do
  @course = make CmCourseObject, :search_term => " "
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


When(/^I perform a partial search for Courses$/) do
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


When(/^I perform a full search for Courses$/) do
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
