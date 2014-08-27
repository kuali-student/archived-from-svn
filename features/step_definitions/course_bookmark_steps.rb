
Then(/^I should see a gutter for bookmarks$/) do
 on CoursePlannerPage do |page|
   page.bookmark_gutter.exists?.should==true
 end
end



When(/^I navigate to the Planner page$/) do
  navigate_to_course_planner_home
 end


And(/^I click on View more details link$/) do

  on CoursePlannerPage do |page|
    sleep 1
 page.view_more_details.click
  end
end


Then(/^I should be able to see a page that displays the bookmarks and display the CDP overview section information$/) do
on BookmarkPage do |page|
  sleep 2
  page.bookmark_page.exists?.should==true
  page.bookmark_details.exists?.should==true
end
end


When(/^I bookmark a course$/) do

  @course_search_result = make CourseSearchResults,:course_code => "ENGL201"
  @course_search_result.course_search

  #debug code
  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present
  end

  #Search for a course
  @course_search_result.navigate_course_detail_page

  on CourseDetailPage do |page|
    sleep 2
    puts page.removebookmark.exists?
    if page.removebookmark.exists? then
      puts page.removebookmark.exists?
      else
      page.add_bookmark
      sleep 3
  #    @count_bookmark=page.count_for_bookmark.text.to_i
   #   puts @count_bookmark
    end
  end




end
Then(/^I should be able to view a link to bookmark page in the secondary navigation$/) do
  on BookmarkPage do |page|
    page.browser_secondary_nav.exists?.should be_true
  end
end

And(/^I bookmark the course$/) do
  on CourseSearch do |page|
    if page.boomark_icon_empty.exists? then
       page.bookmark_icon_empty.click
    else
      page.bookmark_icon.click
    end
  end
end

Then(/^I should be able to bookmark the course and remove the bookmark$/) do
  on CourseSearch do |page|
    if page.bookmark_icon_empty(@course_search_results.course_code).exists? then
      page.bookmark_icon_empty(@course_search_results.course_code).click
    else
      page.bookmark_icon(@course_search_results.course_code).click
    end
  end
end



Then(/^I should be able to remove the bookmark in the course details page$/) do

  on CourseDetailPage do |page|
    sleep 2
    page.removebookmark.click
    sleep 5
    page.remove_bookmark_message.exists?.should==true
    @count_bookmark=page.count_for_bookmark.text.to_i
    page.count_for_bookmark.text.to_i==@count_bookmark-1
    end
end

Then(/^I remove the bookmark$/) do
  sleep 3
  on CourseSearch do |page|
    @count_bookmark_coursesearch=page.bookmark_count_coursesearch.text.to_i
  end
    @course_search_results.clear_course_bookmark
  on CourseSearch do |page|
    @count_bookmark_coursesearch=page.bookmark_count_coursesearch.text.to_i
  end
end

Then(/^I should no longer see the bookmark against the course$/) do
    @course_search_results.set_search_entry
    on CourseSearch do  |page|
      page.star_bookmark_off.exists?.should be_true
      page.bookmark_count_coursesearch.text.to_i== @count_bookmark_coursesearch-1
    end
end



When(/^I search for a specific course on Course Search Page$/) do
  @course_search_results = make CourseSearchResults,
                                :course_code => "ENGL201" ,
                                :description=>"historical",
                                :requisite=>"None",
                                :scheduled_terms=>"SP 14",
                                :projected_terms=>"Check",
                                :gened_requirements=>"General",
                                :subject=>"English",
                                :gened_code=>"DSHU",
                                :gened_course=>"General Education: Humanities"

  @course_search_results.course_search
  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present
  end

  @course_search_results.initial_bookmark_state_clear
   #debug code

  #@course_search_results.set_search_entry

end


And(/^I bookmark that course$/) do
  @course_search_results.set_course_bookmark
end

Then(/^I should see the bookmark against the course$/) do
  @course_search_results.set_search_entry
  on CourseSearch do  |page|
    page.star_bookmark_on.exists?.should be_true
  end
end



Then(/^I should be able to remove the bookmark from the Bookmark gutter$/) do
 on  BookmarkPage do |page|
   sleep 3
   puts page.bookmark_count.text.to_i
   count=page.bookmark_count.text.to_i
   page.refresh
   page.bookmark_delete_link.wait_until_present
   page.bookmark_delete_link.click
   page.bookmark_remove_button.wait_until_present
   page.bookmark_remove_button.click
   sleep 3
   page.bookmark_count.text.to_i==count-1
 end
 end


Then(/^I should be able to remove the bookmark from the Bookmark page$/) do

  on  BookmarkPage do |page|
    sleep 3
    puts page.bookmark_count.text.to_i
    count=page.bookmark_count.text.to_i
    page.refresh
    page.bookmark_delete_link.wait_until_present
    page.bookmark_section.click
    page.bookmark_more_info.click
    page.bookmark_delete_link.click
    page.bookmark_remove_button.wait_until_present
    page.bookmark_remove_button.click
    sleep 3
    page.bookmark_count.text.to_i==count-1
   end
end