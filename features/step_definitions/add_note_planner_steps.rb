When(/^I enter a note while quick adding a course to the planned section$/) do
  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Summer1", :course_code => "ENGL206", :term=>"Summer 1 2014", :state => "planned", :notes =>"TEST"
  @course_search_result.course_search
  @course_search_result.quick_add_planned_notes
end
Then(/^the note should be successfully entered$/) do
  navigate_to_course_planner_home
 @course_search_result.enter_note
  on CoursePlannerPage do |page|
  page.added_course_note(@course_search_result.planned_term, @course_search_result.course_code).attribute_value("data-content").should==@course_search_result.notes
  end
end

When(/^I enter a note while quick adding a course to the backup section$/) do
  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Summer1", :course_code => "ENGL206", :term=>"Summer 1 2014", :state => "backup",:notes => "TEST"
  @course_search_result.course_search
  @course_search_result.quick_add_planned_notes
end

When(/^I enter a note while adding a course to the plan in the course search page$/) do
  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Summer1", :course_code => "ENGL201", :term=>"Summer I 2014",:notes => "TEST"
  @course_search_result.course_search
  @course_search_result.enter_note_adding_from_plan
 end






When(/^I enter a note while  adding a course to the plan in the course details page$/) do
  #navigate to course search
  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Summer1", :course_code => "ENGL206", :term=>"Summer I 2014",:notes => "TEST"
  @course_search_result.course_search
  @course_search_result.enter_note_through_cdp
end


Then(/^the note should be successfully entered for the course in the backup section$/) do
  navigate_to_course_planner_home
  on CoursePlannerPage do |page|
    page.refresh
    page.planner_courses_detail_list.wait_until_present(240)
    page.course_code_term_backup(@course_search_result.planned_term, @course_search_result.course_code).should==@course_search_result.course_code
    on CoursePlannerPage do |page|
    page.added_course_note_backup(@course_search_result.planned_term, @course_search_result.course_code).attribute_value("data-content").should==@course_search_result.notes
    end
  end
end