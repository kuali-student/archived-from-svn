When(/^I navigate to Admin Registration$/) do
  @admin_reg = make AdminRegistrationData
  @admin_reg.search
end

Then /^I have access to select a student$/ do
  on(AdminRegistration).student_id_input.present?.should be_true
  on(AdminRegistration).student_term_go_button.present?.should be_true
end