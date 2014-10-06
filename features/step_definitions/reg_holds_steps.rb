And /^there is a message indicating I have a mandatory advising hold$/ do
  on RegistrationCart do |page|
    page.reg_locked_message.wait_until_present
    page.reg_locked_message.text.should =~ /Mandatory Advising/i
  end
end

Then /^there is a message indicating that I cannot register because I have too many registration transactions$/ do
  on RegistrationCart do |page|
    sleep 1
    page.wait_until { !page.registering_message.visible? } if page.registering_message.visible?
    page.wait_until { page.reason_message_span(@reg_request.course_code,@reg_request.reg_group_code).exists? }
    page.reason_message(@reg_request.course_code,@reg_request.reg_group_code).should =~ /Too many registration transactions/i
  end
end