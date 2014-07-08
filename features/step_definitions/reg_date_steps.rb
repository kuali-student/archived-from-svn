And /^I attempt to register for a course in Half Fall (\d+) 2012$/ do |termHalf|
  # the user for this test (student8) is assigned a current time after the close of registration for
  # Half Fall 1, but should still be able to register for courses in Half Fall 2
  course_code = case termHalf
                  when 1 then "CHEM105"
                  when 2 then "CHEM147"
                end
  @reg_request = make RegistrationRequest,
                      :term_descr=>"Fall 2012",
                      :course_code=>course_code,
                      :reg_group_code=>"1001"
  @reg_request.create
  @reg_request.register
end

Then /^there is a message indicating that the registration period is not open$/ do
  on RegistrationCart do |page|
    page.course_code_message(@reg_request.course_code,@reg_request.reg_group_code).text.should =~ /not open/i
  end
end

When /^I attempt to display my registration cart during pre-registration$/ do
  # the user for this test (student7) is assigned a current time that falls within pre-registration period
  visit RegistrationCart do |page|
    term_descr = "Fall 2012"
    page.menu_button.wait_until_present
    page.menu
    page.wait_until {page.term_select.include? term_descr }
    page.select_term term_descr
    page.menu
  end
end

Then /^I can add and remove courses from my cart$/ do
  steps %{
    When I add a HIST2 course offering to my registration cart
    Then the course is present in my cart
    }
    # Save the first course reg request, because will use it later (to register for course)
    @reg_request_initial = @reg_request
    steps %{
    When I add a PHYS3 course offering to my registration cart
    Then the course is present in my cart
    When I remove the course from my registration cart
    Then the course is not present in my cart
    }
    @reg_request = @reg_request_initial
end
