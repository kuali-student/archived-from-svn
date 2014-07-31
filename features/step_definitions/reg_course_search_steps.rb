When /^I search for a course$/ do
  @course_search_result = make CourseSearchResults
  @course_search_result.course_search
end


When /^I search for a course with "(.*?)" text option$/ do |text|
  @course_search_result = make CourseSearchResults
  @course_search_result.course_search(text)
end

Then /^the course "(.*?)" appear in the search results$/ do |test_condition|
  on CourseSearchPage do |page|
    if test_condition == "should"
      page.results_list.should include @course_search_result.course_code
    else
      begin
        page.results_list.should_not include @course_search_result.course_code
      rescue Watir::Exception::UnknownObjectException
        # Implication here is that there were no search results at all.
      end
    end
  end
end


Then /^courses containing  "(.*?)" text option appears$/ do |expected|
  on CourseSearchPage do |page|
    page.results_list_courses(expected).each { |e| e.should include (expected) }
  end
end

Then /^courses containing  "(.*?)" text options appear$/ do |expected|
  on CourseSearchPage do |page|
    results = page.results_list_courses(expected)
    for result in results
      ((result-expected.split(", ")).empty?).should == true;
    end
  end
end

When /^I search for a "(.*?)" "(.*?)" by "(.*?)"$/ do |course_status,course, term_selection|
  @course_search_result = make CourseSearchResults, :course_code => course, :term_select => term_selection
  @course_search_result.course_search
end



#-------------------------------------------------------------------------------------------

When /^I search for a course on the course search page$/ do
  @course_search_result = make CourseSearchResults, :course_code => "ENGL2"
  @course_search_result.course_search
end


Then /^I should check and display results across multiple pages\.$/ do
  on CourseSearchPage do |page|
    puts page.course_code_list
  end
end

And /^the search result should match with the course description$/ do
  on CourseSearchPage do |page|
    puts page.course_description_match
  end
end

Then /^I should extract and print the course code, course title and course description for the course$/ do
  on CourseSearchPage do |page|
    page.course_description_match should be true
  end
end


When /^I search for a course on the course search page with course title$/ do
  @course_search_result = make CourseSearchResults, :search_text => "eng"
  @course_search_result.course_search_with_search_text
end


When /^I search for a course with one word"(.*?)" text option$/ do |text|
  @course_search_result = make CourseSearchResults, :search_text => text
  @course_search_result.course_search_with_search_text
end

Then /^course title or course description containing "(.*?)"text option "(.*?)" appear$/ do |text,condition|
  @course_search_result = make CourseSearchResults
  if condition == "should"
    @course_search_result.multi_text_search(text).should be_true
  else
    begin
      @course_search_result.multi_text_search(text).should_not be_true
    rescue Watir::Exception::UnknownObjectException
      # Implication here is that there were no search results at all.
    end
  end
end

When /^I search for a course with multi word"(.*?)" text option$/ do |text|
  @course_search_result = make CourseSearchResults, :search_text => text, :term_select => "All"
  @course_search_result.course_search_with_search_text

end


Then(/^course code or course title or course description containing any word of "(.*?)"text option "(.*?)" appear$/) do |expected, condition|
  @course_search_result = make CourseSearchResults
  if condition == "should"
    @course_search_result.multi_text_search(expected).should be_true
  else
    begin
      @course_search_result.multi_text_search(expected).should_not be_true
    rescue Watir::Exception::UnknownObjectException
      # Implication here is that there were no search results at all.
    end
  end
end

#------------------------------------------------------------------------------------------------------------------------------------

When /^I search for a course with "(.*?)" level option$/ do |level|
  @course_search_result = make CourseSearchResults
  @course_search_result.course_search(level)
end

Then /^only "(.*?)" level courses "(.*?)" be displayed$/ do |text, condition|
  @course_search_result = make CourseSearchResults
  if condition == "should"
    @course_search_result.check_all_results_data_for_level(text).should be_true
    puts "Test is Passed True"
  else
    begin
      @course_search_result.check_all_results_data_for_level(text).should_not be_true
    rescue Watir::Exception::UnknownObjectException
    end
  end
end

When /^I choose to see "(.*?)" records per page$/ do |per_page|
  on CourseSearchPage do |page|
    page.course_search_results_select.select per_page
    #Sleep for X seconds to wait for the js to process the change
    sleep(2)
    page.course_search_results_select.value.should == per_page
  end
end

Then /^The table header text will be "(.*?)"$/ do |header_text|
  on CourseSearchPage do |page|
    page.course_search_results_info.text.should == header_text
  end
end

Then /^There will be (.*?) pages of results with (.*?) records per page$/ do |pages, total_per_page|
  on CourseSearchPage do |page|
    page.result_pagination.span.links.size.to_s.should == pages

    #Doing size-1 here since results_table.rows.size includes the header row
    (page.results_table.rows.size-1).to_s.should == total_per_page
  end
end

Then /^Pagination controls will not be visible if there is only 1 page$/ do
  on CourseSearchPage do |page|
    #If there's only one page, no pagination controls or record# selection
    elementsPresent = true
    if "1" == page.result_pagination.span.links.size.to_s
      elementsPresent = false
    end

    page.result_pagination.visible?.should == elementsPresent
    page.course_search_results_select.visible?.should == elementsPresent
  end
end

#------------------------------------------------------------------------------------------------------------------------------------
When /^I search for "(.*?)"$/ do |text|
  @course_search_result = make CourseSearchResults, :search_text => text
  @course_search_result.course_search_with_search_text
end


Then /^"(.*?)" and courses matching at least one "(.*?)" are returned$/ do |expected_courses, expected_component|
  @course_search_result.check_all_results_data(expected_courses,expected_component).should be_true
end



When /^I sort the results by (course code|title|credits)$/ do |sort_key|
  column = case sort_key
             when "course code" then "Code"
             when "title" then "Title"
               when "credits" then "Credits"
           end
  on CourseSearchPage do |page|
    page.sort_results_by(column)
  end
end

Then /^the course codes should be sorted in ascending order$/ do
  on CourseSearchPage do |page|
    #page.code_element.wait_until_present
    @course_search_result.check_code_ascending_order_in_all_pages.should be_true
  end
  puts "Codes descending passed"
end

Then /^the course codes should be sorted in descending order$/ do
  on CourseSearchPage do |page|
    #page.code_element.wait_until_present
    @course_search_result.check_code_descending_order_in_all_pages.should be_true
  end
  puts "Codes descending passed"
end

Then /^the titles should be sorted in ascending order$/ do
  on CourseSearchPage do |page|
    #page.code_element.wait_until_present
    @course_search_result.check_title_ascending_order_in_all_pages.should be_true
  end
  puts "Titles ascending passed"
end

Then /^the titles should be sorted in descending order$/ do
  on CourseSearchPage do |page|
    #page.code_element.wait_until_present
    @course_search_result.check_title_descending_order_in_all_pages.should be_true
  end
  puts "Titles descending passed"
end

Then /^the credits should be sorted in ascending order$/ do
  on CourseSearchPage do |page|
    #page.code_element.wait_until_present
    @course_search_result.check_credits_ascending_order_in_all_pages.should be_true
  end
  puts "Credits ascending passed"
end

Then /^the credits should be sorted in descending order$/ do
  on CourseSearchPage do |page|
    #page.code_element.wait_until_present
    @course_search_result.check_credits_descending_order_in_all_pages.should be_true
  end
  puts "Credits descending passed"
end

Then /^the course Title listed should be sorted in "(.*?)"$/ do |text|
  if text == "Ascending"
    on CourseSearchPage do |page|
      page.title_element.wait_until_present
    end
    @course_search_result.check_title_ascending_order_in_all_pages.should be_true
    puts"Ascending is Passed True"
  else
    on CourseSearchPage do |page|
      page.title_element.wait_until_present
    end
    @course_search_result.check_title_descending_order_in_all_pages.should be_true
    puts "Descending is Passed True"
  end
end

#-----------------------------------------------------------------------------------------------------------------------

When /^I search for a course with "(.*?)" option$/ do |text|
  @course_search_result = make CourseSearchResults, :search_text => text
  @course_search_result.course_search_with_search_text
end

Then /^the "(.*?)" and courses matching at least one "(.*?)" are returned$/ do |expected_courses, expected_component|
  @course_search_result.check_all_results_data(expected_courses,expected_component).should be_true
end


Then /^course code or course title or course description containing any text of "(.*?)" text option are returned$/ do |expected_courses, expected_component|
  @course_search_result.check_all_results_data(expected_courses,expected_component).should be_true
end


#KSAP-1000-----------------------------------------------------------------------------------------------------------------------


When /^I search for a "(.*?)" having divisions and levels with space in the search text$/ do |text|
  @course_search_result = make CourseSearchResults, :search_text => text
  @course_search_result.course_search_with_search_text
end


Then  /^the courses containing the "(.*?)" should be displayed in logical order$/ do |text|
  @course_search_result.logical_order_sort(text).should be_true
end


