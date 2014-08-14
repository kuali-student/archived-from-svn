Given /^I am logged in as admin$/ do
  log_in "admin", "admin"
end

Given /^I am logged in as a Schedule Coordinator/ do
  log_in "martha", "martha"
end

Given /^I am logged in as a Student/ do
  log_in "student", "student"
end

Given /^I am logged in as a Department Schedule Coordinator$/ do
  log_in "carol", "carol"
end

Given /^I log out$/ do
  log_out
end

Then /^I am on the Kuali Student home page$/ do
  on KSFunctionalHome do |page|
    page.enrollment_link.present?.should be_true
  end
end
