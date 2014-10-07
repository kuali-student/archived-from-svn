
When(/^I navigate to the planner page for a course which has note$/) do
  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Summer1", :course_code => "ENGL206", :term=>"Summer 1 2014", :state => "planned", :notes_update =>"UPDATED TEST"
  @course_search_result.course_search
  @course_search_result.quick_add_planned_notes
end

And(/^I choose to update the notes$/) do
  @course_search_result.update_notes
end

Then(/^I should be able to successfully update the notes$/) do
  @course_search_result.successful_updation
  on CoursePlannerPage do |page|
    page.refresh
    page.planner_courses_detail_list.wait_until_present(120)
    #page.added_course_note(@course_search_result.planned_term, @course_search_result.course_code).wait_until_present(120)
    page.added_course_note(@course_search_result.planned_term, @course_search_result.course_code).attribute_value("data-content").should include @course_search_result.notes_update
  end
 end

Then(/^I should be able to successfully delete the notes$/) do
  @course_search_result.successful_deletion
  on CoursePlannerPage do |page|
    page.refresh
    page.planner_courses_detail_list.wait_until_present(120)
    page.added_course_note(@course_search_result.planned_term, @course_search_result.course_code).attribute_value("data-content").should==""
  end
end