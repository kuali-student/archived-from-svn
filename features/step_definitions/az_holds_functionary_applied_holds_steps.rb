And(/^I apply a hold for expiration to a student$/) do
  @applied_hold = create AppliedHold, :student_id => "KS-1675", :hold_issue => (make HoldIssue, :code => "ACAD05", :first_term => "201208", :term_based => true)
  @applied_hold.apply_hold
end

And(/^I find a hold$/) do
  @applied_hold = create AppliedHold, :student_id=> "KS-1675", :hold_issue => (make HoldIssue, :code => "ACAD02")
end

Then /^an expire hold authorization error message is displayed$/ do
  on ManageAppliedHold do |page|
    page.get_validation_message.should match /will not be expired as you don't have authorization to expire this hold/
  end
end

When(/^I attempt to expire that hold$/) do
  on ManageAppliedHold do |page|
    page.expire_hold("ACAD02")
  end
end

Then(/^the expired hold is no longer displayed for the student$/) do
  on(ManageAppliedHold).get_hold_by_code("ACAD05").nil?.should be_true
end







