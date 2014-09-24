When /^I attempt to register for two courses whose times conflict$/ do
  steps %{
   When I add a HIST2 course offering to my registration cart
   And I register for the course
  }
  # Save the first course reg request, because will use it later (to drop course)
  @reg_request_initial = @reg_request
  steps %{
   Then I add a HIST3 course offering to my registration cart
   And I register for the course
   }
end

When /^I attempt to register for a PHYS course and an ENGL course whose times conflict$/ do
  steps %{
    When I add a PHYS2 course offering to my empty registration cart
    And I register for the course
    Then there is a message indicating successful registration
  }
  # Save the first course reg request, because will use it later (to drop course)
  @reg_request_initial = @reg_request
  steps %{
    When I add an ENGL5 course offering to my registration cart
    And I register for the course
    Then there is a message indicating that registration failed
  }
end

And /^there is a message indicating a time conflict$/ do
  on RegistrationCart do |page|
    page_status = page.result_status(@reg_request.course_code, @reg_request.reg_group_code)
    page_status.should =~ /time conflict \(#{@reg_request_initial.course_code}\)/i
  end
end

And /^I am able to edit the failed course$/ do
  on RegistrationCart do |page|
    @reg_request.course_options.grading_option = "Audit"
    @reg_request.edit_course_options :grading_option => @reg_request.course_options.grading_option,
                                     :context => "cart"
    page.course_info_div(@reg_request.course_code,@reg_request.reg_group_code).wait_until_present
    page.grading_option_badge(@reg_request.course_code, @reg_request.reg_group_code).wait_until_present
    page.grading_option(@reg_request.course_code, @reg_request.reg_group_code).should include "#{@reg_request.course_options.grading_option}"
  end
end

When /^I remove the PHYS course from my schedule$/ do
  on RegistrationCart do |page|
    page.menu
    page.schedule_link.wait_until_present
    page.schedule_link.click
  end
  @reg_request_initial.remove_course("schedule")
end

And /^I register for the ENGL course$/ do

  # go to Cart, register, then return to Schedule for next step
  on StudentSchedule do |page|
    page.menu
    page.cart_link.wait_until_present
    page.cart_link.click
  end
  @reg_request.register
  sleep 3
  on RegistrationCart do |page|
    page.menu
    page.schedule_link.wait_until_present
    page.schedule_link.click
  end
end

And /^test cleanup - remove the first course from the schedule$/ do
  @reg_request_initial.remove_course("schedule")
end