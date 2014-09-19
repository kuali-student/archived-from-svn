
When(/^I add a course from the quick add to the planned section in the planner$/) do
  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Summer1", :course_code => "ENGL206", :term=>"Summer 1 2014", :state => "planned"
  @course_search_result.course_search
  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present
  end
  on CourseSearch do |page|
    page.plan_page_click
  end
  on CoursePlannerPage do |page|
   page.planner_courses_detail_list.wait_until_present
   @course_search_result.remove_code_from_planned_backup
   page.quick_add(@course_search_result.state,@course_search_result.planned_term).wait_until_present(120)
   page.quick_add(@course_search_result.state,@course_search_result.planned_term).click
   page.course_code_quick_add.wait_until_present(60)
   page.course_code_quick_add.set @course_search_result.course_code
   page.add_to_plan_quick.click
  end
end

Then(/^I should be able to view the course in the planned section$/) do
    on CoursePlannerPage do |page|
    page.course_code_quick_add.wait_while_present(120)
    page.planner_courses_detail_list.wait_until_present(60)
    page.course_code_term(@course_search_result.planned_term, @course_search_result.course_code)==@course_search_result.course_code
  end
end


And(/^I add the same course again to the same section in the term$/) do
  on CoursePlannerPage do |page|
    page.refresh
    page.planner_courses_detail_list.wait_until_present
  page.quick_add(@course_search_result.state,@course_search_result.planned_term).click

  page.course_code_quick_add.wait_until_present(120)
  page.course_code_quick_add.set @course_search_result.course_code
  page.add_to_plan_quick.click
  end
end

Then(/^I should get a relevant exception message$/) do
  on CoursePlannerPage do |page|
     page.exception_message.exists?.should==true
  end
end

When(/^I add a course from the quick add to the backup section in the planner$/) do
  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Summer1", :course_code => "ENGL206", :term=>"Summer 1 2014", :state => "backup"
  @course_search_result.course_search
  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present
  end
  on CourseSearch do |page|
    page.plan_page_click
  end

    on CoursePlannerPage do |page|
      page.planner_courses_detail_list.wait_until_present
      @course_search_result.remove_code_from_planned_backup
      #This would change for backup
      page.quick_add(@course_search_result.state,@course_search_result.planned_term).wait_until_present(120)
      page.quick_add(@course_search_result.state,@course_search_result.planned_term).click
      page.course_code_quick_add.wait_until_present(120)
      page.course_code_quick_add.set @course_search_result.course_code
      page.add_to_plan_quick.click
    end
  end

Then(/^I should be able to view the course in the backup section$/) do
  on CoursePlannerPage do |page|
    page.course_code_quick_add.wait_while_present(120)
    page.planner_courses_detail_list.wait_until_present(60)
    #This would change for backup
    page.course_code_term_backup(@course_search_result.planned_term, @course_search_result.course_code)==@course_search_result.course_code
  end
end


And(/^I add the course again to the same backup section in the term$/) do
  on CoursePlannerPage do |page|
    page.refresh
    page.planner_courses_detail_list.wait_until_present

    #This would change for backup

    page.quick_add(@course_search_result.state,@course_search_result.planned_term).click
    page.course_code_quick_add.wait_until_present(120)
    page.course_code_quick_add.set @course_search_result.course_code
    page.add_to_plan_quick.click
  end

end


Then(/^I should get a relevant exception$/) do
  on CoursePlannerPage do |page|
    page.exception_message.exists?.should==true
  end
end