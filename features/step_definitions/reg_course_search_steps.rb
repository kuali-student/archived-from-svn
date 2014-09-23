When /^I search for a course with "(.*?)" text option$/ do |text|
  @course_search_result = make CourseSearch, :search_string=> text
  @course_search_result.search :navigate=>true
end

When /^I search for a WMST course and select a registration group$/ do
  steps %{
    Given I log in to student registration as student2
    * I wait for student registration login to complete
  }
  @course_search_result = make CourseSearch, :search_string=> "WMST", :course_code=> "WMST212"
  # Clear cart and schedule
  @restResponse = make RegRestUtility
  @restResponse.clear_cart_and_schedule(@course_search_result.term)

  @course_search_result.search :navigate=>true
  @course_search_result.select_course

  @course_search_result.select_ao :ao_type=>"Lecture", :ao_code=>"A"
  @course_search_result.select_ao :ao_type=>"Discussion", :ao_code=>"E"
  @course_search_result.edit :selected_section => "1002"

end

When /^I register directly for the registration group$/ do
  on CourseDetailsPage do |page|
    page.add_button_dropdown.click
    page.direct_register
    page.reg_options_continue(@course_search_result.course_code,@course_search_result.selected_section).click
    page.register_confirm_button(@course_search_result.course_code,@course_search_result.selected_section).click
  end
end

Then /^there is a message indicating successful direct registration$/ do
  on CourseDetailsPage do |page|
    sleep 2
    page.direct_register_popup_button(@course_search_result.course_code,@course_search_result.selected_section).wait_until_present
    page.direct_register_popup_course.text.should include "#{@course_search_result.course_code}"
    page.direct_register_popup_course.text.should include "#{@course_search_result.selected_section}"
    page.close_direct_register_popup(@course_search_result.course_code,@course_search_result.selected_section)
  end
end

And /^the course is in my schedule$/ do
  on(CourseDetailsPage).return_to_search
  on CourseSearchPage do |page|
    page.course_code(@course_search_result.course_code, @course_search_result.selected_section, "schedule").wait_until_present
    page.course_code(@course_search_result.course_code, @course_search_result.selected_section, "schedule").text.should_not be_nil
  end
end

Then /^courses containing "(.*?)" course codes? appear$/ do |expected|
  # mobile
  if @browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH
    on CourseSearchMobilePage do |page|
      page.all_results(CourseSearchMobilePage::COURSE_CODE).each do |course_code|
        course_code.should =~ /#{expected}/
      end
    end
  # large format
  else
    on CourseSearchPage do |page|
      results = page.results_list_courses(expected)
      for result in results
        ((result - expected.split(", ")).empty?).should == true
      end
    end
  end
end

Then /^"(.*?)" course codes? appears?$/ do |expected|
  if @browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH    # this step only implemented for mobile at present
    on CourseSearchMobilePage do |page|
      ((page.all_results(CourseSearchMobilePage::COURSE_CODE) - expected.split(", ")).empty?).should == true
    end
  end
end

Then /^courses containing "(.*?)" subject codes? appear$/ do |expected|
  if @browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH    # this step only implemented for mobile at present
    on CourseSearchMobilePage do |page|
      ((page.all_subject_codes - expected.split(", ")).empty?).should == true
    end
  end
end

When /^I search for (\w+) courses on the course search page$/ do |search_string|
  @course_search_result = make CourseSearch, :search_string => search_string
  @course_search_result.search :navigate=>true
end

When /^I sort the results by (course code|title|credits)$/ do |sort_key|
  on(CourseSearchPage).sort_results :sort_key=>sort_key
end

Then /^the course codes should be sorted in ascending order$/ do
  @course_search_result.check_sort_order_in_all_pages(:sort_key=>"course_code",:sort_order=>"A").should be_true
end

Then /^the course codes should be sorted in descending order$/ do
  @course_search_result.check_sort_order_in_all_pages(:sort_key=>"course_code",:sort_order=>"D").should be_true
end

Then /^the titles should be sorted in ascending order$/ do
  @course_search_result.check_sort_order_in_all_pages(:sort_key=>"course_title",:sort_order=>"A").should be_true
end

Then /^the titles should be sorted in descending order$/ do
  @course_search_result.check_sort_order_in_all_pages(:sort_key=>"course_title",:sort_order=>"D").should be_true
end

Then /^the credits should be sorted in ascending order$/ do
  @course_search_result.check_sort_order_in_all_pages(:sort_key=>"credits",:sort_order=>"A").should be_true
end

Then /^the credits should be sorted in descending order$/ do
  @course_search_result.check_sort_order_in_all_pages(:sort_key=>"credits",:sort_order=>"D").should be_true
end

Then /^I can view the details of the (\w+) course$/ do |course_code|
  search_page_class = (@browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH) ? CourseSearchMobilePage : CourseSearchPage
  details_page_class = (@browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH) ? CourseDetailsMobilePage : CourseDetailsPage
    on(search_page_class).select_course(course_code)
    on details_page_class do |page|
      page.details_course_description_div(course_code).wait_until_present
      page.details_course_code.should == course_code
      page.details_course_title.should =~ /Cell Biology and Physiology/i
      page.details_course_credits.should =~ /4 cr/i
      page.details_course_description(course_code).should =~ /Biochemical and physiological mechanisms/i
    end
end

When /^I select a lecture and lab$/ do
  @course_search_result.select_ao :ao_type=>"Lecture", :ao_code=>"Y"
  @course_search_result.select_ao :ao_type=>"Lab", :ao_code=>"AA"
  @course_search_result.edit :selected_section => "1026"
end

Then /^I should see only the selected lecture and lab$/ do
  page_class = (@browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH) ? CourseDetailsMobilePage : CourseDetailsPage

  on page_class do |page|
    page.selected_message.text.should match /Section(\s*)#{@course_search_result.selected_section}(\s*)/i
  end
end

When /^I add the selected lecture and lab to my registration cart$/ do
  course_options = (make CourseOptions)
  @reg_request = make RegistrationRequest, :student_id=>"student",
                      :course_code=>"BSCI330",
                      :reg_group_code=>@course_search_result.selected_section,
                      :course_options => course_options
  @reg_request.add_to_cart_from_search_details
end

Then /^I can see the selected section has been added to my cart$/ do
  if @browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH
    on(CourseDetailsMobilePage).mobile_go_to_cart
    on RegistrationCart do |page|
      page.course_code(@reg_request.course_code,@reg_request.reg_group_code).visible?.should be_true
    end
  else
    on CourseDetailsPage do |page|
      page.cart_course_code(@reg_request.course_code,@reg_request.reg_group_code).wait_until_present
      expected_text = "#{@reg_request.reg_group_code}"
      page.cart_course_code(@reg_request.course_code,@reg_request.reg_group_code).text.should match expected_text
    end
  end
end

Given /^I have added a CHEM course to my registration cart$/ do

  # Clear cart and schedule
  @restResponse = make RegRestUtility
  @restResponse.clear_cart_and_schedule("201208")

  @reg_request = make RegistrationRequest, :term_descr=>"Fall 2012",
                      :course_code=>"CHEM241",
                      :reg_group_code=>"1014"
  @reg_request.create
end

When /^I search for the same course$/ do
  @course_search_result = make CourseSearch, :search_string=>@reg_request.course_code,
                               :selected_section=>@reg_request.reg_group_code
  @course_search_result.search :search_string=>@reg_request.course_code
end

And /^I select the same lecture and discussion as in the course$/ do
  sleep 2
  if @browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH
    on(CourseSearchMobilePage).select_course(@course_search_result.search_string)
    on(CourseDetailsMobilePage).details_heading("Discussion").wait_until_present
    @course_search_result.select_ao :ao_type=>"Lecture", :ao_code=>"O"
    @course_search_result.select_ao :ao_type=>"Discussion", :ao_code=>"U"
    @course_search_result.edit :selected_section => "1014"
  else
    on(CourseSearchPage).navigate_to_course_detail_page :course_code=>@reg_request.course_code
    on CourseDetailsPage do |page|
      page.results_table("Discussion").wait_until_present
      page.toggle_ao_select("O")
      wait_until { page.details_heading("Lecture").text =~ /Selected/i }
      page.toggle_ao_select("U")
      wait_until { page.details_heading("Discussion").text =~ /Selected/i }
    end
  end
end

Then /^the Add to Cart option should change to a notice that the course is in my cart$/ do
  page_class = (@browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH) ? CourseDetailsMobilePage : CourseDetailsPage
  on page_class do |page|
    page.add_to_cart_button.present?.should == false
    page.in_cart_button.visible?.should == true
  end
end

Then /^I remove the course from my registration cart on the search page$/ do
  if @browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH
    @reg_request.remove_from_cart :navigate_to_page=>true
  else
    @reg_request.remove_from_cart_on_search
  end
end

When /^I choose the (\w+) tab for (\w+)$/ do |tab,ao_type|
  @course_search_result.select_tab :ao_type=>ao_type, :tab=>tab
end

Then /^I see (.*) in the (\w+) details for activity offering "(\w+)"$/ do |expected, tab, ao_code|
  on CourseDetailsMobilePage do |page|
    results = case tab
                when "time" then
                  "#{page.details(ao_code, 'days')} #{page.details(ao_code, 'time')}"
                when "instr" then
                  "#{page.details(ao_code, 'instructor')}"
                when "seatsLoc" then
                  "#{page.details(ao_code, 'location')} #{page.details(ao_code, 'seatsOpen')}"
                when "all" then
                  "#{page.details(ao_code, 'days')} #{page.details(ao_code, 'time')} #{page.details(ao_code, 'instructor')} #{page.details(ao_code, 'location')} #{page.details(ao_code, 'seatsOpen')}"
              end
    results.should == expected
  end
end

When /^I search for a BSCI course and select a registration group$/ do
  # first fill up the course as student2, then go on waitlist as student3
  steps %{
    Given I log in to student registration as student2
    When I add a BSCI3 course offering to my registration cart
    And I register for the course
    And the registration process has finished
    Given I log in to student registration as student3
    * I wait for student registration login to complete
  }
  @course_search_result = make CourseSearch, :search_string=> "BSCI", :course_code=> "BSCI120"
  # Clear cart and schedule
  @restResponse = make RegRestUtility
  @restResponse.clear_cart_and_schedule(@course_search_result.term)

  @course_search_result.search :navigate=>true
  @course_search_result.select_course

  @course_search_result.select_ao :ao_type=>"Discussion", :ao_code=>"B"
  @course_search_result.edit :selected_section => "1001"
end

When /^I waitlist directly for the registration group$/ do
  on CourseDetailsPage do |page|
    page.direct_waitlist
    page.reg_options_continue(@course_search_result.course_code,@course_search_result.selected_section).when_present.click
    page.register_confirm_button(@course_search_result.course_code,@course_search_result.selected_section).when_present.click
  end
end

Then /^there is a message indicating successful direct addition to waitlist$/ do
  on CourseDetailsPage do |page|
    sleep 2
    page.direct_register_popup_button(@course_search_result.course_code,@course_search_result.selected_section).wait_until_present
    page.direct_register_popup_course.text.should include "#{@course_search_result.course_code}"
    page.direct_register_popup_course.text.should include "#{@course_search_result.selected_section}"
    page.direct_waitlist_message(@course_search_result.course_code,@course_search_result.selected_section).should match /Waitlist/i
    page.close_direct_register_popup(@course_search_result.course_code,@course_search_result.selected_section)
  end
end

And /^the course is waitlisted in my schedule$/ do
  on(CourseDetailsPage).return_to_search
  on CourseSearchPage do |page|
    page.course_code(@course_search_result.course_code, @course_search_result.selected_section, "waitlist").wait_until_present
    page.course_code(@course_search_result.course_code, @course_search_result.selected_section, "waitlist").text.should_not be_nil
  end
end


When /^I search for a course in Fall 2012 and select a registration group$/ do
  @course_search_result = make CourseSearch, :search_string=> "CHEM", :course_code=> "CHEM231"
  # Clear cart and schedule
  @restResponse = make RegRestUtility
  @restResponse.clear_cart_and_schedule(@course_search_result.term)

  @course_search_result.search :navigate=>true
  @course_search_result.select_course

  @course_search_result.select_ao :ao_type=>"Lecture", :ao_code=>"A"
  @course_search_result.select_ao :ao_type=>"Discussion", :ao_code=>"E"
  @course_search_result.edit :selected_section => "1001"
  sleep 3
end