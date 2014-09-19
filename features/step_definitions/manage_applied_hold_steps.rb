When(/^I attempt to load a student by valid student Id$/) do
  @applied_hold = make AppliedHold, :name => "Student last attended in", :code => "ACAD08"
  @applied_hold.manage
end

Then(/^the student information is displayed$/) do
  on(ManageAppliedHold).get_student_info.should match /#{@applied_hold.student_name} \(#{@applied_hold.student_id.upcase}\)/
end

When /^I attempt to load a student by invalid studentId$/ do
  @applied_hold = make AppliedHold, :student_id=> "student1"
  @applied_hold.manage
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
  @applied_hold.expire
end

When(/^I delete that hold$/) do
  @applied_hold.delete
end

Then(/^the hold no longer displayed for the student$/) do
  on(ManageAppliedHold).get_hold_by_code(@hold_issue.code).nil?.should be_true
end

Then(/^the expired hold is displayed for the student$/) do
  on(ManageAppliedHold).get_hold_by_code(@hold_issue.code).text.should match /#{@hold_issue.code}.*#{@applied_hold.state}/m
end

Then(/^the deleted hold is displayed for the student$/) do
  on(ManageAppliedHold).get_hold_by_code(@hold_issue.code).nil?.should be_true
end