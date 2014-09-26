When(/^I apply a hold to student by completing the required information$/) do
  @applied_hold = create AppliedHold, :student_id => "KS-2049", :hold_issue => (make HoldIssue, :code => "ACAD06")
  @applied_hold.apply_hold
end

Then(/^the hold exists for the student with an effective date$/) do
  on ManageAppliedHold do |page|
    page.loading.wait_while_present
    page.get_applied_hold_by_code(@applied_hold.hold_issue.code).text.should match /#{@applied_hold.state}.*#{@applied_hold.effective_date}/m
  end
end

When(/^I apply a term based hold to student by completing the required information$/) do
  @applied_hold = create AppliedHold, :student_id => "KS-6510", :find_code_by_lookup => true,
                         :hold_issue => (make HoldIssue, :code => "ADMIS03", :first_term => "201208", :term_based => true)
  @applied_hold.apply_hold
end

Then /^the hold exists for the student with an effective start term$/ do
  on ManageAppliedHold do |page|
    page.loading.wait_while_present
    page.get_applied_hold_by_code(@applied_hold.hold_issue.code).text.should match /#{@applied_hold.state}.*#{@applied_hold.effective_date}.*#{@applied_hold.effective_term}/m
  end
end

And(/^I apply the hold to a student$/) do
  @applied_hold = create AppliedHold, :student_id=> "KS-2032", :hold_issue => @hold_issue, :find_code_by_lookup => true
  @applied_hold.apply_hold
end