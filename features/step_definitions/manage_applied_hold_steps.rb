When(/^I attempt to load a student by valid student Id$/) do
  @applied_hold = create AppliedHoldData
end

Then(/^the student information is displayed$/) do
  on(ManageAppliedHold).get_student_info.should match /FAULKNER, EMILY \(#{@applied_hold.student_id.upcase}\)/
end

When /^I attempt to load a student by invalid studentId$/ do
  @applied_hold = create AppliedHoldData, :student_id=> "student1"
end

Then /^a validation error is displayed stating "([^"]+)"$/ do |exp_msg|
  on ManageAppliedHold do |page|
    page.get_student_term_error_msg("student").should match /#{exp_msg}/
  end
end

And /^the applied hold information is displayed$/ do
  on(ManageAppliedHold).applied_holds_results_rows.empty?.should be_false
end