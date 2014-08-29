When(/^I search for a hold with a valid hold name and description phrase$/) do
  @manage_hold = create ManageHoldData, :hold_name=> "Academic Advising Issue", :hold_description=> "reached 60 credits"
end

Then(/^a hold matching the name as well as the phrase is displayed$/) do
  on ManageHold do |page|
    page.loading.wait_while_present
    page.get_hold_name_and_description("Academic Advising Issue", "reached 60 credits").nil?.should be_false
  end
end

When(/^I attempt to search for a hold that doesn't exist$/) do
  @manage_hold = create ManageHoldData, :hold_name=> "Hold does not exist"
end

Then(/^no search results are displayed$/) do
  on ManageHold do |page|
    page.loading.wait_while_present
    page.get_hold_rows.empty?.should be_true
  end
end

And(/^I edit that hold by adding an owning organization$/) do
  on ManageHold do |page|
    page.loading.wait_while_present
    @manage_hold.edit
    page.create_or_edit_hold_own_org_find
    page.create_or_edit_hold_org_popup_search
    page.create_or_edit_hold_org_popup_table_select(1)
    page.create_or_edit_hold_save
  end
end

And(/^I edit that hold by changing the hold authorization$/) do
  on ManageHold do |page|
    page.loading.wait_while_present
    @manage_hold.edit
    page.create_or_edit_hold_add_org
    page.create_or_edit_hold_name_input.set("New Hold Authorization")
    page.create_or_edit_hold_save
  end
end