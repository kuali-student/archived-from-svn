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
  on(ManageAppliedHold).get_hold_by_code( @applied_hold.code).text.should match /#{@applied_hold.name}/
end

When(/^I applied a hold, that doesn't maintain history, to a student$/) do
  @manage_hold = create HoldIssue, :name => "Academic Advising Issue", :code => "AAI",
                                   :category => "Academic Progress Issue",
                                   :description => "Student blocked from registration. Contact Office of the Registrar at 123-456-7890.",
                                   :hold_history => false
  @applied_hold = create AppliedHold, :student_id=> "KS-2058", :code => @manage_hold.code, :apply_hold => true
end

And(/^I expire that hold$/) do
  @applied_hold.expire
end

Then(/^the hold no longer displayed for the student$/) do
  on(ManageAppliedHold).get_holds_states(@manage_hold.code, "Released").nil?.should be_true
end

When(/^I applied a hold, that maintains history, to a student$/) do
  @manage_hold = create HoldIssue, :name => "Academic Advising Issue", :code => "AAI",
                        :category => "Academic Progress Issue",
                        :description => "Student blocked from registration. Contact Office of the Registrar at 123-456-7890.",
                        :hold_history => true
  @applied_hold = create AppliedHold, :student_id=> "KS-2069", :code => @manage_hold.code, :apply_hold => true
end

Then(/^the expired hold is displayed for the student$/) do
  on(ManageAppliedHold).get_holds_states(@manage_hold.code, "Expired").nil?.should be_false
end