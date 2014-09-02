When(/^I create a hold by completing the required information needed$/) do
  @create_hold_data = create CreateEditHoldData, :hold_name =>"Academic Advising Issue 88" ,  :hold_code=>"AAI88", :hold_category=>"Academic Advising Issue" , :hold_description=>"AFT Tests Create"
end


And(/^the hold exists in the hold catalog$/) do
  @manage_hold = create ManageHoldData, :hold_name=> "Academic Advising Issue 88", :hold_code=>"AAI88", :hold_description=> "AFT Tests Create"
  on ManageHold do |page|
    page.loading.wait_while_present
    page.get_hold_name_and_description("Academic Advising Issue 88", "AFT Tests Create").nil?.should be_false
  end
end

When(/^I attempt to create a duplicate hold entry$/) do
  @create_hold_data_duplicate = create CreateEditHoldData, :hold_name =>"Academic Advising Issue (Duplicate)" ,  :hold_code=>"AAI99", :hold_category=>"Academic Advising Issue" , :hold_description=>"AFT Test Duplicate"
  @create_hold_data_duplicate.create

end

Then(/^a duplicate check message is displayed$/) do
  on CreateHold do |page|
    result_error = page.get_hold_duplicate_error_message
    result_error.should match /Hold Code: Hold Code already exists./
  end
end