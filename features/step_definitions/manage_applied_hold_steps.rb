When(/^I attempt to load a student by valid student Id$/) do
  @applied_hold = create AppliedHold, :name => "Student last attended in", :code => "ACAD08", :hold_issue => (make HoldIssue)
end

Then(/^the student information is displayed$/) do
  on(ManageAppliedHold).get_student_info.should match /#{@applied_hold.student_name} \(#{@applied_hold.student_id.upcase}\)/
end

When /^I attempt to load a student by invalid studentId$/ do
  @applied_hold = create AppliedHold, :student_id=> "student1", :hold_issue => (make HoldIssue)
end

Then /^a validation error is displayed stating "([^"]+)"$/ do |exp_msg|
  on ManageAppliedHold do |page|
    page.get_student_term_error_msg("student").should match /#{exp_msg}/
  end
end

And /^the applied hold information is displayed$/ do
  on(ManageAppliedHold).get_hold_by_code(@applied_hold.code).text.should match /#{@applied_hold.name}/
end

When(/^I expire that hold$/) do
  @applied_hold.expire_hold
end

When(/^I delete that hold$/) do
  @applied_hold.delete_hold
end

Then(/^the hold is no longer displayed for the student$/) do
  on(ManageAppliedHold).get_hold_by_code(@hold_issue.code).nil?.should be_true
end

Then(/^the expired hold is displayed for the student$/) do
  on(ManageAppliedHold).get_hold_by_code(@hold_issue.code).text.should match /#{@hold_issue.code}.*#{@applied_hold.state}/m
end

Then(/^the deleted hold is no longer displayed for the student$/) do
  on(ManageAppliedHold).get_hold_by_code(@hold_issue.code).nil?.should be_true
end

When /^I attempt to expire the hold with an expiration term earlier than the effective term$/ do
  @applied_hold.expire_hold :exp_success => false, :expiration_term => "201201"
end

Then /^an expiration term error message is displayed stating "(.*?)"$/ do |exp_msg|
  on(ExpireAppliedHold).get_expire_error_msg.should match /#{Regexp.escape(exp_msg)} #{@hold_issue.first_term}/m
end

When /^I expire the hold with an expiration term that is after the effective term$/ do
  @applied_hold.expire_hold :expiration_term => @hold_issue.last_term
end

When /^I attempt to expire the hold with an expiration date earlier than the effective date$/ do
  @applied_hold.expire_hold :exp_success => false, :expiration_date => last_year[:date_w_slashes]
end

Then /^an invalid date range error message is displayed$/ do
  on(ExpireAppliedHold).get_expire_error_msg.should match /Has invalid date range #{@applied_hold.effective_date} - #{@applied_hold.expiration_date}/m
end

When /^I expire the hold with an expiration date that is later than the effective date$/ do
  @applied_hold.expire_hold :expiration_date => tomorrow[:date_w_slashes]
end