
When(/^I search for courses with multiple prefixes in the Course Search Page$/) do
  @course_search_result = make CourseSearch,
                               :search_string => "BSCI ENGL"
  @course_search_result.search :navigate=>true
end


And /^I narrow the search results to courses with available seats$/ do
  # mobile
  if @browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH
    on CourseSearchMobilePage do |page|
      page.select_facet("avail_seats")
      @seats_avail_courses = page.seats_avail_count_number
      page.toggle_show_facets
    end
  else
    # large format
    on CourseSearchPage do |page|
      page.select_facet("avail_seats")
      @seats_avail_courses = page.seats_avail_count_number
    end
  end
end


And(/^I narrow the search results by a specific course prefix$/) do
  @course_search_result.edit :course_prefix => "ENGL"
  if @browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH
    on CourseSearchMobilePage do |page|
      page.select_facet("course_prefix",@course_search_result.course_prefix)
      page.toggle_show_facets
    end
  else
    # large format
    on(CourseSearchPage).select_facet("course_prefix",@course_search_result.course_prefix)
  end
end



Then /^I should see only courses with available seats$/ do
    # compare count displayed in the facet with actual rows displayed; add 1 for table because first row is the header
    if @browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH
      on CourseSearchMobilePage do |page|
        page.all_results(CourseSearchMobilePage::COURSE_CODE).length.should == @seats_avail_courses
      end
    else
      on CourseSearchPage do |page|
        page.results_table.rows.length.should == @seats_avail_courses + 1
      end
    end

    #page.results_table.rows[1..-1].each do |row|   Implement when details view is fully built
    #  page.row_result_link(row).click
    #  page.seats_avail.should be_true
    #  page.back_to_search_results
    #end
end


Then(/^I should see only courses with the specific course prefix$/) do
  if @browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH
    on CourseSearchMobilePage do |page|
      page.all_results(CourseSearchMobilePage::COURSE_CODE).each do |course_code|
        course_code.slice(0,4).should == "#{@course_search_result.course_prefix}"
      end
    end
  else
    on CourseSearchPage do |page|
      page.results_table.rows[1..-1].each do |row|
        page.course_prefix_by_row(row).should == "#{@course_search_result.course_prefix}"
      end
    end
  end
end


And(/^I narrow the search results by a specific course level$/) do
  @course_search_result.edit :course_level=>"400"
  if @browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH
    on CourseSearchMobilePage do |page|
      page.select_facet("course_level",@course_search_result.course_level)
      page.toggle_show_facets
    end
    # large format
  else
    on(CourseSearchPage).select_facet("course_level",@course_search_result.course_level)
  end
end

Then /^I should see only courses with the specific course level and the specific course prefix$/ do
  if @browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH
    on CourseSearchMobilePage do |page|
      page.all_results(CourseSearchMobilePage::COURSE_CODE).each do |course_code|
        course_code.slice(4,1).should == "#{@course_search_result.course_level.slice(0,1)}"
        course_code.slice(0,4).should == "#{@course_search_result.course_prefix}"
      end
    end
  else
    on CourseSearchPage do |page|
      page.results_table.rows[1..-1].each do |row|
        page.courseLevel(row).should == "#{@course_search_result.course_level.slice(0,1)}"
        page.course_prefix_by_row(row).should == "#{@course_search_result.course_prefix}"
      end
    end
  end
end

Then(/^I should see only courses with the specific course level$/) do
  if @browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH
    on CourseSearchMobilePage do |page|
      page.all_results(CourseSearchMobilePage::COURSE_CODE).each do |course_code|
        course_code.slice(4,1).should == "#{@course_search_result.course_level.slice(0,1)}"
      end
    end
  else
    on CourseSearchPage do |page|
      page.results_table.rows[1..-1].each do |row|
        page.courseLevel(row).should == "#{@course_search_result.course_level.slice(0,1)}"
      end
    end
  end
end



When /^I narrow the search results using any facet$/ do
  @course_search_result = make CourseSearch,
                               :search_string => "ENGL" ,
                               :course_level=> '300'
  @course_search_result.search :navigate=>true
  sleep 1
  if @browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH
    on CourseSearchMobilePage do |page|
      sleep 5  # the results load in the background. Give it a few seconds
      @search_results_before_facet_selection=page.all_results(CourseSearchMobilePage::COURSE_CODE)
      page.select_facet("course_level",@course_search_result.course_level)
      page.toggle_show_facets
    end
  else
    on CourseSearchPage do |page|
      sleep 5  # the results load in the background. Give it a few seconds
      @search_results_before_facet_selection=page.results_table.text
      page.select_facet("course_level",@course_search_result.course_level)
    end
  end
end



And(/^I undo the filtering performed using the specified facet$/) do
  sleep 1
  if @browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH
    on CourseSearchMobilePage do |page|
      page.clear_facet("course_level",@course_search_result.course_level)
      page.toggle_show_facets
      sleep 5  # the results load in the background. Give it a few seconds
      @search_results_after_clearing=page.all_results(CourseSearchMobilePage::COURSE_CODE)
    end
  else
    on CourseSearchPage do |page|
      page.clear_facet("course_level",@course_search_result.course_level)
      sleep 5  # the results load in the background. Give it a few seconds
      @search_results_after_clearing=page.results_table.text
    end
  end
end

Then /^I should see the courses in the search results without any filtering being applied$/ do
  @search_results_before_facet_selection.should == @search_results_after_clearing
end
