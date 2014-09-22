When(/^I apply a hold to student by completing the required information needed for applied hold$/) do
  @applied_hold = create AppliedHold, :student_id => "KS-6509", :code =>"ACAD03", :apply_hold => true
end

Then(/^the applied hold exists in the student applied hold result list$/) do
  on ManageAppliedHold do |page|
    page.loading.wait_while_present
    page.get_applied_hold_by_code(@applied_hold.code).nil?.should be_false
  end
end
When(/^I apply a term based hold to student by completing the required information needed for applied hold$/) do
  @applied_hold = create AppliedHold, :student_id => "KS-6509", :code =>"ADMIS03",  :first_term=>"201208",:apply_hold => true, :find_code_by_lookup => true
end

And(/^I search for a hold code$/) do
  @applied_hold = create AppliedHold, :student_id => "KS-2016", :find_code_by_lookup => true
end

Then /^the selected hold code is populated$/ do
  on(ApplyHold).hold_code_input.value.should == @applied_hold.code
end

And(/^I apply the hold to a student$/) do
  @applied_hold = create AppliedHold, :student_id=> "KS-2032", :code => @hold_issue.code, :apply_hold => true,
                                      :find_code_by_lookup => true
end