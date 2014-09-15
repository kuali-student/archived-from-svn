When(/^I apply a hold to student by completing the required information needed for applied hold$/) do

end

Then(/^the applied hold exists in the student applied hold list$/) do

end

And(/^I search for a hold code$/) do
  @applied_hold = create AppliedHold, :student_id => "KS-2016", :find_code_by_lookup => true
end

Then /^the selected hold code is populated$/ do
  on(ApplyHold).hold_code_input.value.should == @applied_hold.code
end