class CmReviewProposal < BasePage

  wrapper_elements
  cm_elements

  action(:submit) { |b| b.button(text: 'Submit').click; b.loading_wait }
  action(:edit_course_information) { |b| b.a(id: "CM-Proposal-Review-CourseInfo-Edit-Link").click }
  element(:review_proposal_header) { |b| b.div(id: "CM-Proposal-Course-Create-Header").p(class: "uif-viewHeader-supportTitle").text }

  # COURSE INFORMATION REVIEW FIELDS
  element(:proposal_title_element) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-Proposal-Name_control") }
  value(:proposal_title_review) { |b| b.proposal_title_element.text }
  value(:transcript_course_title) { |b| b.textarea(name: /transcriptTitle/).text}
  element(:transcript_course_title_error) { |b| b.div(data_label: "Transcript Course Title", class: /hasError/ ) }
  value(:course_title_review) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-Course-Title_control").text }
  value(:subject_code_review) { |b| b.textarea(id:"CM-ViewCourseView-CourseInfo-Subject-Area_control").text }
  value(:course_number_review) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-CourseNumberSuffix_control").text }
  element(:course_number_review_error_state) { |b| b.div(id: "CM-ViewCourseView-CourseInfo-CourseNumberSuffix", class: /hasError/) }
  value(:cross_listed_courses_review) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-CrossListings_control").text }
  value(:jointly_offered_courses_review) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-JointlyOfferedCourses_control").text }
  value(:version_codes_review) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-Version-Codes_control" ).text}
  value(:instructors_review) { |b| b.textarea(id: 'CM-ViewCourseView-CourseInfo-Instructors_control').text }
  value(:description_review) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-Descr_control").text }
  value(:proposal_rationale_review) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-Rationale_control").text }



  # COURSE INFORMATION READ-ONLY REVIEW FIELDS
  value(:proposal_title_review_read_only) { |b| b.div(id: "CM-ViewCourseView-CourseInfo-Proposal-Name").text }
  value(:course_title_review_read_only) { |b| b.div(id: "CM-ViewCourseView-CourseInfo-Course-Title").text }


  # GOVERNANCE REVIEW FIELDS
  action(:edit_governance) { |b| b.a(id: "CM-ViewCourseView-Logistics-Edit-Link").click }
  value(:campus_locations_review) { |b| b.textarea(id: 'CM-ViewCourseView-Governance-CampusLocations_control').text }
  element(:campus_locations_error) { |b| b.div(id:"CM-ViewCourseView-Governance-CampusLocations", class: /hasError/) }
  value(:curriculum_oversight_review) { |b| b.textarea(id: 'CM-ViewCourseView-Governance-CurriculumOversight_control').text }
  element(:curriculum_oversight_error_state) { |b| b.textarea(id: "CM-ViewCourseView-Governance-CurriculumOversight", class: /hasError/) }
  value(:administering_org_review) { |b| b.textarea(id: 'CM-ViewCourseView-Governance-AdministeringOrganization_control').text }


  # LOGISTICS REVIEW FIELDS
  action(:edit_course_logistics) { |b| b.a(id: "CourseLogistics-Review-Edit-link").click }
  value(:terms_review) { |b| b.textarea(id: 'CM-ViewCourseView-Logistics-Terms_control').text }
  value(:duration_review) { |b| b.textarea(id: 'CM-ViewCourseView-Logistics-DurationType_control').text }
  value (:audit_review) { |b| b.textarea(id: 'CM-ViewCourseView-Logistics-Audit_control').text }
  value(:pass_fail_transcript_review) { |b| b.textarea(id: 'CM-ViewCourseView-Logistics-PassFail_control').text }


  value(:assessment_scale_review) { |b| b.textarea(id: "CM-ViewCourseView-Logistics-GradingOptions_control").text }
  value(:final_exam_status_review) { |b| b.textarea(id: "CM-ViewCourseView-Logistics-FinalExamStatus_control").text }
  value(:final_exam_rationale_review) { |b| b.textarea(id: "CM-ViewCourseView-Logistics-FinalExamRationale_control").text }

  value(:outcome_level_review) { |outcome_level,b| b.div(id: "CM-ViewCourseView-Outcome-Details").header(id: /line#{outcome_level-1}/).span(class: "uif-headerText-span").text }
  value(:outcome_type_review) { |outcome_level,b| b.div(id: "CM-ViewCourseView-Outcome-Details").div(id: /line#{outcome_level-1}/, data_label: "Type").text }
  value(:outcome_credit_review) { |outcome_level,b| b.div(id: "CM-ViewCourseView-Outcome-Details").div(id: /line#{outcome_level-1}/, data_label: "Credit Value").text }
  element(:outcome_error_state) { |b| b.div(data_label: "Outcomes", class: /hasError/) }

  element(:outcome_empty_text) { |b| b.textarea(name: /.*courseLogisticsSection.emptyStringOutcomes/) }

  #LEARNING OBJECTIVES
  value(:lo_terms_review) { |lo_review,b| b.textarea(id: "learningObjectivesSection_learningObjectives_line#{lo_review-1}_control").text }
  value(:learning_objectives_summary_review) { |b| b.div(id: "course_review_learning_objectives").text }
  value(:learning_objectives_review) { |lo_level,b| b.div(id: "CM-ViewCourseView-LearningObjectives-Item_line#{lo_level-1}").text }
  element(:learning_objectives_empty_text) { |b| b.div(id: "emptyStringLOs") }

  #COURSE REQUISITES
  #Student Eligibility & Prerequisite
  value(:prerequisites_operators_and_rules) {|b|b.div(id: "CM-Proposal-Course-AgendaManage-ViewRule_ruleA").text }
  value(:prerequisites_rule) {|line, b|b.div(:id => /CM-Proposal-Course-ListItems-DataGroup_node#{line}_node0_root/).text }
  value(:prerequisites_operator) {|index, b|b.div(:id => /CM-Proposal-Course-ListItems-DataGroup_node#{index}_node0_root/).text }
  #Corequisite
  value(:corequisite_operators_and_rules) {|b|b.div(id: "CM-Proposal-Course-AgendaManage-ViewRule_ruleB").text }

  #Recommended Preparation
  value(:preparation_operators_and_rules) {|b|b.div(id: "CM-Proposal-Course-AgendaManage-ViewRule_ruleC").text }

  #Antirequisite
  value(:antirequisite_operators_and_rules) {|b|b.div(id: "CM-Proposal-Course-AgendaManage-ViewRule_ruleD").text }

  #Repeatable for Credit
  value(:repeatableForCredit_operators_and_rules) {|b|b.div(id: "CM-Proposal-Course-AgendaManage-ViewRule_ruleE").text }

  #Course that Restricts Credits
  value(:restrictsCredits_operators_and_rules) {|b|b.div(id: "CM-Proposal-Course-AgendaManage-ViewRule_ruleF").text }

  #ACTIVITY FORMATS
  element(:activity_format_review_section) { |b| b.div(id:"CM-ViewCourseView-Format-Details") }
  value(:format_level_review) { |format_level, b| b.activity_format_review_section.header(id: /.*_line#{format_level-1}/).h5(class: "course_detail_subsection_header").span(class: "uif-headerText-span").text }
  value(:activity_level_review) { |activity_level, b| b.activity_format_review_section.header(id: /line#{activity_level-1}/).span(class: "uif-headerText-span").text }
  value(:activity_type_review)  { |activity_level, b| b.activity_format_review_section.header(id: /line#{activity_level-1}_line#{activity_level-1}/).span(class: "uif-headerText-span").text }
  value(:activity_type)  { |format_level, activity_level, b| b.activity_format_review_section.header(id: /line#{format_level-1}_line#{activity_level-1}/).span(class: "uif-headerText-span").text }
  value(:activity_contact_hours_frequency_review) { |activity_level, b| b.activity_format_review_section.table(id: /line#{activity_level-1}/).div(data_label: "Contact Hours").text }
  value(:activity_duration_type_count_review) { |activity_level, b| b.activity_format_review_section.table(id: /line#{activity_level-1}/).div(data_label: "Duration").text }
  value(:activity_class_size_review) { |activity_level, b| b.activity_format_review_section.table(id: /line#{activity_level-1}/).div(data_label: "Anticipated Class Size").text }
  element(:activity_format_error) { |b|b.div(id: "emptyStringFormats", class: /hasError/) }

  # ACTIVE DATES REVIEW FIELDS
  action(:edit_active_dates) { |b| b.a(id: 'ActiveDates-Review-Edit-link').click }
  value(:start_term_review) { |b| b.textarea(id: "CM-ViewCourseView-ActiveDates-StartTerm_control").text }
  value(:end_term_review) { |b| b.textarea(id: 'CM-ViewCourseView-ActiveDates-EndTerm_control').text }
  value(:pilot_course_review) { |b| b.textarea(id: 'CM-ViewCourseView-ActiveDates-PilotCourse_control').text }

  # FINANCIAL FEES
  value(:fee_justification_review ) { |b| b.textarea(id: "CM-Proposal-Review-Financials-FeeJustification_control").text }

  #AUTHORS & COLLABORATORS
  value(:author_name_review) { |author_level,b| b.div(id: "CM-Proposal-Review-AuthorsCollaborators-Section").header(id: /line#{author_level-1}/).span(class: "uif-headerText-span").text }
  value(:author_permission_review) { |author_level,b| b.div(id: "CM-Proposal-Review-AuthorsCollaborators-Section").section(id: /line#{author_level-1}/).div(data_label: "Permissions").textarea(name: /permission/).text  }
  value(:action_request_review) { |author_level,b| b.div(id: "CM-Proposal-Review-AuthorsCollaborators-Section").section(id: /line#{author_level-1}/).div(data_label: "Action Request").textarea(name: /action/).text }
  element(:empty_authors_collab_review) { |b| b.textarea(id: "emptyStringAuthorsAndCollaborators_control") }

  #SUPPORTING DOCS
  value(:supporting_docs_review) { |b| b.div(id: "CM-Proposal-Review-SupportingDocuments-Section").text }
  element(:empty_supporting_docs_review) { |b| b.textarea(id: " ")}

  #SUBMIT
  element(:submit_button) { |b| b.button(text: "Submit")}
  action(:submit_proposal) { |b| b.button(text: "Submit").click; b.loading_wait }
  action(:submit_confirmation) { |b| b.div(class: "fancybox-outer").span(class: "ui-button-text", text: "Submit").click; b.loading_wait }
  value(:proposal_status) { |b| b.div(id: "KS-CourseView-LinkGroup").div(data_label: "Proposal Status").text }

  #APPROVE
  element(:approve_button) { |b| b.button(text: "Approve") }
  element(:approve_button_disabled) { |b| b.button(text: "Approve", class: /disabled/) }
  action(:review_approval) { |b| b.approve_button.click; b.loading_wait }
  element(:decision_rationale) { |b| b.div(class: "fancybox-inner").textarea(id: "CM-Approve-Dialog-Explanation_control") }
  element(:blanket_approve_rationale) { |b| b.div(class: "fancybox-inner").textarea(id: "CM-BlanketApprove-Dialog-Explanation_control") }
  element(:return_rationale) { |b| b.div(class: "fancybox-inner").textarea(id: "CM-ReturnToPrevious-Dialog-Explanation_control") }
  action(:confirmation_approval) { |b| b.div(class: "fancybox-inner").span(class: "ui-button-text", text: "Approve").click }
  element(:blanket_approve_button) { |b| b.button(text: "Blanket Approve") }
  element(:blanket_approve_disabled) { |b| b.button(text: "Blanket Approve", class: /disabled/)}
  action(:blanket_approve) { |b| b.blanket_approve_button.click; b.loading_wait }

  element(:review_button) { |b| b.button(text: "Return to Previous") }
  action(:review_return) { |b| b.review_button.click; b.loading_wait  }
  action(:confirm_return) { |b| b.div(class: "fancybox-inner").span(class: "ui-button-text", text: "Return").click }
  element(:return_to_node_list) { |b| b.div(class: "fancybox-inner").select_list(id: "CM-ReturnToPrevious-Dialog-NodeNamesDropdown_control") }

  #COURSE STATUS
  value(:course_state_review) { |b| b.div(id: /CM-ViewCourse-View/).text }
end
