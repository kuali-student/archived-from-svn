
When(/^I navigate to planner page$/) do
  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Spring", :course_code => "ENGL206", :term=>"Spring 2014"
  @course_search_result.course_search
  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present
  end

  #navigate to planner page
  on CourseSearch do |page|
    page.plan_page_click
  end
  on CoursePlannerPage do |page|
    page.ksap_loader_planner.wait_while_present(90)
    page.planner_courses_detail_list.wait_until_present(90)
    page.ksap.exists?.should==true
  end
end

Then(/^the relevant features of the page should be displayed$/) do
  on CoursePlannerPage do |page|
   page.ksap.exists?.should==true
   page.find_courses.exists?.should==true
   page.plan.exists?.should==true
   page.bookmarks.exists?.should==true
   page.academic_year_2014_2015.exists?.should==true
   page.right_arrow.wait_until_present
   page.right_arrow.exists?.should==true
   page.academic_year_2015_2016.exists?.should==true
   page.left_arrow.wait_until_present
   page.left_arrow.exists?.should==true
   page.print.exists?.should==true
   page.spring_2014.wait_until_present
   page.spring_2014.exists?.should==true
   page.summer_1_2014.exists?.should==true
   page.fall_2014.exists?.should==true
   page.winter_2015.exists?.should==true
   page.course_registered_term(@course_search_result.planned_term).exists?.should==true
   page.course_planned_term(@course_search_result.planned_term).exists?.should==true
   page.course_backup_term(@course_search_result.planned_term).exists?.should==true
    end
end

Then(/^I should be able to see the View more details link in the bookmark section$/) do
  on CourseSectionPage do |page|
   page.plan_link_coursesection_click
   page.ksap_loader.wait_while_present(90)
  end

  on CoursePlannerPage do |page|
   page.ksap_loader_planner.wait_while_present(90)
   page.planner_courses_detail_list.wait_until_present(90)
   page.view_more_details.exists?.should==true
  end
end

Then(/^the credit tally should exist on the credit line$/) do
  on CoursePlannerPage do |page|
   page.credit_tally.exists?.should==true
  end
end