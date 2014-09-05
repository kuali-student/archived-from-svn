When(/^I attempt to load a student by valid student Id$/) do
  @manage_applied_hold = create ManageAppliedHoldData
end

And /^the applied hold information is displayed$/ do
  on(ManageAppliedHold).applied_holds_results_rows.empty?.should be_false
end