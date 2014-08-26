When /^I search for a course on course search page$/ do
 @course_search_result = make CourseSearchResults, :course_code => "ENGL201" ,
                              :description=>"historical",
                              :requisite=>"None",
                              :scheduled_terms=>"SP 14",
                              :projected_terms=>"Check",
                              :gened_requirements=>"General",
                              :subject=>"English"
 @course_section_object=make CourseSectionObject
 @course_search_result.course_search
 on CourseSearch do |page|
   page.course_search_results_facets.wait_until_present
 end
end

When /^I search for a certain course on course search page$/ do
  @course_search_result = make CourseSearchResults,
                               :course_code => "ENGL202" ,
                               :description=>"historical",
                               :requisite=>"None",
                               :scheduled_terms=>"SP 14",
                               :projected_terms=>"Check",
                               :gened_requirements=>"General",
                               :subject=>"English"
  @course_section_object=make CourseSectionObject
  @course_activityoffering_object=make CourseActivityOfferingObject,
                                       :activity_offering_seats =>'35/35',
                                       :activity_offering_code=>"A",
                                       :activity_offering_instructor=>"ROBINSON, CHARLES",
                                       :activity_offering_days=>"MWF",
                                       :activity_offering_time=>"11:00 AM - 11:50 AM",
                                       :activity_offering_location=>"TWS 0221",
                                       :activity_offering_additional_details=>" "
  @course_search_result.course_search
  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present
  end
end


When(/^I search for course which has format offerings on the course search page$/) do
  @course_search_result = make CourseSearchResults, :course_code => "CHEM237"
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
end


And(/^I view the details of the course on the Course Details page$/) do
@course_search_result.navigate_course_detail_page
end

Then /^I should be able to view all the required information on the Course Details page$/ do
  on CourseDetailPage do |page|
    course_code=@course_search_result.course_code
    page.course_description(course_code).text.should match /#{@course_search_result.description}/
    page.course_requisites(course_code).text.should match /#{@course_search_result.requisite}/
    page.scheduled_terms(course_code).text.should match /#{@course_search_result.scheduled_terms}/
    page.projected_terms(course_code).text.should match /#{@course_search_result.projected_terms}/
    page.gened_requirements(course_code).text.should match /#{@course_search_result.gened_requirements}/
    page.subject(course_code).text.should match /#{@course_search_result.subject}/
  end
end


And(/^I navigate to the Course Section Details page$/) do
  @course_search_result.navigate_course_detail_page
  sleep 50
  on CourseSectionPage do |page|
  page.course_termlist.wait_until_present(120)
  end
end

Then(/^I should be able to view the section details about the course$/) do
  on CourseSectionPage do |page|
    page.course_detail.should == @course_section_object.course_detail_header
    codescription_level= "#{@course_search_result.course_offering_description_list[0].courseofferingdescription_level}"
    courseterm_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].courseterm_level}"
    formatlist_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].formatlist_level}"
    formatoffering_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].fo_format_level}"
    activityoffering_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[0].ao_activityoffering_level}"

    page.term_and_course_offering.should == @course_section_object.term_and_course_offering
    page.course_description.text.should match /#{@course_section_object.course_description}/
    page.activity_offering_code(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match /#{@course_activityoffering_object.activity_offering_code}/
    page.activity_offering_instructor(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match /#{@course_activityoffering_object.activity_offering_instructor}/
    page.activity_offering_time(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match /#{@course_activityoffering_object.activity_offering_time}/
    page.activity_offering_location(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match /#{@course_activityoffering_object.activity_offering_location}/
    page.activity_offering_seats(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match /#{@course_activityoffering_object.activity_offering_seats}/
  end
end

Then(/^I should be able to view the format offerings for the course$/) do
  on CourseSectionPage do |page|
    course_code=@course_search_result.course_code
    page.lecture_lab_discussion.exists?.should==true
    page.lecture.exists?.should==true
    #page.lecture_lab_discussion.click
   # page.ao_lecture(course_code).exists?.should==true
    #page.ao_discussion(course_code).exists?.should==true
   # page.ao_lecture(course_code).exists?.should==true

   # codescription_level= "#{@course_search_result. course_offering_description_list[0].courseofferingdescription_level}"
   # courseterm_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].courseterm_level}"
   # formatlist_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[1].formatlist_level}"
   # formatoffering_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].fo_format_level}"
   # activityoffering_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[0].ao_activityoffering_level}"


    #Validation for Lecture
   # page.activity_offering_code(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match /#{@course_activityoffering_object_1.activity_offering_code}/
    #page.activity_offering_instructor(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match /#{@course_activityoffering_object_1.activity_offering_instructor}/
   # page.activity_offering_days(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match /#{@course_activityoffering_object_1.activity_offering_days}/
   # page.activity_offering_time(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match @course_activityoffering_object_1.activity_offering_time
    #page.activity_offering_location(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match /#{@course_activityoffering_object_1.activity_offering_location}/
    #page.activity_offering_seats(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match /#{@course_activityoffering_object_1.activity_offering_seats}/

    #codescription_level= "#{@course_search_result. course_offering_description_list[0].courseofferingdescription_level}"
    #courseterm_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].courseterm_level}"
    #formatlist_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[1].formatlist_level}"
    #formatoffering_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[1].fo_format_level}"
    #activityoffering_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[0].ao_activityoffering_level}"


    #Validation for discussion
    #page.activity_offering_code(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match /#{@course_activityoffering_object_2.activity_offering_code}/
    #page.activity_offering_instructor(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match /#{@course_activityoffering_object_2.activity_offering_instructor}/
   # page.activity_offering_days(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match /#{@course_activityoffering_object_2.activity_offering_days}/
   # page.activity_offering_time(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match @course_activityoffering_object_2.activity_offering_time
   # page.activity_offering_location(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match /#{@course_activityoffering_object_2.activity_offering_location}/
    #page.activity_offering_seats(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match /#{@course_activityoffering_object_2.activity_offering_seats}/


    #codescription_level= "#{@course_search_result. course_offering_description_list[0].courseofferingdescription_level}"
    #courseterm_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].courseterm_level}"
   # formatlist_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[1].formatlist_level}"
   # formatoffering_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[2].fo_format_level}"
    #activityoffering_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[0].ao_activityoffering_level}"

    #Validation for Lab
   # page.activity_offering_code(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match /#{@course_activityoffering_object_3.activity_offering_code}/
   # page.activity_offering_instructor(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match /#{@course_activityoffering_object_3.activity_offering_instructor}/
   # page.activity_offering_days(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match /#{@course_activityoffering_object_3.activity_offering_days}/
   # page.activity_offering_time(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match @course_activityoffering_object_3.activity_offering_time
   #page.activity_offering_location(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match /#{@course_activityoffering_object_3.activity_offering_location}/
   # page.activity_offering_seats(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).should match /#{@course_activityoffering_object_3.activity_offering_seats}/
  end
end



When(/^I search for a course with Multiple Activity Offerings$/) do
  @course_search_result = make CourseSearchResults, :course_code => "CHEM231"
  @course_section_object=make CourseSectionObject
  @course_search_list=make CourseSearchResults
  @course_search_result.course_search
  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present
  end
end



Then(/^I should be able to see an option to add multiple offerings to my plan$/) do
on CourseSectionPage do |page|
  sleep 5
  page.add_to_button_enabled.enabled?.should==true
end
end



And(/^I select the activity offerings$/) do
  on CourseSectionPage do |page|
  page.add_to_button_disabled.wait_until_present
  end
  codescription_level= "#{@course_search_result. course_offering_description_list[0].courseofferingdescription_level}"
  courseterm_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].courseterm_level}"
  formatlist_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].formatlist_level}"
  formatoffering_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].fo_format_level}"
  activityoffering_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[0].ao_activityoffering_level}"


  description_codescription_level= "#{@course_search_result.course_offering_description_list[0].courseofferingdescription_level}"
  description_co_term_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].courseterm_level}"
  description_formatlist_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].formatlist_level}"
  description_fo_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[1].fo_format_level}"
  description_ao_level="#{@course_search_result.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[1].ao_activityoffering_level}"

  on CourseSectionPage do |page|
    page.add_to_button_disabled.exists?.should==true
    page.activityoffering_checkbox(codescription_level,courseterm_level,formatlist_level,formatoffering_level,activityoffering_level).click
  end

end

When(/^I search for a course with Single Activity Offering$/) do
  @course_search_result = make CourseSearchResults, :course_code => "ENGL202"
  @course_section_object=make CourseSectionObject
  @course_search_list=make CourseSearchResults
  @course_search_result.course_search
  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present
  end
end

Then(/^I should be able to see an option to add the course to my plan$/) do

on CourseSectionPage do |page|
  singleao_codescription_level= "#{@course_search_list. course_offering_description_list[0].courseofferingdescription_level}"
  singleao_co_term_level="#{@course_search_list.course_offering_description_list[0].course_term_list[0].courseterm_level}"
  singleao_formatlist_level="#{@course_search_list.course_offering_description_list[0].course_term_list[0].formatlist_list[0].formatlist_level}"
  singleao_fo_level="#{@course_search_list.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].fo_format_level}"
  singleao_ao_level="#{@course_search_list.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[1].ao_activityoffering_level}"

  page.add_to_plan_link.exists?.should==true
  end
end




When(/^I search for a course with website and restrictions link$/) do
  @course_search_result = make CourseSearchResults, :course_code => "CHEM231"
  @course_section_object=make CourseSectionObject
  @course_search_list=make CourseSearchResults
  @course_search_result.course_search
  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present
  end
end

Then(/^I should be able to see the website and restriction links for the course$/) do
  on CourseSectionPage do |page|
    page.term_credit(@course_section_object.term_credit).click
    links_codescription_level= "#{@course_search_list. course_offering_description_list[1].courseofferingdescription_level}"
    links_co_term_level="#{@course_search_list.course_offering_description_list[0].course_term_list[0].courseterm_level}"
    links_formatlist_level="#{@course_search_list.course_offering_description_list[0].course_term_list[0].formatlist_list[0].formatlist_level}"
    links_fo_level="#{@course_search_list.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].fo_format_level}"
    links_ao_level="#{@course_search_list.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[0].ao_activityoffering_level}"
    page.website(links_codescription_level,links_co_term_level,links_formatlist_level,links_fo_level,links_ao_level).click
    page.restrictions(links_codescription_level,links_co_term_level,links_formatlist_level,links_fo_level,links_ao_level).click
  end

end


When(/^I search for a course with variable credits$/) do
  @course_search_result = make CourseSearchResults, :course_code => "ENGL388"
  @course_section_object=make CourseSectionObject
  @course_search_list=make CourseSearchResults
  @course_search_result.course_search
  on CourseSearch do |page|
    page.course_search_results_facets.wait_until_present
  end
end


Then(/^I should be able to see an option to add a course with variable credits to my plan$/) do
  on CourseSectionPage do |page|
    page.course_variable_credit(@course_section_object.course_variable_credit,@course_search_result.course_code).click
    alinks_codescription_level= "#{@course_search_list. course_offering_description_list[0].courseofferingdescription_level}"
    a1links_co_term_level="#{@course_search_list.course_offering_description_list[0].course_term_list[0].courseterm_level}"
    alinks_formatlist_level="#{@course_search_list.course_offering_description_list[0].course_term_list[0].formatlist_list[0].formatlist_level}"
    alinks_fo_level="#{@course_search_list.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].fo_format_level}"
    alinks_ao_level="#{@course_search_list.course_offering_description_list[0].course_term_list[0].formatlist_list[0].fo_list[0].ao_list[0].ao_activityoffering_level}"

    page.add_plan_link(alinks_codescription_level,a1links_co_term_level,alinks_formatlist_level,alinks_fo_level,alinks_ao_level).exists?.should==true
  end

end
