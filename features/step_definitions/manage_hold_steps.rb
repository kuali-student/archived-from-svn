When(/^I search for a hold with a valid hold code$/) do
  @hold_issue = create HoldIssue, :code => "AAI"
end

Then(/^a hold matching that code is displayed$/) do
  @hold_issue.manage
  on ManageHoldIssue do |page|
    page.loading.wait_while_present
    page.get_hold_code(@hold_issue.code).nil?.should be_false
  end
end

When(/^I search for a hold that doesn't exist$/) do
  @hold_issue = make HoldIssue, :code => "Hold does not exist"
end

Then(/^no search results are displayed$/) do
  @hold_issue.manage
  on ManageHoldIssue do |page|
    page.loading.wait_while_present
    page.manage_hold_results_table.exists?.should be_false
  end
end

And(/^I edit that hold by adding an owning organization$/) do
  @hold_issue.edit :navigate_to_page => true, :owning_org_abbr => "Professional Studies"
end

Then(/^the hold is displayed in the catalog with the updated organization$/) do
  on(ManageHoldIssue).get_hold_org(@hold_issue.owning_org_abbr).nil?.should be_false
end