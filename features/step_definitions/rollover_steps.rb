When /^I initiate a rollover by specifying source and target terms$/ do
  @rollover = make Rollover, :target_term => Rollover::ROLLOVER_TEST_TERM_TARGET , :source_term => Rollover::OPEN_SOC_TERM
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in draft state EC/ do
  @rollover = make Rollover, :source_term => Rollover::SOC_STATES_SOURCE_TERM, :target_term => Rollover::DRAFT_SOC_TERM
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in open state EC$/ do
  @rollover = make Rollover, :source_term => Rollover::SOC_STATES_SOURCE_TERM, :target_term => Rollover::OPEN_SOC_TERM
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in final edits state EC$/ do
  @rollover = make Rollover, :source_term => Rollover::SOC_STATES_SOURCE_TERM, :target_term => Rollover::FINAL_EDITS_SOC_TERM
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in published state for milestones testing$/ do
  @rollover = make Rollover, :source_term => Rollover::SOC_STATES_SOURCE_TERM, :target_term => Rollover::PUBLISHED_MILESTONES_SOC_TERM
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in published state EC$/ do
  @rollover = make Rollover, :source_term => Rollover::SOC_STATES_SOURCE_TERM, :target_term => Rollover::PUBLISHED_SOC_TERM
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in locked state EC$/ do
  @rollover = make Rollover, :source_term => Rollover::SOC_STATES_SOURCE_TERM, :target_term => Rollover::LOCKED_SOC_TERM
  @rollover.perform_rollover
end

#When /^I initiate a rollover to create a term in closed state EC$/ do
#  @rollover = make Rollover, :source_term => Rollover::SOC_STATES_SOURCE_TERM, :target_term => Rollover::CLOSED_SOC_TERM
#  @rollover.perform_rollover
#end

When /^I initiate a rollover to create a term in draft state WC/ do
  @rollover = make Rollover, :source_term => "201205", :target_term => "201805"
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in open state WC$/ do
  @rollover = make Rollover, :source_term => "201205", :target_term => "201705"
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in final edits state WC$/ do
  @rollover = make Rollover, :source_term => "201205", :target_term => "201605"
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in published state WC$/ do
  @rollover = make Rollover, :source_term => "201205", :target_term => "201505"
  @rollover.perform_rollover
end

When /^I approve the "(.*)" subject code for scheduling in the target term$/ do |subject_code|
  @course_offering = make CourseOffering, :term=>@rollover.target_term, :course=>subject_code
  @course_offering.approve_subject_code
  on ManageCourseOfferingList do |page|
    sleep 1
    page.course_offering_results_table.rows[2].cells[ManageCourseOfferingList::CO_STATUS_COLUMN].text.should == CourseOffering::PLANNED_STATUS
  end
end

And /^I manage SOC for the target term$/ do
  @manage_soc = make ManageSoc, :term_code =>@rollover.target_term
end

Then /^the results of the rollover are available$/ do
  @rollover.wait_for_rollover_to_complete
  #TODO validation
  #page.source_term.should ==
  #page.date_initiated.should ==
  #page.date_completed.should ==
  #page.rollover_duration.should ==
  #page.course_offerings_transitioned.should ==
  #page.course_offerings_exceptions.should ==
  #page.activity_offerings_transitioned.should ==
  #page.activity_offerings_exceptions.should ==
  #page.exceptions_table.rows[1].cells[0].text #first exception
end

Then /^course offerings are copied to the target term$/ do
  #TODO validation
end

Then /^the rollover can be released to departments$/ do
  @rollover.release_to_depts
  #TODO validation
end

When /^I initiate a rollover to create a term for manage soc testing$/ do
  @rollover = make Rollover, :source_term => Rollover::SOC_STATES_SOURCE_TERM, :target_term => Rollover::MANAGE_SOC_TERM_TARGET
  @rollover.perform_rollover
end

When /^I am working on a term in "Open" SOC state$/ do
  @term_for_test = Rollover::OPEN_SOC_TERM
end

When /^I am working on a term in "Final Edits" SOC state$/ do
  @term_for_test = Rollover::FINAL_EDITS_SOC_TERM
end

When /^I am working on a term in "Published" SOC state$/ do
  @term_for_test = Rollover::PUBLISHED_SOC_TERM
end

When /^I am working on a term in "Published" SOC state for milestones testing$/ do
  @term_for_test = Rollover::PUBLISHED_MILESTONES_SOC_TERM
end

When /^I am working on a term in "Draft" SOC state$/ do
  @term_for_test = Rollover::DRAFT_SOC_TERM
end

When /^I am working on a term in "Locked" SOC state$/ do
  @term_for_test = Rollover::LOCKED_SOC_TERM
end

When /^I am working on a term in "Closed" SOC state$/ do
  @term_for_test = Rollover::CLOSED_SOC_TERM
end

And /^I setup a second target term with those subterms setup$/ do
  @calendar_target2 = create AcademicCalendar, :year => @calendar.year.to_i + 2 #, :name => "TWj64w1q3e"
  @term_target2 = make AcademicTermObject, :parent_calendar => @calendar_target2
  @calendar_target2.add_term @term_target2

  @calendar_target2.terms[0].add_subterm (make AcademicTermObject,
                                               :parent_calendar => @calendar_target2,
                                               :term_type=> "Half Fall 1",
                                               :subterm => true)

  @calendar_target2.terms[0].add_subterm (make AcademicTermObject,
                                               :parent_calendar => @calendar_target2,
                                               :term_type=> "Half Fall 2",
                                               :subterm => true)

  @calendar_target2.terms[0].subterms.each do |subterm|
    subterm.make_official
  end

  @manage_soc = make ManageSoc, :term_code => @calendar_target2.terms[0].term_code
  @manage_soc.set_up_soc
end

And /^I rollover the subterms' parent term to a target term with those subterms setup$/ do
  @calendar_target = create AcademicCalendar, :year => @calendar.year.to_i + 1 #,:name => "6aXt9C4nbM"
  term_target = make AcademicTermObject, :parent_calendar => @calendar_target
  @calendar_target.add_term term_target

  @calendar_target.terms[0].add_subterm  (make AcademicTermObject, :parent_calendar => @calendar_target, :term_type=> "Half Fall 1",
                                               :parent_term=> "Fall Term", :subterm => true)

  @calendar_target.terms[0].add_subterm (make AcademicTermObject, :parent_calendar => @calendar_target, :term_type=> "Half Fall 2",
                                              :parent_term=> "Fall Term", :subterm => true)

  @calendar_target.terms[0].subterms.each do |subterm|
    subterm.make_official
  end

  @manage_soc = make ManageSoc, :term_code => @calendar_target.terms[0].term_code
  @manage_soc.set_up_soc

  @rollover = make Rollover, :target_term => @calendar_target.terms[0].term_code , :source_term => @calendar.terms[0].term_code
  @rollover.perform_rollover
  @rollover.wait_for_rollover_to_complete
  @rollover.release_to_depts
end


And /^I rollover the subterms' parent term to a target term with those subterms are NOT setup$/ do
  @calendar_target = create AcademicCalendar, :year => @calendar.year.to_i + 1 #, :name => "TWj64w1q3e"
  term_target = make AcademicTermObject, :parent_calendar => @calendar_target
  @calendar_target.add_term term_target
  @calendar_target.terms[0].make_official

  @manage_soc = make ManageSoc, :term_code =>  @calendar_target.terms[0].term_code
  @manage_soc.set_up_soc

  @rollover = make Rollover, :target_term => @calendar_target.terms[0].term_code ,
                   :source_term => @calendar.terms[0].term_code,
                   :exp_success => false
  @rollover.perform_rollover
  @rollover.wait_for_rollover_to_complete
end

And /^I rollover the term to a new academic term$/ do
  @calendar_target = create AcademicCalendar, :year => @calendar.year.to_i + 1 #, :name => "TWj64w1q3e"
  term_target = make AcademicTermObject, :parent_calendar => @calendar_target
  @calendar_target.add_term term_target
  @calendar_target.terms[0].make_official

  @manage_soc = make ManageSoc, :term_code => @calendar_target.terms[0].term_code
  @manage_soc.set_up_soc

  @rollover = make Rollover, :target_term => @calendar_target.terms[0].term_code ,
                   :source_term => @calendar.terms[0].term_code,
                   :exp_success => false
  @rollover.perform_rollover
  @rollover.wait_for_rollover_to_complete
end

Then /^there is an exception for the course on rollover page stating: (.*)$/ do |expected_msg|
  on RolloverDetails do |page|
    page.get_exception_details(@course_offering.course).should match /.*#{Regexp.escape(expected_msg)}.*/
  end
end


Then /^I approve the Course Offering for scheduling in the target term$/ do
  @course_offering_target = make CourseOffering, :term=> @term_target.term_code,
                                 :course => @course_offering.course
  @course_offering_target.search_by_subjectcode
  @course_offering_target.approve_co
end

Then /^I advance the SOC state from open to published state$/ do
  #@manage_soc = make ManageSoc, :term_code =>@rollover.target_term
  @manage_soc.advance_soc_from_open_to_published
end

Then /^I advance the SOC state from open to final edits state$/ do
  #@manage_soc = make ManageSoc, :term_code =>@rollover.target_term
  @manage_soc.advance_soc_from_open_to_final_edits
end

Then /^I advance the SOC state from open to scheduler complete state$/ do
  #@manage_soc = make ManageSoc, :term_code =>@rollover.target_term
  @manage_soc.advance_soc_from_open_to_scheduler_run
end

Then /^the Course Offering is in offered state$/ do
  #@course_offering_target = make CourseOffering, :course => "CHEM132TUSNA", :term => "213108"
  @course_offering.manage

  on ManageCourseOfferings do |page|
    page.list_all_courses
  end

  on ManageCourseOfferingList do |page|
    page.co_status(@course_offering.course).should == "Offered"
  end

end

Then /^the Activity Offerings are assigned to the target subterms$/ do
  @course_offering_target = make CourseOffering, :course => @course_offering.course, :term => @calendar_target.terms[0].term_code
  @course_offering_target.manage

  activity_offering_target = make ActivityOfferingObject, :code => @activity_offering.code, :parent_cluster => @course_offering_target.default_cluster
  on ManageCourseOfferings do |page|
    page.has_subterm_icon(activity_offering_target.code).should == true
    page.view_activity_offering(activity_offering_target.code)
  end

  on ActivityOfferingInquiry do |page|
    page.subterm.should == @activity_offering.subterm
    page.close
  end

  activity_offering_target.edit :defer_save => true
  on ActivityOfferingMaintenance do |page|
    page.subterm.should == @activity_offering.subterm
    page.cancel
  end

  activity_offering_target2 = make ActivityOfferingObject, :code => @activity_offering2.code, :parent_cluster => @course_offering_target.default_cluster
  on ManageCourseOfferings do |page|
    page.has_subterm_icon(activity_offering_target2.code).should == true
    page.view_activity_offering(activity_offering_target2.code)
  end

  on ActivityOfferingInquiry do |page|
    page.subterm.should == @activity_offering2.subterm
    page.close
  end

  activity_offering_target2.edit :defer_save => true
  on ActivityOfferingMaintenance do |page|
    page.subterm.should == @activity_offering2.subterm
    page.cancel
  end
end

Then /^I can create a Course Offering in the second term from the existing CO in the first term$/ do
  @course_offering_copy = @course_offering.create_from_existing :target_term=> @calendar_target2.terms[0].term_code
end

Then /^the Activity Offerings for the copied CO are assigned to the target subterms$/ do
  @course_offering_copy.manage

  activity_offering_copy = make ActivityOfferingObject, :code =>"A", :parent_cluster => @course_offering_copy.default_cluster
  on ManageCourseOfferings do |page|
    page.has_subterm_icon(activity_offering_copy.code).should == true
    page.view_activity_offering(activity_offering_copy.code)
  end

  on ActivityOfferingInquiry do |page|
    page.subterm.should == @calendar_target2.terms[0].subterms[0].subterm_type
    page.close
  end

  activity_offering_copy.edit :defer_save => true
  on ActivityOfferingMaintenance do |page|
    page.subterm.should == @calendar_target2.terms[0].subterms[0].subterm_type
    page.cancel
  end

  activity_offering_target2 = make ActivityOfferingObject, :code => "B", :parent_cluster => @course_offering_copy.default_cluster
  on ManageCourseOfferings do |page|
    page.has_subterm_icon(activity_offering_target2.code).should == true
    page.view_activity_offering(activity_offering_target2.code)
  end

  on ActivityOfferingInquiry do |page|
    page.subterm.should == @calendar_target2.terms[0].subterms[1].subterm_type
    page.close
  end

  activity_offering_target2.edit :defer_save => true
  on ActivityOfferingMaintenance do |page|
    page.subterm.should == @calendar_target2.terms[0].subterms[1].subterm_type
    page.cancel
  end

end

And /^I(?: can)? generate 'bulk' exam offerings for the(?: new)? term$/ do
  @manage_soc.create_exam_offerings_soc
end

And /^I cannot generate 'bulk' exam offerings for the new term$/ do
  @manage_soc.term_code = @calendar.terms[0].term_code
  @manage_soc.search

  on ManageSocPage do |page|
    page.create_eos_action
    page.create_eos_error_popup_msg.should =~ /exam period must exist before exam offerings can be created/
    page.eos_error_cancel_action
  end
end

And /^the exam offerings are successfully generated$/ do
  @course_offering.manage
  on(ManageCourseOfferings).view_exam_offerings
  on ViewExamOfferings do |page|
    page.co_eo_days.should =~ /#{@matrix.rules[0].rsi_days}/
    page.co_eo_st_time.should == "#{@matrix.rules[0].start_time} #{@matrix.rules[0].start_time_ampm}"
    page.co_eo_end_time.should == "#{@matrix.rules[0].end_time} #{@matrix.rules[0].end_time_ampm}"
    page.co_eo_bldg.should == @matrix.rules[0].facility
    page.co_eo_room.should == @matrix.rules[0].room
  end
end

Given(/^a term has been rolled over$/) do
  @rollover = make Rollover, :source_term => Rollover::SOC_STATES_SOURCE_TERM, :target_term => 202300
  if !@rollover.completed?
    @rollover.perform_rollover
    @rollover.wait_for_rollover_to_complete
    @rollover.release_to_depts
  end
end

Given(/^that a default institutional rollover configuration is defined in the GES with a value of 'copy' for scheduling information$/) do
  #no UI for this
end

And(/^'copy' for Bldg\/Rm information$/) do
  #no UI for this
end

And(/^'not copy' for canceled AOs$/) do
  #no UI for this
end

And(/^'copy' for instructional assignments$/) do
  #no UI for this
end

When(/^the rollover is executed for a term with the specified course offering$/) do
  @calendar = create AcademicCalendar #, :year => "2235", :name => "fSZtG62zfU"
  term = make AcademicTermObject, :parent_calendar => @calendar
  @calendar.add_term term

  @manage_soc = make ManageSoc, :term_code => @calendar.terms[0].term_code
  @manage_soc.set_up_soc
  @manage_soc.perform_manual_soc_state_change

  course_offering = make CourseOffering, :term=> @calendar.terms[0].term_code,
                         :course => "ENGL462"
  course_offering.delivery_format_list[0].format = "Lecture"
  course_offering.delivery_format_list[0].grade_format = "Lecture"
  course_offering.delivery_format_list[0].final_exam_activity = "Lecture"

  course_offering.create

  activity_offering_canceled = create ActivityOfferingObject, :parent_cluster =>  course_offering.default_cluster,
                                      :activity_type => "Lecture"
  si_obj =  make SchedulingInformationObject, :days => "TH",
                 :start_time => "11:00", :start_time_ampm => "am",
                 :end_time => "11:50", :end_time_ampm => "am",
                 :facility => 'TWS', :room => '1100'
  activity_offering_canceled.add_req_sched_info :rsi_obj => si_obj, :defer_save => true

  person = make PersonnelObject, :id => "KS-10175", :name => "SMITH, DAVID", :affiliation => "Instructor", :inst_effort => 30
  activity_offering_canceled.add_personnel person
  on(ActivityOfferingMaintenance).submit
  activity_offering_canceled.cancel :navigate_to_page => false
  course_offering.get_ao_list << activity_offering_canceled

  activity_offering = create ActivityOfferingObject, :parent_cluster => course_offering.default_cluster,
                             :activity_type => "Lecture"
  si_obj =  make SchedulingInformationObject, :days => "W",
                 :start_time => "09:00", :start_time_ampm => "am",
                 :end_time => "09:50", :end_time_ampm => "am",
                 :facility => 'KEY', :room => '0117'
  activity_offering.add_req_sched_info :rsi_obj => si_obj, :defer_save => true

  person = make PersonnelObject, :id => "KS-4611", :name => "KEY, ALAN", :affiliation => "Instructor", :inst_effort => 100
  activity_offering.add_personnel person
  on(ActivityOfferingMaintenance).submit
  activity_offering.approve :navigate_to_page => false
  course_offering.get_ao_list << activity_offering
  @co_list = []
  @co_list << course_offering

  @calendar_target = create AcademicCalendar, :year => @calendar.year.to_i + 1 #,:name => "6aXt9C4nbM"
  term_target = make AcademicTermObject, :parent_calendar => @calendar_target
  @calendar_target.add_term term_target
  term_target.make_official

  @rollover = make Rollover, :target_term => @calendar_target.terms[0].term_code , :source_term => @calendar.terms[0].term_code
  @rollover.perform_rollover
  @rollover.wait_for_rollover_to_complete
  @rollover.release_to_depts
end

When(/^the rollover is executed for a term with the Bldg\/Rm rule and with the specified course offering$/) do
  @calendar = create AcademicCalendar #, :year => "2235", :name => "fSZtG62zfU"
  term = make AcademicTermObject, :parent_calendar => @calendar,
              :term => 'Summer I',
              :term_type => 'Summer 1',
              :term_name => "Summer 1 #{@calendar.year.to_i + 1}",
              :term_code => "#{@calendar.year.to_i + 1}05",
              :start_date => "05/12/#{@calendar.year.to_i + 1}",
              :end_date => "06/12/#{@calendar.year.to_i + 1}"
  @calendar.add_term term

  @manage_soc = make ManageSoc, :term_code => @calendar.terms[0].term_code
  @manage_soc.set_up_soc
  @manage_soc.perform_manual_soc_state_change

  course_offering = make CourseOffering, :term=> @calendar.terms[0].term_code,
                         :course => "CHEM105"
  course_offering.delivery_format_list[0].format = "Discussion/Lecture"
  course_offering.delivery_format_list[0].grade_format = "Lecture"
  course_offering.delivery_format_list[0].final_exam_activity = "Lecture"

  course_offering.create

  activity_offering_canceled = create ActivityOfferingObject, :parent_cluster =>  course_offering.default_cluster,
                                      :activity_type => "Lecture"
  si_obj =  make SchedulingInformationObject, :days => "TH",
                 :start_time => "11:00", :start_time_ampm => "am",
                 :end_time => "11:50", :end_time_ampm => "am",
                 :facility => 'TWS', :room => '1100'
  activity_offering_canceled.add_req_sched_info :rsi_obj => si_obj, :defer_save => true

  person = make PersonnelObject, :id => "KS-10175", :name => "SMITH, DAVID", :affiliation => "Instructor", :inst_effort => 30
  activity_offering_canceled.add_personnel person
  on(ActivityOfferingMaintenance).submit
  activity_offering_canceled.cancel :navigate_to_page => false
  course_offering.get_ao_list << activity_offering_canceled

  activity_offering = create ActivityOfferingObject, :parent_cluster => course_offering.default_cluster,
                             :activity_type => "Lecture"
  si_obj =  make SchedulingInformationObject, :days => "W",
                 :start_time => "09:00", :start_time_ampm => "am",
                 :end_time => "09:50", :end_time_ampm => "am",
                 :facility => 'KEY', :room => '0117'
  activity_offering.add_req_sched_info :rsi_obj => si_obj, :defer_save => true

  person = make PersonnelObject, :id => "KS-4611", :name => "KEY, ALAN", :affiliation => "Instructor", :inst_effort => 100
  activity_offering.add_personnel person
  on(ActivityOfferingMaintenance).submit
  activity_offering.approve :navigate_to_page => false
  course_offering.get_ao_list << activity_offering
  @co_list = []
  @co_list << course_offering

  @calendar_target = create AcademicCalendar, :year => @calendar.year.to_i + 1 #,:name => "6aXt9C4nbM"
  term_target = make AcademicTermObject, :parent_calendar => @calendar_target,
      :term => 'Summer I',
      :term_type => 'Summer 1',
      :term_name => "Summer 1 #{@calendar_target.year.to_i + 1}",
      :term_code => "#{@calendar_target.year.to_i + 1}05",
      :start_date => "05/12/#{@calendar_target.year.to_i + 1}",
      :end_date => "06/12/#{@calendar_target.year.to_i + 1}"

  @calendar_target.add_term term_target
  term_target.make_official

  @rollover = make Rollover, :target_term => @calendar_target.terms[0].term_code , :source_term => @calendar.terms[0].term_code
  @rollover.perform_rollover
  @rollover.wait_for_rollover_to_complete
  @rollover.release_to_depts
end

And(/^the rollover is executed for a term with course offerings that are not covered by a more granular rollover rule$/) do
  @calendar = create AcademicCalendar #, :year => "2235", :name => "fSZtG62zfU"
  term = make AcademicTermObject, :parent_calendar => @calendar
  @calendar.add_term term

  @manage_soc = make ManageSoc, :term_code => @calendar.terms[0].term_code
  @manage_soc.set_up_soc
  @manage_soc.perform_manual_soc_state_change

  course_offering = make CourseOffering, :term=> @calendar.terms[0].term_code,
                         :course => "CHEM105"
  course_offering.delivery_format_list[0].format = "Discussion/Lecture"
  course_offering.delivery_format_list[0].grade_format = "Lecture"
  course_offering.delivery_format_list[0].final_exam_activity = "Lecture"

  course_offering.create

  activity_offering_canceled = create ActivityOfferingObject, :parent_cluster =>  course_offering.default_cluster,
                                      :activity_type => "Lecture"
  si_obj =  make SchedulingInformationObject, :days => "TH",
                 :start_time => "11:00", :start_time_ampm => "am",
                 :end_time => "11:50", :end_time_ampm => "am",
                 :facility => 'TWS', :room => '1100'
  activity_offering_canceled.add_req_sched_info :rsi_obj => si_obj, :defer_save => true

  person = make PersonnelObject, :id => "KS-10175", :name => "SMITH, DAVID", :affiliation => "Instructor", :inst_effort => 30
  activity_offering_canceled.add_personnel person
  on(ActivityOfferingMaintenance).submit
  activity_offering_canceled.cancel :navigate_to_page => false
  course_offering.get_ao_list << activity_offering_canceled

  activity_offering = create ActivityOfferingObject, :parent_cluster => course_offering.default_cluster,
                             :activity_type => "Lecture"
  si_obj =  make SchedulingInformationObject, :days => "W",
                 :start_time => "09:00", :start_time_ampm => "am",
                 :end_time => "09:50", :end_time_ampm => "am",
                 :facility => 'KEY', :room => '0117'
  activity_offering.add_req_sched_info :rsi_obj => si_obj, :defer_save => true

  person = make PersonnelObject, :id => "KS-4611", :name => "KEY, ALAN", :affiliation => "Instructor", :inst_effort => 100
  activity_offering.add_personnel person
  on(ActivityOfferingMaintenance).submit
  activity_offering.approve :navigate_to_page => false
  course_offering.get_ao_list << activity_offering
  @co_list = []
  @co_list << course_offering

  @calendar_target = create AcademicCalendar, :year => @calendar.year.to_i + 1 #,:name => "6aXt9C4nbM"
  term_target = make AcademicTermObject, :parent_calendar => @calendar_target
  @calendar_target.add_term term_target
  term_target.make_official

  @rollover = make Rollover, :target_term => @calendar_target.terms[0].term_code , :source_term => @calendar.terms[0].term_code
  @rollover.perform_rollover
  @rollover.wait_for_rollover_to_complete
  @rollover.release_to_depts
end

Then(/^course offerings? (?:is|are) copied from the source term to the target term$/) do
  #confirm exist on source term
  @co_list.each do |co|
    co.term = @calendar.terms[0].term_code
    co.exists?.should be_true
  end

  @co_list.each do |co|
    #confirm exist on source term
    co.term = @calendar_target.terms[0].term_code
    co.exists?.should be_true
  end
end

And(/^the scheduling information including Bldg\/Rm info is copied to the target term AOs$/) do
  @co_list.each do |co|
    #confirm exist on target term
    co.term = @calendar_target.terms[0].term_code
    co.manage

    on ManageCourseOfferings do |page|
      ao_row = page.target_row('B')
      existing_sched_info = co.get_ao_list[1].get_existing_scheduling_information(ao_row)[0]
      existing_sched_info.days.should == co.get_ao_list[1].requested_scheduling_information_list[0].days
      existing_sched_info.start_time.should == co.get_ao_list[1].requested_scheduling_information_list[0].start_time
      existing_sched_info.start_time_ampm.should == co.get_ao_list[1].requested_scheduling_information_list[0].start_time_ampm
      existing_sched_info.end_time.should == co.get_ao_list[1].requested_scheduling_information_list[0].end_time
      existing_sched_info.end_time_ampm.should == co.get_ao_list[1].requested_scheduling_information_list[0].end_time_ampm
      existing_sched_info.facility.should == co.get_ao_list[1].requested_scheduling_information_list[0].facility
      existing_sched_info.room.should == co.get_ao_list[1].requested_scheduling_information_list[0].room
    end
  end
end

And(/^the scheduling information excluding Bldg\/Rm info is copied to the target term AOs$/) do
  @co_list.each do |co|
    #confirm exist on target term
    co.term = @calendar_target.terms[0].term_code
    co.manage

    on ManageCourseOfferings do |page|
      ao_row = page.target_row('B')
      existing_sched_info = co.get_ao_list[1].get_existing_scheduling_information(ao_row)[0]
      existing_sched_info.days.should == co.get_ao_list[1].requested_scheduling_information_list[0].days
      existing_sched_info.start_time.should == co.get_ao_list[1].requested_scheduling_information_list[0].start_time
      existing_sched_info.start_time_ampm.should == co.get_ao_list[1].requested_scheduling_information_list[0].start_time_ampm
      existing_sched_info.end_time.should == co.get_ao_list[1].requested_scheduling_information_list[0].end_time
      existing_sched_info.end_time_ampm.should == co.get_ao_list[1].requested_scheduling_information_list[0].end_time_ampm
      existing_sched_info.facility.should == ''
      existing_sched_info.room.should == ''
    end
  end
end


And(/^activity offerings are copied to the target term excluding those in cancelled status$/) do
  @co_list.each do |co|
    #confirm exist on source term
    co.term = @calendar.terms[0].term_code
    co.manage

    on ManageCourseOfferings do |page|
      page.ao_status('A').should == ActivityOfferingObject::CANCELED_STATUS
      page.ao_status('B').should == ActivityOfferingObject::APPROVED_STATUS
    end
  end

  @co_list.each do |co|
    #confirm exist on target term
    co.term = @calendar_target.terms[0].term_code
    co.manage

    on ManageCourseOfferings do |page|
      page.ao_exists?('A').should be_false
      page.ao_status('B').should == ActivityOfferingObject::DRAFT_STATUS
    end
  end
end

And(/^instructional assignments are copied to the target term AOs$/) do
  @co_list.each do |co|
    #confirm exist on target term
    co.term = @calendar_target.terms[0].term_code
    co.manage

    on ManageCourseOfferings do |page|
      page.ao_instructor('B').should == co.get_ao_list[1].personnel_list[0].name
    end
  end
end

And(/^activity offerings are copied to the target term including those in cancelled status$/) do
  @co_list.each do |co|
    #confirm exist on target term
    co.term = @calendar_target.terms[0].term_code
    co.manage

    on ManageCourseOfferings do |page|
      page.ao_status('A').should == ActivityOfferingObject::DRAFT_STATUS
      page.ao_status('B').should == ActivityOfferingObject::DRAFT_STATUS
    end
  end
end

Given(/^that a subject level rollover configuration is defined for ENGL in the GES with no value for scheduling information$/) do
  #no UI for this
end

And(/^'not copy' for instructional assignments$/) do
  #no UI for this
end

And(/^'copy' for canceled AOs$/) do
  #no UI for this
end

And(/^the rollover is executed for a term with course offerings with ENGL subject code that are not covered by a more granular rollover rule$/) do
  @calendar = create AcademicCalendar #, :year => "2235", :name => "fSZtG62zfU"
  term = make AcademicTermObject, :parent_calendar => @calendar
  @calendar.add_term term

  @manage_soc = make ManageSoc, :term_code => @calendar.terms[0].term_code
  @manage_soc.set_up_soc
  @manage_soc.perform_manual_soc_state_change

  course_offering = make CourseOffering, :term=> @calendar.terms[0].term_code,
                         :course => "ENGL211"
  course_offering.delivery_format_list[0].format = "Lecture"
  course_offering.delivery_format_list[0].grade_format = "Lecture"
  course_offering.delivery_format_list[0].final_exam_activity = "Lecture"

  course_offering.create

  activity_offering_canceled = create ActivityOfferingObject, :parent_cluster =>  course_offering.default_cluster,
                                      :activity_type => "Lecture"
  si_obj =  make SchedulingInformationObject, :days => "TH",
                 :start_time => "11:00", :start_time_ampm => "am",
                 :end_time => "11:50", :end_time_ampm => "am",
                 :facility => 'TWS', :room => '1100'
  activity_offering_canceled.add_req_sched_info :rsi_obj => si_obj, :defer_save => true

  person = make PersonnelObject, :id => "KS-10175", :name => "SMITH, DAVID", :affiliation => "Instructor", :inst_effort => 30
  activity_offering_canceled.add_personnel person
  on(ActivityOfferingMaintenance).submit
  activity_offering_canceled.cancel :navigate_to_page => false
  course_offering.get_ao_list << activity_offering_canceled

  activity_offering = create ActivityOfferingObject, :parent_cluster => course_offering.default_cluster,
                             :activity_type => "Lecture"
  si_obj =  make SchedulingInformationObject, :days => "W",
                 :start_time => "09:00", :start_time_ampm => "am",
                 :end_time => "09:50", :end_time_ampm => "am",
                 :facility => 'KEY', :room => '0117'
  activity_offering.add_req_sched_info :rsi_obj => si_obj, :defer_save => true

  person = make PersonnelObject, :id => "KS-4611", :name => "KEY, ALAN", :affiliation => "Instructor", :inst_effort => 100
  activity_offering.add_personnel person
  on(ActivityOfferingMaintenance).submit
  activity_offering.approve :navigate_to_page => false
  course_offering.get_ao_list << activity_offering
  @co_list = []
  @co_list << course_offering

  @calendar_target = create AcademicCalendar, :year => @calendar.year.to_i + 1 #,:name => "6aXt9C4nbM"
  term_target = make AcademicTermObject, :parent_calendar => @calendar_target
  @calendar_target.add_term term_target
  term_target.make_official

  @rollover = make Rollover, :target_term => @calendar_target.terms[0].term_code , :source_term => @calendar.terms[0].term_code
  @rollover.perform_rollover
  @rollover.wait_for_rollover_to_complete
  @rollover.release_to_depts
end

And(/^the instructional assignments are not copied to the target term AOs$/) do
  @co_list.each do |co|
    #confirm exist on target term
    co.term = @calendar.terms[0].term_code
    co.manage

    on ManageCourseOfferings do |page|
      page.ao_instructor('A').should == co.get_ao_list[0].personnel_list[0].name
      page.ao_instructor('B').should == co.get_ao_list[1].personnel_list[0].name
    end
  end
  @co_list.each do |co|
    #confirm exist on target term
    co.term = @calendar_target.terms[0].term_code
    co.manage

    on ManageCourseOfferings do |page|
      page.ao_instructor('A').should == ''
      page.ao_instructor('B').should == ''
    end
  end
end

Given(/^that a course code rollover configuration is defined for a specific course in the GES with a value of 'not copy' for scheduling information$/) do
  #no UI for this -- ENGL462 is configured in GES
end

And(/^the scheduling information.*is not copied to the target term AOs$/) do
  @co_list.each do |co|
    #confirm exist on target term
    co.term = @calendar_target.terms[0].term_code
    co.manage

    on ManageCourseOfferings do |page|
      ao_row = page.target_row('B')
      existing_sched_info = co.get_ao_list[1].get_existing_scheduling_information(ao_row)[0]
      existing_sched_info.nil?.should be_true
      ao_row.cells[ManageCourseOfferings::AO_BLDG].text = ''
      ao_row.cells[ManageCourseOfferings::AO_ROOM].text = ''
    end
  end
end


And(/^no specific rule is configured at the specific course code for Bldg\/Rm$/) do
  #no UI for this
end

But(/^a 'copy' Bldg\/Rm rule is configured at the term level that applies to the specified course code$/) do
  #no UI for this
end

Given(/^that a course code rollover configuration is defined for a specific course in the GES with a value of 'copy' for scheduling information$/) do
  #no UI for this
end

And(/^'not copy' for Bldg\/Rm$/) do
  #no UI for this
end

When(/^the rollover is executed for a term with the specific course with Bldg\/Rm and scheduling information rules$/) do
  @calendar = create AcademicCalendar #, :year => "2235", :name => "fSZtG62zfU"
  term = make AcademicTermObject, :parent_calendar => @calendar
  @calendar.add_term term

  @manage_soc = make ManageSoc, :term_code => @calendar.terms[0].term_code
  @manage_soc.set_up_soc
  @manage_soc.perform_manual_soc_state_change

  course_offering = make CourseOffering, :term=> @calendar.terms[0].term_code,
                         :course => "ENGL243"
  course_offering.delivery_format_list[0].format = "Lecture"
  course_offering.delivery_format_list[0].grade_format = "Lecture"
  course_offering.delivery_format_list[0].final_exam_activity = "Lecture"

  course_offering.create

  activity_offering_canceled = create ActivityOfferingObject, :parent_cluster =>  course_offering.default_cluster,
                                      :activity_type => "Lecture"
  si_obj =  make SchedulingInformationObject, :days => "TH",
                 :start_time => "11:00", :start_time_ampm => "am",
                 :end_time => "11:50", :end_time_ampm => "am",
                 :facility => 'TWS', :room => '1100'
  activity_offering_canceled.add_req_sched_info :rsi_obj => si_obj, :defer_save => true

  person = make PersonnelObject, :id => "KS-10175", :name => "SMITH, DAVID", :affiliation => "Instructor", :inst_effort => 30
  activity_offering_canceled.add_personnel person
  on(ActivityOfferingMaintenance).submit
  activity_offering_canceled.cancel :navigate_to_page => false
  course_offering.get_ao_list << activity_offering_canceled

  activity_offering = create ActivityOfferingObject, :parent_cluster => course_offering.default_cluster,
                             :activity_type => "Lecture"
  si_obj =  make SchedulingInformationObject, :days => "W",
                 :start_time => "09:00", :start_time_ampm => "am",
                 :end_time => "09:50", :end_time_ampm => "am",
                 :facility => 'KEY', :room => '0117'
  activity_offering.add_req_sched_info :rsi_obj => si_obj, :defer_save => true

  person = make PersonnelObject, :id => "KS-4611", :name => "KEY, ALAN", :affiliation => "Instructor", :inst_effort => 100
  activity_offering.add_personnel person
  on(ActivityOfferingMaintenance).submit
  activity_offering.approve :navigate_to_page => false
  course_offering.get_ao_list << activity_offering
  @co_list = []
  @co_list << course_offering

  @calendar_target = create AcademicCalendar, :year => @calendar.year.to_i + 1 #,:name => "6aXt9C4nbM"
  term_target = make AcademicTermObject, :parent_calendar => @calendar_target
  @calendar_target.add_term term_target
  term_target.make_official

  @rollover = make Rollover, :target_term => @calendar_target.terms[0].term_code , :source_term => @calendar.terms[0].term_code
  @rollover.perform_rollover
  @rollover.wait_for_rollover_to_complete
  @rollover.release_to_depts
end

Given(/^that a subject level rollover configuration has been defined for ENGL in the GES for a specific term type$/) do
  #no UI for this
end

And(/^there is a value of 'copy' for instructional assignments$/) do
  #no UI for this
end

When(/^the rollover is executed for the specified term type with ENGL courses not covered by a more granular rules$/) do
  @calendar = create AcademicCalendar #, :year => "2235", :name => "fSZtG62zfU"
  term = make AcademicTermObject, :parent_calendar => @calendar,
              :term => 'Summer I',
              :term_type => 'Summer 1',
              :term_name => "Summer 1 #{@calendar.year.to_i + 1}",
              :term_code => "#{@calendar.year.to_i + 1}05",
              :start_date => "05/12/#{@calendar.year.to_i + 1}",
              :end_date => "06/12/#{@calendar.year.to_i + 1}"
  @calendar.add_term term

  @manage_soc = make ManageSoc, :term_code => @calendar.terms[0].term_code
  @manage_soc.set_up_soc
  @manage_soc.perform_manual_soc_state_change

  course_offering = make CourseOffering, :term=> @calendar.terms[0].term_code,
                         :course => "ENGL211"
  course_offering.delivery_format_list[0].format = "Lecture"
  course_offering.delivery_format_list[0].grade_format = "Lecture"
  course_offering.delivery_format_list[0].final_exam_activity = "Lecture"

  course_offering.create

  activity_offering_canceled = create ActivityOfferingObject, :parent_cluster =>  course_offering.default_cluster,
                                      :activity_type => "Lecture"
  si_obj =  make SchedulingInformationObject, :days => "TH",
                 :start_time => "11:00", :start_time_ampm => "am",
                 :end_time => "11:50", :end_time_ampm => "am",
                 :facility => 'TWS', :room => '1100'
  activity_offering_canceled.add_req_sched_info :rsi_obj => si_obj, :defer_save => true

  person = make PersonnelObject, :id => "KS-10175", :name => "SMITH, DAVID", :affiliation => "Instructor", :inst_effort => 30
  activity_offering_canceled.add_personnel person
  on(ActivityOfferingMaintenance).submit
  activity_offering_canceled.cancel :navigate_to_page => false
  course_offering.get_ao_list << activity_offering_canceled

  activity_offering = create ActivityOfferingObject, :parent_cluster => course_offering.default_cluster,
                             :activity_type => "Lecture"
  si_obj =  make SchedulingInformationObject, :days => "W",
                 :start_time => "09:00", :start_time_ampm => "am",
                 :end_time => "09:50", :end_time_ampm => "am",
                 :facility => 'KEY', :room => '0117'
  activity_offering.add_req_sched_info :rsi_obj => si_obj, :defer_save => true

  person = make PersonnelObject, :id => "KS-4611", :name => "KEY, ALAN", :affiliation => "Instructor", :inst_effort => 100
  activity_offering.add_personnel person
  on(ActivityOfferingMaintenance).submit
  activity_offering.approve :navigate_to_page => false
  course_offering.get_ao_list << activity_offering
  @co_list = []
  @co_list << course_offering

  @calendar_target = create AcademicCalendar, :year => @calendar.year.to_i + 1 #,:name => "6aXt9C4nbM"
  term_target = make AcademicTermObject, :parent_calendar => @calendar_target,
                     :term => 'Summer I',
                     :term_type => 'Summer 1',
                     :term_name => "Summer 1 #{@calendar_target.year.to_i + 1}",
                     :term_code => "#{@calendar_target.year.to_i + 1}05",
                     :start_date => "05/12/#{@calendar_target.year.to_i + 1}",
                     :end_date => "06/12/#{@calendar_target.year.to_i + 1}"
  @calendar_target.add_term term_target
  term_target.make_official

  @rollover = make Rollover, :target_term => @calendar_target.terms[0].term_code , :source_term => @calendar.terms[0].term_code
  @rollover.perform_rollover
  @rollover.wait_for_rollover_to_complete
  @rollover.release_to_depts
end

Given(/^that a subject level rollover configuration has been defined for ENGL in the GES for a specific term$/) do
  #no UI for this
end

And(/^there is a value of 'not copy' for instructional assignments$/) do
  #no UI for this
end

And(/^'copy' for canceled Bldg\/Rm$/) do
  #no UI for this
end

When(/^the rollover is executed for the specified term$/) do
  @calendar = make AcademicCalendar , :year => '2018', :name => '2018-2019 Academic Calendar'
  term = make AcademicTermObject, :parent_calendar => @calendar,
              :term => 'Summer I',
              :term_type => 'Summer 1',
              :term_name => "Summer 1 #{@calendar.year.to_i + 1}",
              :term_code => "#{@calendar.year.to_i + 1}05",
              :start_date => "05/31/#{@calendar.year.to_i + 1}",
              :end_date => "07/08/#{@calendar.year.to_i + 1}"
  @calendar.terms << term

  @manage_soc = make ManageSoc, :term_code => @calendar.terms[0].term_code
  @manage_soc.set_up_soc
  @manage_soc.perform_manual_soc_state_change

  course_offering = make CourseOffering, :term=> @calendar.terms[0].term_code,
                         :course => "ENGL211"
  course_offering.delivery_format_list[0].format = "Lecture"
  course_offering.delivery_format_list[0].grade_format = "Lecture"
  course_offering.delivery_format_list[0].final_exam_activity = "Lecture"

  course_offering.create

  activity_offering_canceled = create ActivityOfferingObject, :parent_cluster =>  course_offering.default_cluster,
                                      :activity_type => "Lecture"
  si_obj =  make SchedulingInformationObject, :days => "TH",
                 :start_time => "11:00", :start_time_ampm => "am",
                 :end_time => "11:50", :end_time_ampm => "am",
                 :facility => 'TWS', :room => '1100'
  activity_offering_canceled.add_req_sched_info :rsi_obj => si_obj, :defer_save => true

  person = make PersonnelObject, :id => "KS-10175", :name => "SMITH, DAVID", :affiliation => "Instructor", :inst_effort => 30
  activity_offering_canceled.add_personnel person
  on(ActivityOfferingMaintenance).submit
  activity_offering_canceled.cancel :navigate_to_page => false
  course_offering.get_ao_list << activity_offering_canceled

  activity_offering = create ActivityOfferingObject, :parent_cluster => course_offering.default_cluster,
                             :activity_type => "Lecture"
  si_obj =  make SchedulingInformationObject, :days => "W",
                 :start_time => "09:00", :start_time_ampm => "am",
                 :end_time => "09:50", :end_time_ampm => "am",
                 :facility => 'KEY', :room => '0117'
  activity_offering.add_req_sched_info :rsi_obj => si_obj, :defer_save => true

  person = make PersonnelObject, :id => "KS-4611", :name => "KEY, ALAN", :affiliation => "Instructor", :inst_effort => 100
  activity_offering.add_personnel person
  on(ActivityOfferingMaintenance).submit
  activity_offering.approve :navigate_to_page => false
  course_offering.get_ao_list << activity_offering
  @co_list = []
  @co_list << course_offering

  @calendar_target = make AcademicCalendar, :year => '2019',:name => '2019-2020 Academic Calendar'
  term_target = make AcademicTermObject, :parent_calendar => @calendar_target,
                     :term => 'Summer I',
                     :term_type => 'Summer 1',
                     :term_name => "Summer 1 #{@calendar_target.year.to_i + 1}",
                     :term_code => "#{@calendar_target.year.to_i + 1}05",
                     :start_date => "05/12/#{@calendar_target.year.to_i + 1}",
                     :end_date => "06/12/#{@calendar_target.year.to_i + 1}"

  @calendar_target.terms << term_target

  @rollover = make Rollover, :target_term => @calendar_target.terms[0].term_code , :source_term => @calendar.terms[0].term_code
  @rollover.perform_rollover
  @rollover.wait_for_rollover_to_complete
  @rollover.release_to_depts
end