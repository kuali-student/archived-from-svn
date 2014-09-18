
When(/^I search for a course that in not in the list of published schedule of classes$/) do
  @course_search_result = make CourseSearchResults, :course_code => "BSCI121",:planned_term=>"2014Spring",:state=>"planned",:term=> "Spring 2014"
  @course_search_result.course_search

end


Then(/^the course should indicate that it is not offered for the term$/) do
 on CoursePlannerPage do |page|
   page.course_indicator(@course_search_result.course_code,@course_search_result.planned_term,@course_search_result.state)
   puts "#{@course_search_result.course_code} is not scheduled for #{@course_search_result.term}"
   page.indicator_popup.should match "#{@course_search_result.course_code} is not scheduled for #{@course_search_result.term}"
 end
end