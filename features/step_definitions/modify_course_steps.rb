Given(/^there is a course (.*?) without a draft version$/) do |view_course|
  outcome1 = make CmOutcomeObject, :outcome_type =>"Fixed", :outcome_level => 0, :credit_value => "3"

  if view_course == "BMGT202"
    @course = make CmCourseObject, :search_term => view_course, :course_code => view_course,
                   :subject_code => "BMGT", :course_number => "202",
                   :course_title => "Decision Models with Spreadsheets", :transcript_course_title => "DCSN MODELS SPREADSHEETS",
                   :description => "The main objective is to teach how to solve problems arising in modern business environments using a spreadsheet application. The course will begin by teaching common tools available in popular spreadsheet applications. Then it will introduce the students to a variety of analytical problems arising in modern businesses and present ways in which these problems can be solved using spreadsheet applications.",
                   # GOVERNANCE
                   :campus_location => "North",
                   :curriculum_oversight => "BMGT-Robert H. Smith School of Business",
                   # COURSE LOGISTICS
                   :assessment_scale => "Pass/Fail Grading; Letter",
                   :audit => "Yes",
                   :pass_fail_transcript_grade => "Yes",
                   :final_exam_status => "Standard Final Exam",
                   :outcome_list => [outcome1],
                   # ACTIVE DATES
                   :start_term => "Fall 2009",
                   :pilot_course => "No",
                   :course_state => "ACTIVE"

  else
    @course = make CmCourseObject, :search_term => view_course, :course_code => view_course,
                   :subject_code => "BMGT", :course_number => "230",
                   :course_title => "Business Statistics", :transcript_course_title => "BUSINESS STATISTICS",
                   :description => "Introductory course in probabilistic and statistical concepts including descriptive statistics, set-theoretic development of probability, the properties of discrete and continuous random variables, sampling theory, estimation, hypothesis testing, regression and decision theory and the application of these concepts to problem solving in business and the application of these concepts to problem solving in business and management.",
                   # GOVERNANCE
                   :campus_location => "North",
                   :curriculum_oversight => "BMGT-Robert H. Smith School of Business",
                   # COURSE LOGISTICS
                   :assessment_scale => "Pass/Fail Grading; Letter",
                   :audit => "Yes",
                   :pass_fail_transcript_grade => "Yes",
                   :final_exam_status => "Standard Final Exam",
                   :outcome_list => [(outcome1)],
                   # ACTIVE DATES
                   :start_term => "Winter 2012",
                   :pilot_course => "No",
                   :course_state => "ACTIVE"
  end

  @course.view_course

end

When(/^I create a modify course proposal as Faculty$/) do
  on(CmReviewProposal).faculty_modify_course

end

Then(/^I can review the modify course proposal details compared to the course$/) do

end

Given(/^there is a course (.*?) with a draft version$/) do |view_course|

  @course = make CmCourseObject, :search_term => view_course, :course_code => view_course,
                 :subject_code => "BMGT", :course_number => "230",
                 :course_title => "Business Statistics", :transcript_course_title => "BUSINESS STATISTICS",
                 :description => "Introductory course in probabilistic and statistical concepts including descriptive statistics, set-theoretic development of probability, the properties of discrete and continuous random variables, sampling theory, estimation, hypothesis testing, regression and decision theory and the application of these concepts to problem solving in business and the application of these concepts to problem solving in business and management.",
                 # GOVERNANCE
                 :campus_location => "North",
                 :curriculum_oversight => "BMGT-Robert H. Smith School of Business",
                 # COURSE LOGISTICS
                 :assessment_scale => "Pass/Fail Grading; Letter",
                 :audit => "Yes",
                 :pass_fail_transcript_grade => "Yes",
                 :final_exam_status => "Standard Final Exam",
                 :outcome_list => [(make CmOutcomeObject, :outcome_type =>"Fixed", :outcome_level => 0, :credit_value => "3")],
                 # ACTIVE DATES
                 :start_term => "Winter 2012",
                 :pilot_course => "No",
                 :course_state => "ACTIVE"

  @course.view_course

end

When(/^I attempt to create a modify course proposal of the course as Faculty$/) do
  on(CmReviewProposal).modify_course
end

Then(/^I do not have the option to modify the course$/) do
  #no modify button is present
  (on(CmReviewProposal).modify_button.exist?).should == false
end

Given(/^there is a modify course proposal created as Faculty$/) do
  steps %{Given I am logged in as Faculty}

end


Then(/^I cannot yet submit the modify course proposal$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I complete the required for submit fields on the modify course proposal$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I can submit the modify course proposal$/) do
  pending # express the regexp above with the code you wish you had
end

And(/^I perform a full search for the modify course proposal$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I can see updated status of the modify course proposal$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I submit a modify course proposal as Faculty$/) do
  steps %{Given I am logged in as Faculty}
end

And(/^I Blanket Approve the modify course proposal as CS adding an end term for the version to be superseded$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^the modify course proposal is successfully approved$/) do
  pending # express the regexp above with the code you wish you had
end

And(/^the Superseded version has a new end term and the new course version is Active$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I modify a course without a draft version$/) do
  @course = make CmCourseObject, :search_term => "BMGT231", :course_code => "BMGT231",
                 :subject_code => "BMGT", :course_number => "231",
                 :course_title => "Statistical Models For Business", :transcript_course_title => "STAT MODELS BUSINESS",
                 :description => "An introductory course in statistical concepts, including probability from a naive set theory approach, random variables and their properties and the probability distributions of selected discrete and continuous random variables. The concepts of sampling and sampling distributions and the application of these concepts to estimation and hypothesis testing are included as are brief surveys of the regression and ANOVA models.",                 # GOVERNANCE
                 :campus_location => "North",
                 :curriculum_oversight => "BMGT-Robert H. Smith School of Business",
                 # COURSE LOGISTICS
                 :assessment_scale => "Letter; Pass/Fail Grading",
                 :audit => "Yes",
                 :pass_fail_transcript_grade => "Yes",
                 :final_exam_status => "Standard Final Exam",
                 :outcome_list => [(make CmOutcomeObject, :outcome_type =>"Fixed", :outcome_level => 0, :credit_value => "3")],
                 # ACTIVE DATES
                 :start_term => "Spring 1989",
                 :pilot_course => "No",
                 :course_state => "ACTIVE"

  @course.view_course
  on(CmReviewProposal).modify_course
  on CmCreateCourseStart do |page|
    page.modify_course_new_version.click
    page.curriculum_review_process.set
    page.continue
  end
end

Then(/^I can review the modify proposal compared to the course$/) do
  sleep 5
end
