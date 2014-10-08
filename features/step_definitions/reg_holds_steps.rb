And /^there is a message indicating I have a mandatory advising hold$/ do
  on RegistrationCart do |page|
    page.reg_locked_message.wait_until_present
    page.reg_locked_message.text.should =~ /Mandatory Advising/i
  end
end

Then /^there is a message in my cart indicating that I have too many registration transactions$/ do
  on RegistrationCart do |page|
    sleep 1
    page.wait_until { !page.registering_message.visible? } if page.registering_message.visible?
    page.wait_until { page.reason_message_span(@reg_request.course_code,@reg_request.reg_group_code).exists? }
    page.reason_message(@reg_request.course_code,@reg_request.reg_group_code).should =~ /Too many registration transactions/i
  end
end

Then /^there is a message on my (schedule|waitlist) indicating that I have too many registration transactions$/ do |context|
  on StudentSchedule do |page|
    page.user_message_1_span(@reg_request.course_code,@reg_request.reg_group_code,context).wait_until_present
    page.user_message_1(@reg_request.course_code,@reg_request.reg_group_code,context).should =~ /Too many registration transactions/i
  end
end

And /^I am registered for a course with variable credit and grading options$/ do
  @reg_request = make RegistrationRequest, :student_id=>"A.JANED",
                      :term_code=>"201208",
                      :term_descr=>"Fall 2012",
                      :course_code=>"CHEM699",
                      :reg_group_code=>"1001"
end

And /^I am waitlisted for a course with variable credit and grading options$/ do
  @reg_request = make RegistrationRequest, :student_id=>"A.JANED",
                      :term_code=>"201208",
                      :term_descr=>"Fall 2012",
                      :course_code=>"HIST266",
                      :reg_group_code=>"1001"
end

When /^I edit the course in my waitlist$/ do
  @reg_request.edit_course_options :grading_option => "Pass/Fail",
                                   :context => "waitlist"
end

