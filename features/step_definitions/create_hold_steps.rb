When(/^I create a hold by completing the required information needed$/) do
  @create_HoldData = create CreateEditHoldData, :hold_name =>"Academic Advising Issue 02" ,  :hold_code=>"AAI01", :hold_category=>"Academic Advising Issue" , :hold_description=>"AFT Tests"
end
