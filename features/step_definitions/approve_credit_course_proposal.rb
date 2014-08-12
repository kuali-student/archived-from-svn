Given(/^I have a course proposal with approve fields partially completed submitted by (.*?)$/) do |proposal_author|
  log_in proposal_author, proposal_author

  if proposal_author == "fred"
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                                                    :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "ENGL" )],
                                                    :approve_fields => [(make CmApproveFieldsObject, :course_number => nil , :campus_location => nil)]
  elsif proposal_author == "alice"
    @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                                                      :curriculum_review_process => "Yes",
                                                      :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "ENGL" )],
                                                      :approve_fields => [(make CmApproveFieldsObject, :course_number => nil, :campus_location => nil)]
  end

  puts @course_proposal.proposal_title
  @course_proposal.submit_proposal
end

When(/^I am logged in as a (.*?)$/) do |reviewer|
  determine_reviewer(@course_proposal.submit_fields[0].subject_code)
end


And(/^I attempt to approve the course proposal as (.*?)$/) do |reviewer|
  log_in reviewer,reviewer
  navigate_rice_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)

end

And(/^I review the course proposal as (.*?)$/) do |reviewer|
  log_in reviewer,reviewer
  navigate_rice_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
  @course_proposal.review_proposal_action
end





=begin
And(/^I attempt to approve or acknowledge the course proposal as (.*?)$/) do
  log_in reviewer,reviewer
  navigate_rice_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
end
=end


Then(/^I cannot approve or acknowledge the incomplete proposal$/) do
  @course_proposal.review_proposal_action
  #TODO Add validation to check that Approve is disabled.
end


And(/^I approve the course proposal as (.*?)$/) do |reviewer|

  navigate_rice_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
  @course_proposal.review_proposal_action
  @course_proposal.approve_proposal
end


Then(/^I cannot approve the incomplete proposal$/) do
  @course_proposal.review_proposal_action
    on CmReviewProposal do |proposal|
      proposal.approve_button_disabled.exists?.should be_true #currently has a bug fixed by KSCM-1648
    end
end

Given(/^I have a course proposal with approve fields submitted by (.*?)$/) do |proposal_author|
  log_in proposal_author, proposal_author

  if proposal_author == "fred"

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                                                    :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "CHEM")],
                                                    :approve_fields => [(make CmApproveFieldsObject, :course_number => "#{(900..999).to_a.sample}")]

  elsif proposal_author == "alice"
    @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                                                      :curriculum_review_process => "Yes",
                                                      :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "CHEM")],
                                                      :approve_fields => [(make CmApproveFieldsObject, :course_number => "#{(900..999).to_a.sample}" )]
  end

  puts @course_proposal.proposal_title
  @course_proposal.submit_proposal
end



Given(/^I have a course proposal with some approve fields missing submitted by (.*?)$/) do |proposal_author|
  log_in proposal_author,proposal_author

  if proposal_author == "fred"

    @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                              :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "ENGL")],
                              :approve_fields => [(make CmApproveFieldsObject, :transcript_course_title => nil, :format_list => [])]

  elsif proposal_author == "alice"
    @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                              :curriculum_review_process => "Yes",
                              :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "ENGL")],
                              :approve_fields => [(make CmApproveFieldsObject, :transcript_course_title => nil, :format_list => [])]
  end

  puts "Proposal Title: #{@course_proposal.proposal_title}"
  puts "Course Title: #{@course_proposal.course_title}"
  @course_proposal.submit_proposal

end


And(/^I complete the missing fields on the proposal and approve as (.*?)$/) do |reviewer|

  @course_proposal.edit :defer_save => true
  @course_proposal.approve_fields[0].edit :transcript_course_title => random_alphanums(5,'test transcript '),
                                          :defer_save => true

  @course_proposal.approve_fields[0].add_format :format => (make CmFormatsObject, :format_level=> 1,
                                                                                  :activity_level => 1,
                                                                                  :type => '::random::',
                                                                                  :contacted_hours => (1..9).to_a.sample,
                                                                                  :contact_frequency => '::random::',
                                                                                  :duration_count => (1..9).to_a.sample,
                                                                                  :duration_type => '::random::',
                                                                                  :class_size => (1..9).to_a.sample)


  on(CmCourseInformation).review_proposal
  @course_proposal.approve_proposal

end

Then(/^missing fields are highlighted and proposal cannot be approved$/) do
    on CmReviewProposal do |review_proposal|
      review_proposal.transcript_course_title_error.exists?.should be_true
      review_proposal.activity_format_error.exists?.should be_true
    end
end



Then(/^the course proposal is successfully approved$/) do
  on CmReviewProposal do |review|
    review.growl_text.should include "Document was successfully approved"
  end
  steps %{Given I am logged in as Curriculum Specialist}
  navigate_rice_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
  @course_proposal.review_proposal_action

  on CmReviewProposal do |review|
    review.proposal_status.should include "Approved"
  end
end

Then(/^I see successful approve messaging$/) do
on CmReviewProposal do |review|
  review.growl_text.should == "Document was successfully approved"
end
end

And(/^the new course is Active$/) do
  steps %{Given I am logged in as Faculty}
  @course = make CmCourseObject, :search_term => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                                 :course_state => "Active"
  @course.search_for_course
  @course.view_course
  on CmReviewProposal do |course_review|
    course_review.course_state_review.capitalize.should include @course.course_state #has a bug KSCM-2564
    #COURSE INFORMATION
    course_review.course_title_review.should include @course.course_title
    "#{course_review.subject_code_review}""#{course_review.course_number_review}".should include @course.course_code
    course_review.description_review.should include @course.description
  end
end


When(/^I have a credit course admin proposal with approve fields partially completed created as Curriculum Specialist$/) do
  steps %{Given I am logged in as Curriculum Specialist}
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                            :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "ENGL")],
                            :approve_fields => [(make CmApproveFieldsObject, :course_number => "#{(900..999).to_a.sample}",
                                                                             :transcript_course_title => nil,
                                                                             :campus_location => nil)]

  puts @course_proposal.proposal_title
end


When(/^I approve and activate the proposal$/) do
  @course_proposal.approve_activate_proposal
end


Then(/^missing fields are highlighted and proposal cannot be approved or activated$/) do
 on CmCourseInformation do |proposal|
   proposal.course_information unless proposal.current_page('Course Information').exists?
   proposal.transcript_course_title_error.exists?.should be_true
   proposal.page_validation_header.should include "Transcript Course Title"
   #TODO missing Campus location does not come up.
 end
end


Given(/^I have a credit course admin proposal with approve fields completed created as Curriculum Specialist$/) do
  steps %{Given I am logged in as Curriculum Specialist}
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                            :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "ENGL")],
                            :approve_fields => [(make CmApproveFieldsObject, :course_number => "#{(900..999).to_a.sample}" )]


end

Then(/^the proposal is successfully approved$/) do
  steps %{Given I am logged in as Curriculum Specialist}
  @course_proposal.search(@course_proposal.proposal_title)
  @course_proposal.review_proposal_action
  on CmReviewProposal do |proposal|
    proposal.proposal_status.should == "Approved"
  end
end


Given(/^I have a course proposal with submit fields submitted by (.*?)$/) do |proposal_author|
  log_in proposal_author,proposal_author

  if proposal_author == "fred"

    @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                              :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "ENGL")],
                              :approve_fields => [(make CmApproveFieldsObject, :transcript_course_title => nil,
                                                                                :course_number => nil,
                                                                                :campus_location => nil,
                                                                                :format_list => [])]


  elsif proposal_author == "alice"
    @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                              :curriculum_review_process => "Yes",
                              :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "ENGL")],
                              :approve_fields => [(make CmApproveFieldsObject, :transcript_course_title => nil,
                                                        :course_number => nil,
                                                        :campus_location => nil,
                                                        :format_list => [])]


  end
  puts "Proposal Title: #{@course_proposal.proposal_title}"
  puts "Course Title: #{@course_proposal.course_title}"
  @course_proposal.submit_proposal

end


When(/^I attempt to blanket approve the course proposal as Curriculum Specialist$/) do
  steps %{Given I am logged in as Curriculum Specialist}
  navigate_rice_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
  @course_proposal.review_proposal_action
  @course_proposal.blanket_approve

end


And(/^I cannot blanket approve the incomplete proposal$/) do
  on CmReviewProposal do |review|
    review.transcript_course_title_error.exists?.should be_true
    review.course_number_review_error_state.exists?.should be_true
    review.campus_locations_error.exists?.should be_true
    review.activity_format_error.exists?.should be_true
    review.proposal_status == "Enroute"
  end
end


When(/^I edit the course proposal as CS$/) do
   @course_proposal.edit :defer_save => true


   @course_proposal.approve_fields[0].edit :transcript_course_title => random_alphanums(5,'test transcript '),
                                           :course_number => "#{(900..999).to_a.sample}",
                                           :defer_save => true

   @course_proposal.approve_fields[0].add_campus


   @course_proposal.approve_fields[0].add_format :format => (make CmFormatsObject, :format_level=> 1,
                                                                  :activity_level => 1,
                                                                  :type => '::random::',
                                                                  :contacted_hours => (1..9).to_a.sample,
                                                                  :contact_frequency => '::random::',
                                                                  :duration_count => (1..9).to_a.sample,
                                                                  :duration_type => '::random::',
                                                                  :class_size => (1..9).to_a.sample)


end

Then(/^I can blanket approve the course proposal$/) do
  navigate_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
  @course_proposal.review_proposal_action
  @course_proposal.blanket_approve
  @course_proposal.blanket_approve_with_rationale

  on CmReviewProposal do |review|
    review.growl_text.should include "Document was successfully approved"
  end
end