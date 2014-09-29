When(/^I add a course from the bookmark gutter to the planned section$/) do
  course_search_result = make CourseSearchResults,  :course_code => "ENGL101",
                              :planned_term => "2014Summer1",
                              :term => "Summer I 2014"
  @BookmarkObject = make BookmarkObject, :course_search_result => course_search_result
  @BookmarkObject.add_course_bookmark_gutter_to_plan
end

Then(/^the course should be successfully added$/) do
  @BookmarkObject.verify_added_course_planned
end
#------------------------------
When(/^I add a course from the bookmark gutter to the backup section$/) do
  course_search_result = make CourseSearchResults,  :course_code => "ENGL233",
                              :planned_term => "2014Summer1",
                              :term => "Summer I 2014"
  @BookmarkObject = make BookmarkObject, :course_search_result => course_search_result
  @BookmarkObject.add_course_bookmark_gutter_to_backup
end

Then(/^the course is successfully added$/) do
  @BookmarkObject.verify_added_course_backup
end
#------------------------------
When(/^I add a course from the bookmark page to the planned section$/) do
  course_search_result = make CourseSearchResults,  :course_code => "ENGL101",
                              :planned_term => "2014Summer1",
                              :term => "Summer I 2014"
  @BookmarkObject = make BookmarkObject, :course_search_result => course_search_result
  @BookmarkObject.add_course_bookmark_page_to_plan
end

Then(/^the course should be added$/) do
  @BookmarkObject.verify_added_course_planned
end
#------------------------------
When(/^I add a course from the bookmark page to the backup section$/) do
  course_search_result = make CourseSearchResults,  :course_code => "ENGL222",
                              :planned_term => "2014Summer1",
                              :term => "Summer I 2014"
  @BookmarkObject = make BookmarkObject, :course_search_result => course_search_result
  @BookmarkObject.add_course_bookmark_page_to_backup
end

Then(/^the course is added$/) do
  @BookmarkObject.verify_added_course_backup
end
#------------------------------
When(/^I try to add a duplicate course to term from the bookmark section$/) do
  course_search_result = make CourseSearchResults,  :course_code => "ENGL101",
                              :planned_term => "2014Summer1",
                              :term => "Summer I 2014"
  @BookmarkObject = make BookmarkObject, :course_search_result => course_search_result
  @BookmarkObject.add_duplicate_course
end

Then(/^the term is showing as planned$/) do
  @BookmarkObject.verify_duplicate_course_planned
end