Given /^There is an existing unplanned course$/ do
  navigate_to_maintenance_portal
  navigate_to_course_search_home
  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Spring", :course_code => "ENGL206"
  @course_search_result.course_search_to_planner
end

When /^I search for a course from course search$/ do
    @course_search_result = make CourseSearchResults,  :planned_term=>"2014Spring", :course_code => "ENGL206"
    @course_search_result.set_search_entry
end

When /^I add the course with notes and term to myplan$/ do
    @course_search_result.select_add_to_plan
   end


Then /^the course should appear under current term with updated notes$/ do
  on CoursePlannerPage do |page|
     page.close_popup.wait_until_present
  #***************Checking  whether the edited notes is updated*********************************************************
     page.notes_content.should == @course_search_result.notes
     page.close_popup.wait_until_present
     page.close_popup_click
     sleep 2

  #********Steps to verify, whether the course code is saved along with updated notes in the planner********************
     @course_search_result.verify_saved_course_code_notes
     page.notes_content.should == @course_search_result.notes
     page.close_popup_click

  end
end

Given /^I work on scheduled planner$/ do
     @course_search_result = make CourseSearchResults, :planned_term=>"2014Spring",:course_code => "ENGL206"
     @course_search_result.add_course_to_term
end


 When /^I edit the notes of a course under a current term$/ do
     @course_search_result = make CourseSearchResults,  :planned_term=>"2014Spring",:course_code => "ENGL206"
     @course_search_result.edit_plan_item
 end



Then  /^the course with notes appears under the term on the planner$/ do
   on CoursePlannerPage do |page|
       #*********** Checking whether the information icon exists?************
        page.info_icon(@course_search_result.planned_term, @course_search_result.course_code).exists?.should == true
        page.course_code_term_click(@course_search_result.planned_term, @course_search_result.course_code)
        page.view_course_summary_click
        page.close_popup.wait_until_present
        page.notes_content.should == @course_search_result.notes
        page.close_popup_click

     end
end

#New steps


When(/^I search for a course in the course search page$/) do
  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Summer1", :course_code => "ENGL206", :term=>"Summer I 2014"
  @course_search_result.course_search
  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present(120)
  end
end



And(/^I add the course from search to the planned section for a specific term$/) do
  on CourseSearch do |page|
    page.plan_page_click
  end

  on CoursePlannerPage do |page|
    page.refresh
  page.planner_courses_detail_list.wait_until_present(120)
  end
  @course_search_result.remove_code_from_planned_backup

  navigate_to_course_search_home
  @course_search_result.select_add_to_plan

end

Then(/^the course should be there in the planner$/) do
  navigate_to_course_planner_home

  on CoursePlannerPage do |page|
    page.refresh
    page.planner_courses_detail_list.wait_until_present(240)
  page.course_code_term(@course_search_result.planned_term, @course_search_result.course_code).should==@course_search_result.course_code
  end
end


And(/^I add the course from the course details page$/) do
  on CourseDetailPage do |page|
    page.add_to_plan.click
    page.term_cdp.wait_until_present
    page.term_cdp.select @course_search_result.term
    page.add_to_plan_notes_cdp.set @course_search_result.notes
    page.add_to_plan_button_cdp
  end
end



When(/^I navigate to the course section details$/) do
  #navigate to course search
  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Spring", :course_code => "ENGL206", :term=>"Spring 2014"
  @course_search_result.course_search
  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present(60)
  end

  #navigate to planner page
  on CourseSearch do |page|
    page.plan_page_click
  end
  on CoursePlannerPage do |page|
    page.planner_courses_detail_list.wait_until_present(60)
  end

  #delete an existing course
  @course_search_result.remove_code_from_planned_backup
  #navigate to course search

  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Spring", :course_code => "ENGL206", :term=>"Spring 2014"
  navigate_to_course_search_home

  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present(90)
  end
  #navigate to course details page
  @course_search_result.navigate_course_detail_page
  on CourseSectionPage do |page|
    page.course_termlist.wait_until_present(90)
  end
end



And(/^I add the course from search to the backup section for a specific term$/) do
  on CourseSearch do |page|
    page.plan_page_click
  end
  on CoursePlannerPage do |page|
     page.planner_courses_detail_list.wait_until_present(90)
  end
  @course_search_result.remove_code_from_planned_backup
  navigate_to_course_search_home
  @course_search_result.select_add_to_plan_backup

end



Then(/^the course should be there in the backup section of the planner$/) do
  navigate_to_course_planner_home
  on CoursePlannerPage do |page|
    page.refresh
    page.planner_courses_detail_list.wait_until_present(90)
    page.course_code_term_backup(@course_search_result.planned_term, @course_search_result.course_code)==@course_search_result.course_code
  end
end

When(/^I search for a specific course$/) do
  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Summer1", :course_code => "ENGL206", :term=>"Summer I 2014"
  @course_search_result.course_search
  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present(90)
  end
end



And(/^I add the course\(CM\) from the CDP details page to the Backup section$/) do
  on CourseDetailPage do |page|
    page.add_to_plan.click
    page.term_cdp.wait_until_present
    page.term_cdp.select @course_search_result.term
    page.add_to_plan_notes_cdp.set @course_search_result.notes
    sleep 5
    page.backup_checkbox_cdp.set
    page.add_to_plan_button_cdp
  end
end

Then(/^the course should be there in the Backup section of the planner$/) do
  navigate_to_course_planner_home

  on CoursePlannerPage do |page|
    page.planner_courses_detail_list.wait_until_present(90)
    page.course_code_term_backup(@course_search_result.planned_term, @course_search_result.course_code)==@course_search_result.course_code
  end
end


When(/^I search for a course with single activity offerings$/) do
  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Summer1", :course_code => "WMST348"
  @course_section_object=make CourseSectionObject
  @course_search_list=make CourseSearchResults
  @course_search_result.course_search
  #To remove the course from planner
  on CourseSearch do |page|
    page.plan_page_click
  end
  on CoursePlannerPage do |page|
    page.planner_courses_detail_list.wait_until_present(90)
  end

  #delete an existing course
  @course_search_result.remove_code_from_planned_backup
  #navigate to course search

  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Summer1", :course_code => "WMST348"
  navigate_to_course_search_home

  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present
  end
  #navigate to course details page
  on CourseSearch  do |page|
    page.course_code_result_link(@course_search_result.course_code).click
  end
  # @course_search_result.navigate_course_detail_page
  on CourseSectionPage do |page|
    page.ksap_loader.wait_while_present(90)
    page.course_termlist.wait_until_present(90)
  end

end

Then(/^I should be able to add the course to my plan$/) do
  @course_search_list=make CourseSearchResults

  on CourseSectionPage do |page|
    singleao_add_plan_codescription_level= "#{@course_search_list. course_offering_description_list[0].courseofferingdescription_level}"
    singleao_add_plan_co_term_level="#{@course_search_list.course_offering_description_list[0].course_term_list[0].courseterm_level}"
    singleao_add_plan_formatlist_level="#{@course_search_list.course_offering_description_list[0].course_term_list[0].formatlist_list[0].formatlist_level}"
    singleao_add_plan_fo_level="#{@course_search_list.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].fo_format_level}"
    singleao_add_plan_ao_level="#{@course_search_list.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[0].ao_activityoffering_level}"
    @plannedcode=page.activity_offering_code(singleao_add_plan_codescription_level,singleao_add_plan_co_term_level,singleao_add_plan_formatlist_level,singleao_add_plan_fo_level,singleao_add_plan_ao_level)
    puts @plannedcode
    @plannedinstructor=page.activity_offering_instructor(singleao_add_plan_codescription_level,singleao_add_plan_co_term_level,singleao_add_plan_formatlist_level,singleao_add_plan_fo_level,singleao_add_plan_ao_level)
    @planneddays=page.activity_offering_days(singleao_add_plan_codescription_level,singleao_add_plan_co_term_level,singleao_add_plan_formatlist_level,singleao_add_plan_fo_level,singleao_add_plan_ao_level)
    @plannedtime=page.activity_offering_time(singleao_add_plan_codescription_level,singleao_add_plan_co_term_level,singleao_add_plan_formatlist_level,singleao_add_plan_fo_level,singleao_add_plan_ao_level)
    @plannedlocation=page.activity_offering_location(singleao_add_plan_codescription_level,singleao_add_plan_co_term_level,singleao_add_plan_formatlist_level,singleao_add_plan_fo_level,singleao_add_plan_ao_level)
    @plannedseats=page.activity_offering_seats(singleao_add_plan_codescription_level,singleao_add_plan_co_term_level,singleao_add_plan_formatlist_level,singleao_add_plan_fo_level,singleao_add_plan_ao_level)

    page.add_to_plan_link.exists?.should==true
    page.add_to_plan_link.click
    sleep 5
    navigate_to_course_planner_home
    on CoursePlannerPage do |page|
      page.planner_courses_detail_list.wait_until_present(90)
    end
    @course_search_result = make CourseSearchResults,  :planned_term=>"2014Spring",:planned_term=>"2014Summer1", :course_code => "WMST348"
    navigate_to_course_search_home
    on CourseSearch do |page|
      page.course_search_results_facets.wait_until_present
    end
    #navigate to course details page
    on CourseSearch  do |page|
      page.course_code_result_link(@course_search_result.course_code).click
    end
    # @course_search_result.navigate_course_detail_page
    on CourseSectionPage do |page|
      page.ksap_loader.wait_while_present(90)
      page.course_termlist.wait_until_present(90)
    end
    puts page.actual_course_code(singleao_add_plan_codescription_level,singleao_add_plan_co_term_level,singleao_add_plan_formatlist_level,singleao_add_plan_fo_level)
    @plannedcode.should==page.actual_course_code(singleao_add_plan_codescription_level,singleao_add_plan_co_term_level,singleao_add_plan_formatlist_level,singleao_add_plan_fo_level)
    puts page.actual_course_code(singleao_add_plan_codescription_level,singleao_add_plan_co_term_level,singleao_add_plan_formatlist_level,singleao_add_plan_fo_level)
    @plannedinstructor.should==page.actual_course_instructor(singleao_add_plan_codescription_level,singleao_add_plan_co_term_level,singleao_add_plan_formatlist_level,singleao_add_plan_fo_level)
    @planneddays.should==page.actual_course_days(singleao_add_plan_codescription_level,singleao_add_plan_co_term_level,singleao_add_plan_formatlist_level,singleao_add_plan_fo_level)
    @plannedtime.should==page.actual_course_time(singleao_add_plan_codescription_level,singleao_add_plan_co_term_level,singleao_add_plan_formatlist_level,singleao_add_plan_fo_level)
    @plannedlocation.should==page.actual_course_location(singleao_add_plan_codescription_level,singleao_add_plan_co_term_level,singleao_add_plan_formatlist_level,singleao_add_plan_fo_level)
    @plannedseats.should==page.actual_course_seatsopen(singleao_add_plan_codescription_level,singleao_add_plan_co_term_level,singleao_add_plan_formatlist_level,singleao_add_plan_fo_level)
  end
end

When(/^I add a course with multiple activity offerings to my plan$/) do
  @course_search_result = make CourseSearchResults, :planned_term=>"2014Summer1", :course_code => "CHEM231", :term=>"Spring 2014"
  @course_section_object=make CourseSectionObject
  @course_search_list=make CourseSearchResults
  @course_search_result.course_search

  @course_activityoffering_object_4=make CourseActivityOfferingObject,
                                         :activity_offering_code => 'A',
                                         :activity_offering_days =>'MTWHF',
                                         :activity_offering_instructor => 'SUMMERS, RICHARD',
                                         :activity_offering_time => '08:00 AM - 09:20 AM',
                                         :activity_offering_location=>'CHM 1407',
                                         :activity_offering_seats =>'156/156'

  @course_activityoffering_object_5=make CourseActivityOfferingObject,
                                         :activity_offering_code => 'B',
                                         :activity_offering_days =>'TH',
                                         :activity_offering_instructor => 'RODRIQUEZ, NICHOLAS',
                                         :activity_offering_time => '10:00 AM - 11:20 AM',
                                         :activity_offering_location=>'HBK 0115',
                                         :activity_offering_seats =>'28/28'
  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present
  end

  #To remove the course from planner
  on CourseSearch do |page|
    page.plan_page_click
  end
  on CoursePlannerPage do |page|
    page.ksap_loader_planner.wait_while_present(90)
    page.planner_courses_detail_list.wait_until_present(90)
  end

  #delete an existing course
  @course_search_result.remove_code_from_planned_backup
  #navigate to course search

  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Summer1", :course_code => "CHEM231", :term=>"Spring 2014"
  navigate_to_course_search_home

  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present
  end
  #navigate to course details page
  on CourseSearch  do |page|
    page.course_code_result_link(@course_search_result.course_code).click
  end
  # @course_search_result.navigate_course_detail_page




  on CourseSectionPage do |page|
    page.ksap_loader.wait_while_present(90)
    page.course_termlist.wait_until_present(70)
  end


  #add activity offerings clubbed

  on CourseSectionPage do |page|
    page.add_to_button_disabled.wait_until_present

    codescription_level= "#{@course_search_result. course_offering_description_list[0].courseofferingdescription_level}"
    courseterm_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].courseterm_level}"
    formatlist_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].formatlist_level}"
    formatoffering_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].fo_format_level}"
    activityoffering_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[0].ao_activityoffering_level}"
    page.activityoffering_checkbox(codescription_level,codescription_level,formatlist_level,formatoffering_level,activityoffering_level).click

    description_codescription_level= "#{@course_search_result.course_offering_description_list[0].courseofferingdescription_level}"
    description_co_term_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].courseterm_level}"
    description_formatlist_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].formatlist_level}"
    description_fo_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[1].fo_format_level}"
    description_ao_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[0].ao_activityoffering_level}"
    page.activityoffering_checkbox(description_codescription_level,description_co_term_level,description_formatlist_level,description_fo_level,description_ao_level).click
    on CourseSectionPage do |page|
      page.add_to_button_disabled.exists?.should==true
    end

  end



end


Then(/^the multiple activity offerings course should be successfully added to my plan$/) do
  on CourseSectionPage do |page|
    sleep 5
    page.add_to_button_enabled.enabled?.should==true
    page.add_to_button_enabled.click
    codescription_add_plan_level= "#{@course_search_result. course_offering_description_list[0].courseofferingdescription_level}"
    courseterm_add_plan_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].courseterm_level}"
    formatlist_add_plan_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].formatlist_level}"
    formatoffering_add_plan_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].fo_format_level}"
    activityoffering_add_plan_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[0].ao_activityoffering_level}"


    description_add_plan_codescription_level= "#{@course_search_result.course_offering_description_list[0].courseofferingdescription_level}"
    description_add_plan_co_term_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].courseterm_level}"
    description_add_plan_formatlist_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].formatlist_level}"
    description_add_plan_fo_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[1].fo_format_level}"
    description_add_plan_ao_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[1].ao_activityoffering_level}"

    #Code for refresh

    navigate_to_course_planner_home
    on CoursePlannerPage do |page|
      page.planner_courses_detail_list.wait_until_present(90)
    end
    @course_search_result = make CourseSearchResults, :planned_term=>"2014Summer1", :course_code => "CHEM231", :term=>"Spring 2014"
    navigate_to_course_search_home
    on CourseSearch do |page|
      page.course_search_results_facets.wait_until_present(90)
    end
    #navigate to course details page
    on CourseSearch  do |page|
      page.course_code_result_link(@course_search_result.course_code).click
    end
    # @course_search_result.navigate_course_detail_page

    on CourseSectionPage do |page|
      page.ksap_loader.wait_while_present(90)
      page.course_termlist.wait_until_present(90)
    end

    #Code for refresh
    page.actual_course_code(codescription_add_plan_level,courseterm_add_plan_level,formatlist_add_plan_level,formatoffering_add_plan_level).should match /#{@course_activityoffering_object_4.activity_offering_code}/

    page.actual_course_instructor(codescription_add_plan_level,courseterm_add_plan_level,formatlist_add_plan_level,formatoffering_add_plan_level).should match /#{@course_activityoffering_object_4.activity_offering_instructor}/
    page.actual_course_days(codescription_add_plan_level,courseterm_add_plan_level,formatlist_add_plan_level,formatoffering_add_plan_level).should match /#{@course_activityoffering_object_4.activity_offering_days}/
    page.actual_course_time(codescription_add_plan_level,courseterm_add_plan_level,formatlist_add_plan_level,formatoffering_add_plan_level).should match /#{@course_activityoffering_object_4.activity_offering_time}/
    page.actual_course_location(codescription_add_plan_level,courseterm_add_plan_level,formatlist_add_plan_level,formatoffering_add_plan_level).should match /#{@course_activityoffering_object_4.activity_offering_location}/
    page.actual_course_seatsopen(codescription_add_plan_level,courseterm_add_plan_level,formatlist_add_plan_level,formatoffering_add_plan_level).should match /#{@course_activityoffering_object_4.activity_offering_seats}/

    page.actual_course_code(description_add_plan_codescription_level,description_add_plan_co_term_level,description_add_plan_formatlist_level,description_add_plan_fo_level).should match /#{@course_activityoffering_object_5.activity_offering_code}/

    page.actual_course_instructor(description_add_plan_codescription_level,description_add_plan_co_term_level,description_add_plan_formatlist_level,description_add_plan_fo_level).should match /#{@course_activityoffering_object_5.activity_offering_instructor}/
    page.actual_course_days(description_add_plan_codescription_level,description_add_plan_co_term_level,description_add_plan_formatlist_level,description_add_plan_fo_level).should match /#{@course_activityoffering_object_5.activity_offering_days}/
    page.actual_course_time(description_add_plan_codescription_level,description_add_plan_co_term_level,description_add_plan_formatlist_level,description_add_plan_fo_level).should match /#{@course_activityoffering_object_5.activity_offering_time}/
    page.actual_course_location(description_add_plan_codescription_level,description_add_plan_co_term_level,description_add_plan_formatlist_level,description_add_plan_fo_level).should match /#{@course_activityoffering_object_5.activity_offering_location}/
    page.actual_course_seatsopen(description_add_plan_codescription_level,description_add_plan_co_term_level,description_add_plan_formatlist_level,description_add_plan_fo_level).should match /#{@course_activityoffering_object_5.activity_offering_seats}/
 end
end

When(/^I add a course with multiple format offerings to my plan$/) do
  @course_search_result = make CourseSearchResults, :course_code => "CHEM237",:planned_term=>"2014Spring", :term=>"Spring 2014"

  @course_activityoffering_object_1=make CourseActivityOfferingObject,
                                         :activity_offering_code => 'A',
                                         :activity_offering_days =>'MWF',
                                         :activity_offering_instructor => 'HOFFMAN, DANIEL',
                                         :activity_offering_time => '09:00 AM - 09:50 AM',
                                         :activity_offering_location=>'CHM 1224',
                                         :activity_offering_seats =>'36/36'

  @course_activityoffering_object_2=make CourseActivityOfferingObject,
                                         :activity_offering_code => 'C',
                                         :activity_offering_days =>'T',
                                         :activity_offering_instructor => 'PRESTON, NANCI',
                                         :activity_offering_time => '02:00 PM - 02:50 PM',
                                         :activity_offering_location=>'CHM 0124',
                                         :activity_offering_seats =>'18/18'

  @course_activityoffering_object_3=make CourseActivityOfferingObject,
                                         :activity_offering_code => 'B',
                                         :activity_offering_days =>'H',
                                         :activity_offering_instructor => 'DANIELS, CRAIG',
                                         :activity_offering_time => '08:00 AM - 10:50 AM',
                                         :activity_offering_location=>'CHM 1360',
                                         :activity_offering_seats =>'18/18'
  @course_search_result.course_search
  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present
  end
  #To remove the course from planner
  on CourseSearch do |page|
    page.plan_page_click
  end
  on CoursePlannerPage do |page|
    page.planner_courses_detail_list.wait_until_present(90)
  end

  #delete an existing course
  @course_search_result.remove_code_from_planned_backup
  #navigate to course search

  @course_search_result = make CourseSearchResults,  :planned_term=>"2014Spring", :course_code => "CHEM237", :term=>"Spring 2014"
  navigate_to_course_search_home

  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present(90)
  end
  #navigate to course details page
  on CourseSearch  do |page|
    page.course_code_result_link(@course_search_result.course_code).click
  end
 # @course_search_result.navigate_course_detail_page

  on CourseSectionPage do |page|
    page.ksap_loader.wait_while_present(90)
    page.course_termlist.wait_until_present(90)
  end
  #To remove the course from planner

  #add format offerings

  on CourseSectionPage do |page|
    page.lecture_lab_discussion.click
    sleep 3
  end
  codescription_level= "#{@course_search_result. course_offering_description_list[0].courseofferingdescription_level}"
  courseterm_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].courseterm_level}"
  formatlist_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[1].formatlist_level}"
  formatoffering_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].fo_format_level}"
  activityoffering_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[0].ao_activityoffering_level}"

  codescription_fo_level_1= "#{@course_search_result. course_offering_description_list[0].courseofferingdescription_level}"
  courseterm_fo_level_1="#{@course_search_result.course_offering_description_list[0].course_term_list[0].courseterm_level}"
  formatlist_fo_level_1="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[1].formatlist_level}"
  formatoffering_fo_level_1="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[1].fo_format_level}"
  activityoffering_fo_level_1="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[0].ao_activityoffering_level}"

  codescription_fo_level_2= "#{@course_search_result. course_offering_description_list[0].courseofferingdescription_level}"
  courseterm_fo_level_2="#{@course_search_result.course_offering_description_list[0].course_term_list[0].courseterm_level}"
  formatlist_fo_level_2="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[1].formatlist_level}"
  formatoffering_fo_level_2="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[2].fo_format_level}"
  activityoffering_fo_level_2="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[0].ao_activityoffering_level}"

  on CourseSectionPage do |page|
    page.add_to_button_disabled.exists?.should==true
    page.activityoffering_checkbox(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).click
    page.activityoffering_checkbox(codescription_fo_level_1,courseterm_fo_level_1,formatlist_fo_level_1,formatoffering_fo_level_1,activityoffering_fo_level_1).click
    page.activityoffering_checkbox(codescription_fo_level_2,courseterm_fo_level_2,formatlist_fo_level_2,formatoffering_fo_level_2,activityoffering_fo_level_2).click
  end




end


Then(/^the multiple format offerings course should be successfully added to my plan$/) do
  on CourseSectionPage do |page|
    course_code=@course_search_result.course_code
    page.lecture_lab_discussion.exists?.should==true
    page.lecture.exists?.should==true
    page.ao_lecture(course_code).exists?.should==true
    page.ao_discussion(course_code).exists?.should==true
    page.ao_lecture(course_code).exists?.should==true


    page.add_to_button_enabled.wait_until_present
    sleep 2
    page.add_to_button_enabled.click



    #Code for refresh

    navigate_to_course_planner_home
    on CoursePlannerPage do |page|
      page.planner_courses_detail_list.wait_until_present
    end
    @course_search_result = make CourseSearchResults, :planned_term=>"2014Spring", :course_code => "CHEM237", :term=>"Spring 2014"
    navigate_to_course_search_home
    on CourseSearch do |page|
      page.course_search_results_facets.wait_until_present
    end
    #navigate to course details page
    on CourseSearch  do |page|
      page.course_code_result_link(@course_search_result.course_code).click
    end
    # @course_search_result.navigate_course_detail_page

    on CourseSectionPage do |page|
      page.ksap_loader.wait_while_present
      page.course_termlist.wait_until_present(90)
    end



    #Code for refresh

    codescription_level= "#{@course_search_result. course_offering_description_list[0].courseofferingdescription_level}"
    courseterm_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].courseterm_level}"
    formatlist_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].formatlist_level}"
    formatoffering_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].fo_format_level}"
    activityoffering_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[0].ao_activityoffering_level}"


    codescription_level_1= "#{@course_search_result. course_offering_description_list[0].courseofferingdescription_level}"
    courseterm_level_1="#{@course_search_result.course_offering_description_list[0].course_term_list[0].courseterm_level}"
    formatlist_level_1="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].formatlist_level}"
    formatoffering_level_1="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[1].fo_format_level}"
    activityoffering_level_1="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[0].ao_activityoffering_level}"

    codescription_level_2= "#{@course_search_result. course_offering_description_list[0].courseofferingdescription_level}"
    courseterm_level_2="#{@course_search_result.course_offering_description_list[0].course_term_list[0].courseterm_level}"
    formatlist_level_2="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].formatlist_level}"
    formatoffering_level_2="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[2].fo_format_level}"
    activityoffering_level_2="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[0].ao_activityoffering_level}"

    page.actual_course_code(codescription_level,courseterm_level,formatlist_level,formatoffering_level).should match /#{@course_activityoffering_object_1.activity_offering_code}/
    page.actual_course_instructor(codescription_level,courseterm_level,formatlist_level,formatoffering_level).should match /#{@course_activityoffering_object_1.activity_offering_instructor}/
    page.actual_course_days(codescription_level,courseterm_level,formatlist_level,formatoffering_level).should match /#{@course_activityoffering_object_1.activity_offering_days}/
    page.actual_course_time(codescription_level,courseterm_level,formatlist_level,formatoffering_level).should match /#{@course_activityoffering_object_1.activity_offering_time}/
    page.actual_course_location(codescription_level,courseterm_level,formatlist_level,formatoffering_level).should match /#{@course_activityoffering_object_1.activity_offering_location}/
    page.actual_course_seatsopen(codescription_level,courseterm_level,formatlist_level,formatoffering_level).should match /#{@course_activityoffering_object_1.activity_offering_seats}/

    page.actual_course_code(codescription_level_1,courseterm_level_1,formatlist_level_1,formatoffering_level_1).should match /#{@course_activityoffering_object_3.activity_offering_code}/
    page.actual_course_instructor(codescription_level_1,courseterm_level_1,formatlist_level_1,formatoffering_level_1).should match /#{@course_activityoffering_object_3.activity_offering_instructor}/
    page.actual_course_days(codescription_level_1,courseterm_level_1,formatlist_level_1,formatoffering_level_1).should match /#{@course_activityoffering_object_3.activity_offering_days}/
    page.actual_course_time(codescription_level_1,courseterm_level_1,formatlist_level_1,formatoffering_level_1).should match /#{@course_activityoffering_object_3.activity_offering_time}/
    page.actual_course_location(codescription_level_1,courseterm_level_1,formatlist_level_1,formatoffering_level_1).should match /#{@course_activityoffering_object_3.activity_offering_location}/
    page.actual_course_seatsopen(codescription_level_1,courseterm_level_1,formatlist_level_1,formatoffering_level_1).should match /#{@course_activityoffering_object_3.activity_offering_seats}/

    page.actual_course_code(codescription_level_2,courseterm_level_2,formatlist_level_2,formatoffering_level_2).should match /#{@course_activityoffering_object_2.activity_offering_code}/
    page.actual_course_instructor(codescription_level_2,courseterm_level_2,formatlist_level_2,formatoffering_level_2).should match /#{@course_activityoffering_object_2.activity_offering_instructor}/
    page.actual_course_days(codescription_level_2,courseterm_level_2,formatlist_level_2,formatoffering_level_2).should match /#{@course_activityoffering_object_2.activity_offering_days}/
    page.actual_course_time(codescription_level_2,courseterm_level_2,formatlist_level_2,formatoffering_level_2).should match /#{@course_activityoffering_object_2.activity_offering_time}/
    page.actual_course_location(codescription_level_2,courseterm_level_2,formatlist_level_2,formatoffering_level_2).should match /#{@course_activityoffering_object_2.activity_offering_location}/
    page.actual_course_seatsopen(codescription_level_2,courseterm_level_2,formatlist_level_2,formatoffering_level_2).should match /#{@course_activityoffering_object_2.activity_offering_seats}/



  end
end

And(/^I select the format offerings$/) do

  on CourseSectionPage do |page|
  page.lecture_lab_discussion.click
     sleep 3
  end
  codescription_level= "#{@course_search_result. course_offering_description_list[0].courseofferingdescription_level}"
  courseterm_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].courseterm_level}"
  formatlist_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[1].formatlist_level}"
  formatoffering_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].fo_format_level}"
  activityoffering_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[0].ao_activityoffering_level}"

   codescription_fo_level_1= "#{@course_search_result. course_offering_description_list[0].courseofferingdescription_level}"
   courseterm_fo_level_1="#{@course_search_result.course_offering_description_list[0].course_term_list[0].courseterm_level}"
   formatlist_fo_level_1="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[1].formatlist_level}"
   formatoffering_fo_level_1="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[1].fo_format_level}"
   activityoffering_fo_level_1="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[0].ao_activityoffering_level}"

   codescription_fo_level_2= "#{@course_search_result. course_offering_description_list[0].courseofferingdescription_level}"
   courseterm_fo_level_2="#{@course_search_result.course_offering_description_list[0].course_term_list[0].courseterm_level}"
   formatlist_fo_level_2="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[1].formatlist_level}"
   formatoffering_fo_level_2="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[2].fo_format_level}"
   activityoffering_fo_level_2="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[0].ao_activityoffering_level}"

  on CourseSectionPage do |page|
    page.add_to_button_disabled.exists?.should==true
    page.activityoffering_checkbox(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).click
    page.activityoffering_checkbox(codescription_fo_level_1,courseterm_fo_level_1,formatlist_fo_level_1,formatoffering_fo_level_1,activityoffering_fo_level_1).click
    page.activityoffering_checkbox(codescription_fo_level_2,courseterm_fo_level_2,formatlist_fo_level_2,formatoffering_fo_level_2,activityoffering_fo_level_2).click
  end





end
