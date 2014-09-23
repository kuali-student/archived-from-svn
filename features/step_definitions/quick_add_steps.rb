
When(/^I add a course from the quick add to the planned section in the planner$/) do
  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Summer1", :course_code => "ENGL206", :term=>"Summer 1 2014", :state => "planned"
  @course_search_result.course_search
  @course_search_result.quick_add_planned
end

Then(/^I should be able to view the course in the planned section$/) do
    on CoursePlannerPage do |page|
    page.course_code_quick_add.wait_while_present(120)
    page.planner_courses_detail_list.wait_until_present(60)
    page.course_code_term(@course_search_result.planned_term, @course_search_result.course_code).should==@course_search_result.course_code
  end
end


And(/^I add the same course again to the same section in the term$/) do
  @course_search_result.add_same_course
end

Then(/^I should get a relevant exception message$/) do
  on CoursePlannerPage do |page|
     page.exception_message.exists?.should==true
  end
end

When(/^I add a course from the quick add to the backup section in the planner$/) do
  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Summer1", :course_code => "ENGL206", :term=>"Summer 1 2014", :state => "backup"
  @course_search_result.course_search
  @course_search_result.quick_add_backup

  end

Then(/^I should be able to view the course in the backup section$/) do
  on CoursePlannerPage do |page|
    page.course_code_quick_add.wait_while_present(120)
    page.planner_courses_detail_list.wait_until_present(60)
    page.course_code_term_backup(@course_search_result.planned_term, @course_search_result.course_code).should==@course_search_result.course_code
  end
end


And(/^I add the course again to the same backup section in the term$/) do
  @course_search_result.add_same_course_backup

end


Then(/^I should get a relevant exception$/) do
  on CoursePlannerPage do |page|
    page.exception_message.exists?.should==true
  end
end