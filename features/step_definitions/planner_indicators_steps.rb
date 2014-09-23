
When(/^I search for a course that in not in the list of published schedule of classes$/) do
  @course_search_result = make CourseSearchResults, :course_code => "BSCI121",:planned_term=>"2014Spring",:state=>"planned",:term=> "Spring 2014"
  @course_search_result.course_search

end


Then(/^the course should indicate that it is not offered for the term$/) do
 on CoursePlannerPage do |page|
   page.course_indicator(@course_search_result.course_code,@course_search_result.planned_term,@course_search_result.state)
   page.indicator_popup.should match "#{@course_search_result.course_code} is not scheduled"
 end
end



When(/^I navigate to the planner page to view a planned course that has retired with a past expiration date$/) do
  @course_search_result = make CourseSearchResults, :course_code => "PHYS263",:planned_term=>"2014Spring",:state=>"planned",:term=> "Spring 2014"
  @course_search_result.course_search
  navigate_to_course_planner_home

end



When(/^I navigate to the planner page to view a course planned for suspended registration groups$/) do
  @course_search_result = make CourseSearchResults, :course_code => "CHEM271",:planned_term=>"2014Spring",:state=>"planned",:term=> "Spring 2014",:message_status=>"Section 1012 has been suspended."
  @course_search_result.course_search
  navigate_to_course_planner_home
end


  Then(/^the course should indicate that the registration group has been suspended or cancelled$/) do
    on CoursePlannerPage do |page|
    page.course_indicator(@course_search_result.course_code,@course_search_result.planned_term,@course_search_result.state)
    page.indicator_popup.should match @course_search_result.message_status
    end
  end

When(/^I navigate to the planner page to view a course planned for cancelled course offering$/) do
  @course_search_result = make CourseSearchResults, :course_code => "ENGL388",:planned_term=>"2014Spring",:state=>"planned",:term=> "Spring 2014",:message_status=>"Section 1001 has been canceled."
  @course_search_result.course_search
  navigate_to_course_planner_home
end


Then(/^the course should indicate that the registration group has been cancelled$/) do
  on CoursePlannerPage do |page|
  page.course_indicator(@course_search_result.course_code,@course_search_result.planned_term,@course_search_result.state)
  page.indicator_popup.should match @course_search_result.message_status
  end

end
