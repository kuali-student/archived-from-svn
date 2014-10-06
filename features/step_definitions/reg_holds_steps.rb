And /^there is a message indicating I have a mandatory advising hold$/ do
  on RegistrationCart do |page|
    page.reg_locked_message.wait_until_present
    page.reg_locked_message.text.should =~ /Mandatory Advising/i
  end
end