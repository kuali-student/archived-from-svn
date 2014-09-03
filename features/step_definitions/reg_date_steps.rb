And /^I attempt to register for a course in a subterm whose registration period is (open|closed)$/ do |term_reg_status|
  # the user for this test (student8) is assigned a current time after the close of registration for
  # Half Fall 1 (CHEM105), but should still be able to register for CHEM147 in Half Fall 2
  course_code = case term_reg_status
                  when "closed" then "CHEM105"
                  when "open" then "CHEM147"
                end
  @reg_request = make RegistrationRequest,
                      :term_descr=>"Fall 2012",
                      :course_code=>course_code,
                      :reg_group_code=>"1001"
  @reg_request.create
  @reg_request.register
end

Then /^there is a message indicating that the registration period is (not open|not open yet|over)$/ do |period_status|
  error_message = case period_status
                    when "not open" then "Registration is not currently open"
                    when "not open yet" then "First day of Registration is not until 8\/28\/2012"
                    when "over" then "Last day of Registration was 9\/05\/2012"
                  end
  on RegistrationCart do |page|
    sleep 1
    page.wait_until { !page.registering_message.visible? } if page.registering_message.visible?
    page.wait_until { page.reason_message_span(@reg_request.course_code,@reg_request.reg_group_code).exists? }
    page.reason_message(@reg_request.course_code,@reg_request.reg_group_code).should =~ /#{error_message}/i
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


Then /^there is a message indicating that registration is unavailable for the term$/ do
  on RegistrationCart do |page|
    page.reg_locked_message.wait_until_present
    page.reg_locked_message.text.should =~ /Registration is not currently open/i
  end
end

When /^I log in to student registration as a user configured for Fall (\d+)$/ do |year|
  user = case year.to_i
           when 2011 then "e.monicaf"
           when 2012 then "b.corab"
         end
  on RestLoginPage do |page|
    page.login_as user
  end
  puts "I am logged in to student registration as #{user}"
end

And /^I attempt to access registration for Fall 2012$/ do
  # Default term is Fall 2012 so all we need to do is visit the page
  visit RegistrationCart
end

Then /^I am able to access registration features$/ do
  on RegistrationCart do |page|
    sleep 0.5
    page.reg_locked_message.visible?.should be_false
  end
end