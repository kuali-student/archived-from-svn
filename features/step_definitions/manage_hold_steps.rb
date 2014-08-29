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

And(/^I edit that hold by adding a hold code as well as an owning organization$/) do
  on ManageHold do |page|
    page.loading.wait_while_present
    @manage_hold.edit
    page.create_edit_hold_org_find
    page.create_edit_hold_popup_search
    page.create_edit_hold_popup_table_select(1)
    page.create_edit_hold_code_input.set "AAI01"
    page.create_edit_hold_save
  end
end

Then(/^the hold is displayed in the catalog with the updated code and organization$/) do
  on(ManageHold).get_hold_code_and_org("AAI01","Lesbian, Gay, Bi, & Trans Prog").nil?.should be_false
end