When(/^I search for a hold with a valid hold code$/) do
  @manage_hold = create HoldIssueObject, :code => "FIN01"
  @manage_hold.manage
end

Then(/^a hold matching that code is displayed$/) do
  on ManageHold do |page|
    page.loading.wait_while_present
    page.get_hold_code(@manage_hold.code).nil?.should be_false
  end
end

When(/^I search for a hold that doesn't exist$/) do
  @manage_hold = (make HoldIssueObject, :code => "Hold does not exist")
  @manage_hold.manage
end

Then(/^no search results are displayed$/) do
  on ManageHold do |page|
    page.loading.wait_while_present
    page.manage_hold_results_table.exists?.should be_false
  end
end

And(/^I edit that hold by adding an owning organization$/) do
  @manage_hold.edit
  on CreateHold do |page|
    page.loading.wait_while_present
    page.find_owning_org("OPS-Office of Professional Studies")
    page.save
  end
end

Then(/^the hold is displayed in the catalog with the updated organization$/) do
  on(ManageHold).get_hold_org("Professional Studies").nil?.should be_false
end