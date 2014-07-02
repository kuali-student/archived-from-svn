When(/^I create a basic course proposal with Learning Objectives added using advanced search$/) do
  steps %{Given I have a basic course proposal created as Faculty}
  @course_proposal.navigate_to_lo_categories
  @course_proposal.show_find_lo_lightbox

end

Given(/^I have a basic course proposal with Learning Objectives$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I edit the Learning Objectives$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see updated Learning Objective details on the course proposal$/) do
 pending # express the regexp above with the code you wish you had
end

When(/^I delete the Learning Objectives$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should no longer see Learning Objective details on the course proposal$/) do
  pending # express the regexp above with the code you wish you had
end