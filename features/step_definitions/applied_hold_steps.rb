When(/^I apply a hold to student by completing the required information$/) do
  @applied_hold = create AppliedHold, :student_id => "KS-2062", :hold_issue => (make HoldIssue, :code => "ADMIS02")
  @applied_hold.apply_hold :effective_term => "201301", :term_based => true
end

Then(/^the hold exists for the student with an effective date$/) do
  on ManageAppliedHold do |page|
    page.loading.wait_while_present
    page.get_active_applied_hold_by_code(@applied_hold.hold_issue.code).text.should match /#{@applied_hold.state}.*#{@applied_hold.effective_date}/m
  end
end

When(/^I apply a term based hold to student by completing the required information$/) do
  @applied_hold = create AppliedHold, :student_id => "KS-2063", :find_code_by_lookup => true,
                         :hold_issue => (make HoldIssue, :code => "ADMIS03", :first_term => "201208", :term_based => true)
  @applied_hold.apply_hold
end

Then /^the hold exists for the student with an effective start term$/ do
  on ManageAppliedHold do |page|
    page.loading.wait_while_present
    page.get_active_applied_hold_by_code(@applied_hold.hold_issue.code).text.should match /#{@applied_hold.state}.*#{@applied_hold.effective_date}.*#{@applied_hold.effective_term}/m
  end
end

And(/^I apply the hold to a student$/) do
  @applied_hold = create AppliedHold, :student_id=> "KS-2032", :hold_issue => @hold_issue, :find_code_by_lookup => true
  @applied_hold.apply_hold
end

When(/^I attempt to load a student by valid student Id$/) do
  @applied_hold = create AppliedHold, :hold_issue => (make HoldIssue, :name => "Student last attended in ...", :code => "ACAD08")
end

Then(/^the student information is displayed$/) do
  on(ManageAppliedHold).get_student_info.should match /#{@applied_hold.student_name} \(#{@applied_hold.student_id.upcase}\)/
end

When /^I attempt to load a student by invalid studentId$/ do
  @applied_hold = create AppliedHold, :student_id=> "student1", :hold_issue => (make HoldIssue)
end

Then /^a validation error is displayed stating "([^"]+)"$/ do |exp_msg|
  on(ManageAppliedHold).get_student_term_error_msg("student").should match /#{exp_msg}/
end

And /^the applied hold information is displayed$/ do
  on(ManageAppliedHold).get_active_applied_hold_by_code(@applied_hold.hold_issue.code).text.should match /#{@applied_hold.hold_issue.name}/
end

When(/^I expire that hold$/) do
  @applied_hold.expire_hold :expiration_date => right_now[:date_w_slashes]
end

When(/^I delete that hold$/) do
  @applied_hold.delete_hold
end

Then(/^the hold is no longer displayed for the student$/) do
  on(ManageAppliedHold).get_active_applied_hold_by_code(@hold_issue.code).nil?.should be_true
end

Then(/^the expired hold is displayed for the student$/) do
  on(ManageAppliedHold).get_applied_hold_by_code(@applied_hold.hold_issue.code).text.should match /#{@applied_hold.hold_issue.code}.*#{@applied_hold.state}/m
end

Then(/^the expired hold should still be active$/) do
  on(ManageAppliedHold).get_active_applied_hold_by_code(@hold_issue.code).text.should match /#{@applied_hold.hold_issue.code}.*Active.*#{@applied_hold.expiration_date}/m
end

Then(/^the deleted hold is no longer displayed for the student$/) do
  on(ManageAppliedHold).get_active_applied_hold_by_code(@hold_issue.code).nil?.should be_true
end

When /^I attempt to expire the hold with an expiration term earlier than the effective term$/ do
  @applied_hold.expire_hold :exp_success => false, :expiration_term => "201201", :expiration_date => right_now[:date_w_slashes]
end

Then /^an earlier than applied effective term error message is displayed$/ do
  on(ExpireAppliedHold).get_expire_error_msg.should match /Applied expiration term should not be earlier than Applied effective Term: #{@hold_issue.first_term}/m
end

When /^I expire the hold with an expiration term that is after the effective term$/ do
  @applied_hold.expire_hold :expiration_term => @hold_issue.last_term, :expiration_date => right_now[:date_w_slashes]
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

When(/^I attempt to apply the hold where the effective date is before the first applied date$/) do
  @applied_hold = create AppliedHold, :student_id=> "KS-2032", :find_code_by_lookup => true, :hold_issue => @hold_issue
  @applied_hold.apply_hold :effective_date => last_year[:date_w_slashes]
end

Then(/^an effective date error message is displayed$/) do
  on(ApplyHold).get_apply_error_msg.should match /Applied effective date should not be earlier.*#{@hold_issue.first_applied_date}/
end

Then(/^an invalid effective date range message is displayed$/) do
  on(ApplyHold).get_apply_error_msg.should match /Has invalid date range\. #{@applied_hold.effective_date} must be before the Hold's Last Applied Date #{@hold_issue.last_applied_date}/m
end

Then(/^the end term defaults to the last applied term$/) do
  on(ManageAppliedHold).get_active_applied_hold_by_code(@hold_issue.code).text.should match /#{@hold_issue.code}.*#{@hold_issue.last_term}/m
end

Then(/^the end date defaults to the last applied date$/) do
  on(ManageAppliedHold).get_active_applied_hold_by_code(@hold_issue.code).text.should match /#{@hold_issue.code}.*#{@hold_issue.last_applied_date}/m
end

When(/^I attempt to apply the hold where the effective date is after the last applied date$/) do
  @applied_hold = create AppliedHold, :student_id=> "KS-2032", :find_code_by_lookup => true, :hold_issue => @hold_issue
  @applied_hold.apply_hold :effective_date => in_a_year[:date_w_slashes]
end

When(/^I attempt to apply the hold where the effective term is before the first applied term$/) do
  @applied_hold = create AppliedHold, :student_id=> "KS-2032", :find_code_by_lookup => true, :hold_issue => @hold_issue
  @applied_hold.apply_hold :effective_term => "201101"
end

When(/^I attempt to apply the hold where the effective term is after the last applied term$/) do
  @applied_hold = create AppliedHold, :student_id=> "KS-2032", :find_code_by_lookup => true, :hold_issue => @hold_issue
  @applied_hold.apply_hold :effective_term => "201508"
end

Then(/^an effective term error message is displayed$/) do
  on(ApplyHold).get_apply_error_msg.should match /Applied effective term should not be earlier.*#{@hold_issue.first_term}/
end

Then(/^an invalid effective term message is displayed$/) do
  on(ApplyHold).get_apply_error_msg.should match /Applied effective term should not be later.*#{@hold_issue.last_term}/
end

When(/^I attempt to apply the hold using an invalid term$/) do
  @applied_hold = create AppliedHold, :student_id=> "KS-2032", :find_code_by_lookup => true, :hold_issue => @hold_issue
  @applied_hold.apply_hold :effective_term => "101101"
end

Then(/^an invalid term error message is displayed$/) do
  on(ApplyHold).get_apply_error_msg.should match /No term defined for code: #{@applied_hold.effective_term}/
end

Given /^I have applied a Hold Issue to a student$/ do
  @applied_hold = create AppliedHold, :student_id => "KS-2101",  :find_code_by_lookup => true,
                                      :hold_issue => (make HoldIssue, :code => "ACAD07")
  @applied_hold.apply_hold :term_based => true, :effective_term => "201401"
end

When(/^I have applied a registration hold to a student$/) do
  @applied_hold = create AppliedHold, :student_id => "KS-2094", :hold_issue => (make HoldIssue, :code => "ADV01")
  @applied_hold.apply_hold :effective_term => "201401", :term_based => true
end

When(/^I load a student to view the hold code information$/) do
  @applied_hold = create AppliedHold, :hold_issue => (make HoldIssue, :category => "Student Record", :code => "ACAD08")

  on(ManageAppliedHold).hold_code_info( @applied_hold.code)
end

Then(/^the inquiry view displays the hold catalog information$/) do
  on(ManageAppliedHold).get_inquiry_holdissue_info.should match /#{@applied_hold.code}.*#{@applied_hold.category}/
end
