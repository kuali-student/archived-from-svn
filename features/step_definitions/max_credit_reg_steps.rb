When /^I add courses to my registration cart that would exceed the spring term credit limit$/ do
  # Spring (& Fall) credit limit is 20
  # TODO: first make sure user's schedule is clear (using REST call in KSENROLL-13175)
  # then add six 3-credit courses and one 4-credit (last one added to cart should fail)
  reg_group_code = "1001"
  term_code = "201101"
  term_descr = "Spring 2011"

  # Clear cart and schedule
  @restResponse = make RegRestUtility
  @restResponse.clear_cart_and_schedule(term_code)

  for i in (0..5)
    @reg_request_engl = make RegistrationRequest, :student_id=>"student2",
                             :term_code=>term_code,
                             :term_descr=>term_descr,
                             :course_code=>"ENGL301",
                             :reg_group_code=>reg_group_code
    @reg_request_engl.create
    reg_group_code.next!
  end
  # Register for the first six separately, per dev recommendation TODO: register for all at once
  @reg_request_engl.register
  sleep 5

  course_options = (make CourseOptions, :credit_option => "4.0")
  @reg_request = make RegistrationRequest, :student_id=>"student2",
                      :term_code=>term_code,
                      :term_descr=>term_descr,
                      :course_code=>"WMST469G",
                      :reg_group_code=>"1001", :course_options => course_options, :modify_course_options => true
  @reg_request.create
end

When /^I add courses to my registration cart that would exceed the summer term credit limit$/ do
  # Summer credit limit is 8
  # TODO: first make sure user's schedule is clear (using REST call in KSENROLL-13175)
  # then add two 3-credit courses and one 2.5-credit (last one added to cart should fail)
  reg_group_code = "1003"
  term_code = "201205"
  term_descr = "Summer I 2012"

  # currently the cart processes in reverse order. so, if we want to get a max credit
  # error on WMST496M, it needs to be added first so that it's processed last
  course_options = (make CourseOptions, :credit_option => "2.5")
  @reg_request = make RegistrationRequest, :student_id=>"student2",
                      :term_code=>term_code,
                      :term_descr=>term_descr,
                      :course_code=>"WMST469M",
                      :reg_group_code=>"1001", :course_options => course_options, :modify_course_options => true
  @reg_request.create

  # now add the 2 remaining items to the cart.
  for i in (0..1)
    reg_group_code.next!
    @reg_request_engl = make RegistrationRequest, :student_id=>"student2",
                             :term_code=>term_code,
                             :term_descr=>term_descr,
                             :course_code=>"ENGL101",
                             :reg_group_code=>reg_group_code,
                             :course_has_options=>false
    @reg_request_engl.create
  end
end

Then /^there is a message indicating that I have registered for a credit amount over the (\w+) term credit limit$/ do |term|
  term_max = case term
               when "spring" then 20
               when "summer" then 8
             end
  on RegistrationCart do |page|
    page.course_code(@reg_request.course_code,@reg_request.reg_group_code).wait_until_present
    page_status = page.result_status(@reg_request.course_code,@reg_request.reg_group_code)
    page_status.should =~ /maximum credit limit \(#{term_max}/i
  end
end

Then /^I cannot register for another course$/ do
  # another 4-credit course
  @reg_request_phys = make RegistrationRequest, :student_id=>"student2",
                           :term_code=>"201101",
                           :term_descr=>"Spring 2011",
                           :course_code=>"PHYS121",
                           :reg_group_code=>"1001"
  @reg_request_phys.create

  @reg_request_phys.register
  sleep 3
  on RegistrationCart do |page|
    page.course_code(@reg_request_phys.course_code,@reg_request_phys.reg_group_code).wait_until_present
    page.course_code(@reg_request_phys.course_code,@reg_request_phys.reg_group_code).text.should match /failed/i
  end
end

And /^I attempt to register for courses that would exceed the summer term credit limit$/ do
  steps %{
    When I add courses to my registration cart that would exceed the summer term credit limit
    And I attempt to register for the courses
  }
end


When /^I remove a course from my schedule$/ do
  visit StudentSchedule
  @reg_request_engl.remove_course("schedule")
end

Then /^I am able to successfully register for the failed course$/ do
  @reg_request.register :do_navigation => true
  steps %{
    And there is a message indicating successful registration
  }
end