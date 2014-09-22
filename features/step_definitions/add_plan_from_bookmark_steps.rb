#--------------Scenario: PL 2.0.1----------------
When(/^I add a course from the bookmark gutter to the planned section$/) do
  #search for a course
  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Summer1",
                               :course_code => "ENGL222",
                               :term => "Summer I 2014"
  @course_search_result.course_search
  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present
  end
  #clearing initial state of bookmark
  @course_search_result.initial_bookmark_state_clear
  @course_search_result.set_course_bookmark
  on CourseSearch do |page|
    page.plan_page_click
  end
  #removing course from plan or backup
  @course_search_result.remove_code_from_planned_backup

  on CoursePlannerPage do |page|
    page.term_note_button.wait_until_present(90)
    parent_id=page.add_course_bookmark_gutter(@course_search_result.course_code)
    page.add_course_bookmark_gutter_click(parent_id)
    page.add_to_plan_dialog.wait_until_present
    page.select_term_year.select @course_search_result.term
    page.text_note.set "Test"
    page.add_to_plan_quick.click
    page.add_to_plan_dialog.wait_while_present
    page.term_note_button.wait_until_present(90)
  end
end

Then(/^the course should be successfully added$/) do
  on CoursePlannerPage do |page|
    page.added_course_planned(@course_search_result.planned_term,@course_search_result.course_code).exists?.should==true
  end
end
#--------------Scenario: PL 2.0.2----------------
When(/^I add a course from the bookmark gutter to the backup section$/) do
  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Summer1",
                               :course_code => "ENGL233",
                               :term => "Summer I 2014"
  @course_search_result.course_search
  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present
  end
  #clearing initial state of bookmark
  @course_search_result.initial_bookmark_state_clear
  @course_search_result.set_course_bookmark
  on CourseSearch do |page|
    page.plan_page_click
  end
  #removing course from plan or backup
  @course_search_result.remove_code_from_planned_backup

  on CoursePlannerPage do |page|
    page.term_note_button.wait_until_present(90)
    parent_id=page.add_course_bookmark_gutter(@course_search_result.course_code)
    page.add_course_bookmark_gutter_click(parent_id)
    page.add_to_plan_dialog.wait_until_present
    page.select_term_year.select @course_search_result.term
    page.text_note.set "Test"
    page.mark_as_backup_checkbox.click
    page.add_to_plan_quick.click
    page.add_to_plan_dialog.wait_while_present
    page.term_note_button.wait_until_present(90)
  end
end

Then(/^the course is successfully added$/) do
  on CoursePlannerPage do |page|
    page.added_course_backup(@course_search_result.planned_term,@course_search_result.course_code).exists?.should==true
  end
end
#--------------Scenario: PL 2.0.3----------------
When(/^I add a course from the bookmark page to the planned section$/) do
  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Summer1",
                               :course_code => "ENGL222",
                               :term => "Summer I 2014"
  @course_search_result.course_search
  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present
  end
  #clearing initial state of bookmark
  @course_search_result.initial_bookmark_state_clear
  @course_search_result.set_course_bookmark
  on CourseSearch do |page|
    page.plan_page_click
  end
  #removing course from plan or backup
  @course_search_result.remove_code_from_planned_backup

  on CoursePlannerPage do |page|
    page.term_note_button.wait_until_present(90)
    page.bookmarks.click
    page.add_course_bookmark_page(@course_search_result.course_code).wait_until_present
    sleep 2
    parent_id=page.add_course_bookmark_header(@course_search_result.course_code)
    page.add_course_bookmark_header_click(parent_id)
    page.add_to_plan_dialog.wait_until_present
    page.select_term_year.select @course_search_result.term
    page.add_to_plan_quick.click
    page.add_to_plan_dialog.wait_while_present
    page.plan.click
    page.term_note_button.wait_until_present(90)
  end
end

Then(/^the course should be added$/) do
  on CoursePlannerPage do |page|
    page.added_course_planned(@course_search_result.planned_term,@course_search_result.course_code).exists?.should==true
  end
end
#--------------Scenario: PL 2.0.4----------------
When(/^I add a course from the bookmark page to the backup section$/) do
  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Summer1",
                               :course_code => "ENGL233",
                               :term => "Summer I 2014"
  @course_search_result.course_search
  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present
  end
  #clearing initial state of bookmark
  @course_search_result.initial_bookmark_state_clear
  @course_search_result.set_course_bookmark
  on CourseSearch do |page|
    page.plan_page_click
  end
  #removing course from plan or backup
  @course_search_result.remove_code_from_planned_backup

  on CoursePlannerPage do |page|
    page.term_note_button.wait_until_present(90)
    page.bookmarks.click
    page.add_course_bookmark_page(@course_search_result.course_code).wait_until_present
    sleep 2
    parent_id=page.add_course_bookmark_header(@course_search_result.course_code)
    page.add_course_bookmark_header_click(parent_id)
    page.add_to_plan_dialog.wait_until_present
    page.select_term_year.select @course_search_result.term
    page.mark_as_backup_checkbox.click
    page.add_to_plan_quick.click
    #page.add_to_plan_button_click
    page.add_to_plan_dialog.wait_while_present
    page.plan.click
    page.term_note_button.wait_until_present(90)
  end
end

Then(/^the course is added$/) do
  on CoursePlannerPage do |page|
    page.added_course_backup(@course_search_result.planned_term,@course_search_result.course_code).exists?.should==true
  end
end
#--------------Scenario: PL 2.0.5----------------
When(/^I try to add a duplicate course from the bookmark section$/) do
  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Summer1",
                               :course_code => "ENGL222",
                               :term => "Summer I 2014"
  @course_search_result.course_search
  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present
  end
  #clearing initial state of bookmark
  @course_search_result.initial_bookmark_state_clear
  @course_search_result.set_course_bookmark
  on CourseSearch do |page|
    page.plan_page_click
  end

  on CoursePlannerPage do |page|
    page.term_note_button.wait_until_present(90)
    parent_id=page.add_course_bookmark_gutter(@course_search_result.course_code)
    page.add_course_bookmark_gutter_click(parent_id)
    page.add_to_plan_dialog.wait_until_present
  end
end

Then(/^the term should be deactivated$/) do
  on CoursePlannerPage do |page|
    page.select_next_term_year.should include "#{@course_search_result.term} (planned)"
  end
end