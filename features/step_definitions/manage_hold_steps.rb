When(/^I search for a hold with a valid hold code$/) do
  @manage_hold = create HoldIssue, :code => "AAI"
end

Then(/^a hold matching that code is displayed$/) do
  @manage_hold.manage
  on ManageHoldIssue do |page|
    page.loading.wait_while_present
    page.get_hold_code(@manage_hold.code).nil?.should be_false
  end
end

When(/^I search for a hold that doesn't exist$/) do
  @manage_hold = (make HoldIssue, :code => "Hold does not exist")
end

Then(/^no search results are displayed$/) do
  @manage_hold.manage
  on ManageHoldIssue do |page|
    page.loading.wait_while_present
    page.manage_hold_results_table.exists?.should be_false
  end
end

And(/^I edit that hold by adding an owning organization$/) do
  @manage_hold.edit :navigate_to_page => true, :owning_org_abbr => "Professional Studies"
end

Then(/^the hold is displayed in the catalog with the updated organization$/) do
  on(ManageHoldIssue).get_hold_org(@manage_hold.owning_org_abbr).nil?.should be_false
end