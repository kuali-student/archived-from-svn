Given(/^I am on the course information page$/) do
  on(KradCurriculum).course_information
end

Given(/^the proposal title is empty$/) do
  on(KradCourseInformation).proposal_title.set ''
end

Given(/^the course title is empty$/) do
  on(KradCourseInformation).course_title.set ''
end

When(/^I save the course proposal$/) do
  on KradCourseInformation do |page|
    page.save_and_continue
  end
end

Then(/^I should see the error message 'This page has (\d+) errors'$/) do
  on KradCourseInformation do |page|
    page.error_message.should be_visible
  end

end