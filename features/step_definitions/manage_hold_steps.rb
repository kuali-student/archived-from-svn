When(/^I search for a hold with a valid hold code$/) do
  @manage_hold = create ManageHoldData, :hold_code=> "Still needs hold code"
end

Then(/^a hold matching the code is displayed$/) do
  on ManageHold do |page|
    page.loading.wait_while_present
    page.get_hold_code("Still needs hold code").nil?.should be_false
  end
end

When(/^I attempt to search for a hold that doesn't exist$/) do
  @manage_hold = create ManageHoldData, :hold_code=> "Still needs hold code"
end

Then(/^no search results are displayed$/) do
  on ManageHold do |page|
    page.loading.wait_while_present
    page.get_hold_rows.nil?.should be_true
  end
end

And(/^I edit that hold by changing the hold name$/) do
  on ManageHold do |page|
    page.loading.wait_while_present
  end
end