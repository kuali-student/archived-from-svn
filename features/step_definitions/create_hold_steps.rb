When(/^I create a hold by completing the required information needed$/) do
  @manage_hold = make ManageHoldData, :hold_name => "Academic Advising Issue 88", :hold_code => "AAI88",
                     :hold_description => "AFT Tests Create", :hold_category => "Academic Advising Issue"
  @create_hold_data = create CreateEditHoldData, :parent => @manage_hold
end


And(/^the hold exists in the hold catalog$/) do
  @manage_hold.create
  on ManageHold do |page|
    page.loading.wait_while_present
    page.get_hold_name_and_description(@manage_hold.hold_name, @manage_hold.hold_description).nil?.should be_false
  end
end

When(/^I attempt to create a duplicate hold entry$/) do
  @manage_hold = make ManageHoldData, :hold_name => "Academic Advising Issue (Duplicate)", :hold_code => "AAI99",
                      :hold_category => "Academic Advising Issue", :hold_description => "AFT Test Duplicate"
  @create_hold_data_duplicate = create CreateEditHoldData, :parent => @manage_hold

  @create_hold_data_duplicate.create
end

Then(/^a duplicate check message is displayed$/) do
  on(CreateHold).get_hold_duplicate_error_message.should match /Hold Code: Hold Code already exists/
end
When(/^I create a hold with authorizing organization for apply as well as expire$/) do
  @manage_hold = make ManageHoldData, :hold_name =>"Academic Advising Issue 89" ,  :hold_code=>"Acad89", :hold_category=>"Academic Advising Issue" , :hold_description=>"AFT Tests Create", :defer_save=>false
  @create_hold_data = create CreateEditHoldData, :parent => @manage_hold
  on CreateHold do |page|
    page.hold_add_org
    page.hold_auth_find_btn(1)
    page.loading.wait_while_present
    page.hold_popup_search
    page.hold_popup_table_select(2)
    page.hold_auth_apply(1)
    page.hold_add_org
    page.hold_auth_find_btn(2)
    page.loading.wait_while_present
    page.hold_popup_search
    page.hold_popup_table_select(3)
    page.hold_auth_expire(2)
    page.hold_save
  end
end

Then(/^the hold is displayed in the catalog with the created authorizations$/) do
  @manage_hold = create ManageHoldData, :hold_name=> "Academic Advising Issue 89", :hold_code=> "Acad89"
  on ManageHold do |page|
    page.loading.wait_while_present
    @manage_hold.edit

  end
  on CreateHold do |page|
    page.auth_org_rows("Graduate Studies").nil?.should be_false
    page.auth_org_rows("Ctr Study & Resp to Terrorism").nil?.should be_false
  end

end


When(/^I create a hold with authorizing organization without apply and expire permission$/) do
  @manage_hold = make ManageHoldData, :hold_name =>"Academic Advising Issue 90" ,  :hold_code=>"Acad90", :hold_category=>"Academic Advising Issue" , :hold_description=>"AFT Tests Create", :defer_save=>false
  @create_hold_data = create CreateEditHoldData, :parent => @manage_hold
  on CreateHold do |page|
    page.hold_add_org
    page.hold_auth_find_btn(1)
    page.loading.wait_while_present
    page.hold_popup_search
    page.hold_popup_table_select(2)
    page.hold_add_org
    page.hold_auth_find_btn(2)
    page.loading.wait_while_present
    page.hold_popup_search
    page.hold_popup_table_select(3)
    page.hold_save
  end
end

Then(/^a permission message is displayed$/) do
  on CreateHold do |page|
    result_error = page.get_hold_error_message
    result_error.should match /At least one permission must be selected for each organization./
  end
end

