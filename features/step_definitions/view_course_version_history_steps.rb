Given(/^I find a course (.*?) with versions$/) do |view_course|

  outcome1 = make CmOutcomeObject, :outcome_type =>"Fixed", :outcome_level => 0, :credit_value => "3"
  format11 = (make CmFormatsObject,  :format_level => 1,
                   :activity_level => 1,
                   :type => "Lecture",
                   :contacted_hours => 3,
                   :contact_frequency => "per week",
                   :duration_count => nil,
                   :duration_type => nil,
                   :class_size => 0 )

  format21 = (make CmFormatsObject,  :format_level => 2,
                   :activity_level => 1,
                   :type => "Lecture",
                   :contacted_hours => 3,
                   :contact_frequency => "per week",
                   :duration_count => nil,
                   :duration_type => nil,
                   :class_size => 0 )

  format22 = (make CmFormatsObject,  :format_level => 2,
                   :activity_level => 2,
                   :type => "Discussion",
                   :contacted_hours => 3,
                   :contact_frequency => "per week",
                   :duration_count => nil,
                   :duration_type => nil,
                   :class_size => 0 )

  lo2_cat1 = (make CmLoCategoryObject,:category_name => "Writing - Skill",
                   :category_level => 1,
                   :category_selection => 1,
                   :auto_lookup => true,
                   :defer_save => true)

  if view_course == "ENGL212"
    @course = make CmCourseObject, :search_term => view_course, :course_code => view_course,
                   :subject_code => "ENGL", :course_number => "212",
                   :course_title => "English Literature: 1800 to the Present", :transcript_course_title => "ENGL LIT 1800-PRES",
                   :description => "Surveys the major literary movements of the period, from Romantic to Victorian to Modern. Such authors as Wordsworth, Keats, Bronte, Tennyson, Browning, Yeats, Joyce, Woolf.",
                   # GOVERNANCE
                   :campus_location => "North",
                   :curriculum_oversight => "ARHU-English",
                   # COURSE LOGISTICS
                   :assessment_scale => "Letter; Pass/Fail Grading",
                   :audit => "Yes",
                   :pass_fail_transcript_grade => "Yes",
                   :final_exam_status => "Standard Final Exam",
                   :outcome_list => [outcome1],
                   :format_list => [format11, format21, format22],
                   # ACTIVE DATES
                   :start_term => "Fall 2007",
                   :pilot_course => "No",
                   :course_state => "ACTIVE"

  else
    @course = make CmCourseObject, :search_term => view_course, :course_code => view_course,
                   :subject_code => "HIST", :course_number => "130",
                   :course_title => "Hot Spots: Violence, Catastrophe and Civilian Conflict in Worldwide Historical Perspectives", :transcript_course_title => "HOT SPOTS",
                   :description => "History behind late twentieth and early twenty-first century headlines; explores historical explanations for hot spots of unrest and civilian violence from the Congo to Srebrenica.",
                   # GOVERNANCE
                   :campus_location => "North",
                   :curriculum_oversight => "ARHU-History",
                   # COURSE LOGISTICS
                   :assessment_scale => "Letter; Pass/Fail Grading",
                   :audit => "Yes",
                   :pass_fail_transcript_grade => "Yes",
                   :final_exam_status => "Standard Final Exam",
                   :outcome_list => [outcome1],
                   :format_list => [format11, format21, format22],
                   # ACTIVE DATES
                   :start_term => "Spring 2012",
                   :pilot_course => "No",
                   :course_state => "ACTIVE"
  end

end

When(/^I view the version history$/) do
  @course.view_course
  on CmReviewProposal do |review|
    review.lookup_version_history
  end
end

Then(/^I can see the details of the course versions$/) do
  on CmCourseVersionHistoryPage do |page|
    page.version_history_version(0).text.should == '5'
    page.version_history_courseStatus(0).text.should == 'Active'
    page.version_history_startTerm(0).text.should == 'Fall 2007'
    page.version_history_endTerm(0).text.should == ''

    page.version_history_version(1).text.should == '4'
    page.version_history_courseStatus(1).text.should == 'Superseded'
    page.version_history_startTerm(1).text.should == 'Fall 1996'
    page.version_history_endTerm(1).text.should == 'Summer II 2007'

    page.version_history_version(4).text.should == '1'
    page.version_history_courseStatus(4).text.should == 'Superseded'
    page.version_history_startTerm(4).text.should == 'Spring 1980'
    page.version_history_endTerm(4).text.should == 'Summer II 1990'

  end
end

When(/^I select a single current version$/) do
  @course.view_course
  on CmReviewProposal do |review|
    review.lookup_version_history
  end
  on CmCourseVersionHistoryPage do |page|
    page.select_version_by_index(0)
    page.show_versions
    sleep 2
  end
end

Then(/^I can view the current course version details$/) do
  on CmReviewProposal do |review|
    review.not_current_version_section.present?.should == false
    review.course_title_review.should == @course.course_title
    review.transcript_course_title.should == @course.transcript_course_title
    review.subject_code_review.should == @course.subject_code
    review.course_number_review.should == @course.course_number
  end
end

Then(/^I cannot select more than two versions$/) do
  on CmCourseVersionHistoryPage do |page|
    #select 4 versions
    page.select_version_by_index(0)
    page.select_version_by_index(1)
    page.select_version_by_index(2)
    page.select_version_by_index(3)
    #but only 2 versions are selected
    checked = 0;
    for i in 0..4
      if(page.version_history_checkbox(i).set?)
        checked +=1
      end
    end
    checked.should == 2
  end
end

And(/^I cannot Show versions without any versions selected$/) do
  on CmCourseVersionHistoryPage do |page|
    #clear out all the selections
    for i in 0..4
      page.deselect_version_by_index(i)
    end
    (page.review_versions_button.disabled?).should == true
  end
end

When(/^I cancel out of the version history table$/) do
  on CmCourseVersionHistoryPage do |page|
      page.close_history_view
      if(page.alert.exists?)
        page.alert.ok
      end
  end
end

When(/^I select a single non\-current version$/) do
  @course.view_course
  on CmReviewProposal do |review|
    review.lookup_version_history
  end
  on CmCourseVersionHistoryPage do |page|
    page.select_version_by_index(1)
    page.show_versions
    sleep 2
  end
end

Then(/^I can view the non\-current course version details$/) do
  on CmReviewProposal do |review|
    review.not_current_version_section.present?.should == true
    review.course_title_review.should == "The Ancient World"
    review.transcript_course_title.should == "HIST120IENT WORLD"
    review.subject_code_review.should == @course.subject_code
    review.course_number_review.should == @course.course_number
  end
end

When(/^I select to view the current version$/) do
  on CmReviewProposal do |review|
    review.view_course_current_version
  end
end

When(/^I select two versions of a course$/) do
  @course.view_course
  on CmReviewProposal do |review|
    review.lookup_version_history
  end
  on CmCourseVersionHistoryPage do |page|
    page.select_version_by_index(0)
    page.select_version_by_index(1)
    page.show_versions
  end
end

Then(/^I can view both sets of the version details$/) do
  sleep 2
  on CmReviewProposal do |review|
    review.course_version1_number_review.text.should == "Version 2 (current version)"
    review.course_version2_number_review.text.should == "Version 1"

    review.course_title_ver1_review.text.should == @course.course_title
    review.course_title_ver2_review.text.should == "The Ancient World"

    review.transcript_course_ver1_title.text.should == @course.transcript_course_title
    review.transcript_course_ver2_title.text.should == "HIST120IENT WORLD"

    review.subject_code_ver1.text.should == @course.subject_code
    review.subject_code_ver2.text.should == @course.subject_code
    review.course_number_ver1.text.should == @course.course_number
    review.course_number_ver2.text.should == @course.course_number
  end
end

And(/^I can clearly see the data differences$/) do
  on CmReviewProposal do |review|
    review.course_version1_number_review.parent.parent.attribute_value("class") == "cm-compare-highlighter"
    review.course_title_ver1_review.parent.parent.attribute_value("class") == "cm-compare-highlighter"
    review.transcript_course_ver1_title.parent.parent.attribute_value("class") == "cm-compare-highlighter"
    review.start_term_ver1_review.parent.parent.attribute_value("class") == "cm-compare-highlighter"
    review.end_term_ver1_review.parent.parent.attribute_value("class") == "cm-compare-highlighter"
    end
end