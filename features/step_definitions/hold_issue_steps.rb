When(/^I search for a hold issue$/) do
  @hold_issue = make HoldIssue, :code => "ACAD09"
  @hold_issue.manage
end

Then(/^a hold matching that code is displayed$/) do
  on ManageHoldIssue do |page|
    page.loading.wait_while_present
    page.get_hold_code(@hold_issue.code).nil?.should be_false
  end
end

When(/^I search for a hold that doesn't exist$/) do
  @hold_issue = make HoldIssue, :code => "Hold does not exist"
end

Then(/^no search results are displayed$/) do
  @hold_issue.manage
  on ManageHoldIssue do |page|
    page.loading.wait_while_present
    page.manage_hold_results_table.exists?.should be_false
  end
end

When(/^I search for a hold with a valid hold code$/) do
  @hold_issue = create HoldIssue
end

And(/^I edit that hold by adding an owning organization$/) do
  @hold_issue.edit :navigate_to_page => true, :owning_org_abbr => "Professional Studies"
end

Then(/^the hold is displayed in the catalog with the updated organization$/) do
  on(ManageHoldIssue).get_hold_org(@hold_issue.owning_org_abbr).nil?.should be_false
end

When(/^I create a hold by completing the required information needed$/) do
  @hold = create HoldIssue
end

And(/^the hold exists in the hold catalog$/) do
  @hold.manage
  on ManageHoldIssue do |page|
    page.loading.wait_while_present
    page.get_hold_code(@hold.code).nil?.should be_false
  end
end

When(/^I attempt to create a duplicate hold entry$/) do
  @hold = create HoldIssue, :name => "Academic Advising Issue (Duplicate)"

  @hold.create
end

Then(/^a duplicate check message is displayed$/) do
  on(HoldIssueCreateEdit).get_duplicate_error_message.should match /Hold Code: Hold Code already exists/
end

When(/^I create a hold with authorizing organization for apply as well as expire$/) do
  auth_orgs = []
  auth_orgs << (make HoldIssueAuthorisingOrg, :auth_org => "Graduate Studies", :auth_expire => false)
  auth_orgs << (make HoldIssueAuthorisingOrg, :auth_org => "Ctr Study & Resp to Terrorism", :auth_apply => false)
  @hold = create HoldIssue, :authorising_orgs => auth_orgs
end

Then(/^the hold is displayed in the catalog with the created authorizations$/) do
  @hold.manage
  on ManageHoldIssue do |page|
    page.loading.wait_while_present
    page.get_hold_code(@hold.code).nil?.should be_false
  end

  @hold.edit :defer_save => true
  on HoldIssueCreateEdit do |page|
    page.auth_org_rows(@hold.authorising_orgs[0].auth_org).nil?.should be_false
    page.auth_org_rows(@hold.authorising_orgs[1].auth_org).nil?.should be_false
  end

end

When(/^I create a hold with authorizing organization without apply and expire permission$/) do
  auth_orgs = []
  auth_orgs << (make HoldIssueAuthorisingOrg, :auth_org => "Graduate Studies", :auth_expire => false, :auth_apply => false)
  num = rand(999)
  @hold = create HoldIssue, :name => "Academic Advising Issue #{num}", :code => "ACAD#{num}",
                 :category => "Academic Progress Issue", :authorising_orgs => auth_orgs
end

Then(/^a permission error message is displayed$/) do
  on HoldIssueCreateEdit do |page|
    result_error = page.get_error_message
    result_error.should match /At least one permission must be selected for each organization/
  end
end

Given(/^there exists a hold that does not maintain history$/) do
  @hold_issue = create HoldIssue
end

Given(/^there exists a hold that maintains history$/) do
  @hold_issue = create HoldIssue, :hold_history => true
end

Given /^there exists a term based hold issue$/ do
  @hold_issue = create HoldIssue, :term_based => true, :first_term => "201208", :last_term => "201301"
end

Given(/^there exists a hold with a? (?:first applied date|last applied date)$/) do
  @hold_issue = create HoldIssue, :last_applied_date => tomorrow[:date_w_slashes]
end

Given(/^there exists a hold issue$/) do
  @hold_issue = create HoldIssue
end