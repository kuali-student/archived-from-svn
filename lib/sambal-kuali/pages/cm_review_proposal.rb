class CmReviewProposal < BasePage

  wrapper_elements
  cm_elements

  action(:submit) { |b| b.button(text: 'Submit').click; b.loading_wait }
  action(:blanket_approve) { |b| b.button(text: 'Blanket Approve').click }
  action(:edit_course_information) { |b| b.a(id: "CourseInfo-Review-Edit-link").click }
  element(:review_proposal_header) { |b| b.div(id: "KS-CourseView-Header").p(class: "uif-viewHeader-supportTitle").text }

  # COURSE INFORMATION REVIEW FIELDS
  element(:proposal_title_element) { |b| b.textarea(id: "proposalInfo_name_control") }
  value(:proposal_title_review) { |b| b.proposal_title_element.text }
  value(:transcript_course_title) { |b| b.textarea(name: /transcriptTitle/).text}
  value(:course_title_review) { |b| b.textarea(id: "courseInfo_courseTitle_control").text }
  value(:subject_code_review) { |b| b.textarea(id:"courseInfo_subjectArea_control").text }
  value(:course_number_review) { |b| b.textarea(id: "courseInfo_courseNumberSuffix_control").text }
  value(:cross_listed_courses_review) { |b| b.textarea(id: "courseSection_crossListings_control").text }
  value(:jointly_offered_courses_review) { |b| b.textarea(id: "courseSection_jointly_offered_courses_control").text }
  value(:version_codes_review) { |b| b.textarea(id: "courseSection_Version_Codes_control" ).text}
  value(:instructors_review) { |b| b.textarea(id: 'courseSection_instructors_control').text }
  value(:description_review) { |b| b.textarea(id: "courseInfo_descr_control").text }
  value(:proposal_rationale_review) { |b| b.textarea(id: "proposalInfo_rationale_control").text }



  # COURSE INFORMATION READ-ONLY REVIEW FIELDS
  value(:proposal_title_review_read_only) { |b| b.div(id: "proposalInfo_name").text }
  value(:course_title_review_read_only) { |b| b.div(id: "courseInfo_courseTitle").text }


  # GOVERNANCE REVIEW FIELDS
  action(:edit_governance) { |b| b.a(id: "Governance-Review-Edit-link").click }
  value(:campus_locations_review) { |b| b.textarea(id: 'governanceSection_campusLocations_control').text }
  value(:curriculum_oversight_review) { |b| b.textarea(id: 'governanceSection_curriculumOversightAsString_control').text }
  value(:administering_org_review) { |b| b.textarea(id: 'governanceSection_administeringOrganization_control').text }


  # LOGISTICS REVIEW FIELDS
  action(:edit_course_logistics) { |b| b.a(id: "CourseLogistics-Review-Edit-link").click }
  value(:terms_review) { |b| b.textarea(id: 'courseLogisticsSection_terms_control').text }
  value(:duration_review) { |b| b.textarea(id: 'courseLogisticsSection_atpDurationType_control').text }
  value (:audit_review) { |b| b.textarea(id: 'courseLogisticsSection_audit_control').text }
  value(:pass_fail_transcript_review) { |b| b.textarea(id: 'courseLogisticsSection_passFail_control').text }


  value(:assessment_scale_review) { |b| b.textarea(id: "courseLogisticsSection_gradingOptions_control").text }
  value(:final_exam_status_review) { |b| b.textarea(id: "courseLogisticsSection_finalExamStatus_control").text }
  value(:final_exam_rationale_review) { |b| b.textarea(id: "courseLogisticsSection_finalExamStatusRationale_control").text }

  value(:outcome_level_review) { |outcome_level,b| b.div(id: "course_review_outcome_details").header(id: /line#{outcome_level-1}/).span(class: "uif-headerText-span").text }
  value(:outcome_type_review) { |outcome_level,b| b.div(id: "course_review_outcome_details").div(id: /line#{outcome_level-1}/, data_label: "Type").text }
  value(:outcome_credit_review) { |outcome_level,b| b.div(id: "course_review_outcome_details").div(id: /line#{outcome_level-1}/, data_label: "Credit Value").text }

  #LEARNING OBJECTIVES
  value(:lo_terms_review) { |lo_review,b| b.textarea(id: "learningObjectivesSection_learningObjectives_line#{lo_review-1}_control").text }
  value(:learning_objectives_summary_review) { |b| b.div(id: "course_review_learning_objectives").text }
  value(:learning_objectives_review) { |lo_level,b| b.div(id: "learning_objective_item_line#{lo_level-1}").text }
  element(:learning_objectives_empty_text) { |b| b.div(id: "emptyStringLOs") }

  #COURSE REQUISITES
  action(:expand_all_sections) { |b| b.link(text: '[+] expand all').click }
  action(:collapse_all_sections) { |b| b.link(text: '[-] collapse all').click }

  value(:prerequisites_operator_and_rules) {|b|b.div(id: "CoursePreview-AgendaManage-RulePrototype_ruleA_disclosureContent").text }
  value(:prerequisites_operator) {|b|b.li(id: "Course-ListItems-DataGroup_node1_node0_root").text }

  value(:corequisite_operator_and_rules) {|b|b.div(id: "CoursePreview-AgendaManage-RulePrototype_ruleB_disclosureContent").text }

  value(:preparation_operator_and_rules) {|b|b.div(id: "CoursePreview-AgendaManage-RulePrototype_ruleC_disclosureContent").text }

  value(:antirequisite_operator_and_rules) {|b|b.div(id: "CoursePreview-AgendaManage-RulePrototype_ruleD_disclosureContent").text }

  value(:restrictsCredits_operator_and_rules) {|b|b.div(id: "CoursePreview-AgendaManage-RulePrototype_ruleE_disclosureContent").text }

  value(:repeatableForCredit_operator_and_rules) {|b|b.div(id: "CoursePreview-AgendaManage-RulePrototype_ruleF_disclosureContent").text }

  #ACTIVITY FORMATS
  value(:activity_level_review) { |activity_level, b| b.div(id: "course_review_format_details").header(id: /line#{activity_level-1}/).span(class: "uif-headerText-span").text }
  value(:activity_type_review)  { |activity_level, b| b.div(id: "course_review_activity_details_line#{activity_level-1}").header(id: /line#{activity_level-1}_line#{activity_level-1}/).span(class: "uif-headerText-span").text }
  value(:activity_contact_hours_frequency_review) { |activity_level, b| b.div(id: "course_review_activity_details_line#{activity_level-1}").div(data_label: "Contact Hours").text }
  value(:activity_duration_type_count_review) { |activity_level, b| b.div(id: "course_review_activity_details_line#{activity_level-1}").div(data_label: "Duration").text }
  value(:activity_class_size_review) { |activity_level, b| b.div(id: "course_review_activity_details_line#{activity_level-1}").div(data_label: "Anticipated Class Size").text }

  # ACTIVE DATES REVIEW FIELDS
  action(:edit_active_dates) { |b| b.a(id: 'ActiveDates-Review-Edit-link').click }
  value(:start_term_review) { |b| b.textarea(id: "activeDatesSection_startTerm_control").text }
  value(:end_term_review) { |b| b.textarea(id: 'activeDatesSection_endTerm_control').text }
  value(:pilot_course_review) { |b| b.textarea(id: 'activeDatesSection_pilotCourse_control').text }

  # FINANCIAL FEES
  value(:fee_justification_review ) { |b| b.textarea(id: "financialsSection_justificationOfFees_control").text }

  #AUTHORS & COLLABORATORS
  value(:author_name_review) { |author_level,b| b.div(id: "course_review_authors_and_collaborators_details").header(id: /line#{author_level-1}/).span(class: "uif-headerText-span").text }
  value(:author_permission_review) { |author_level,b| b.div(id: "course_review_authors_and_collaborators_details").section(id: /line#{author_level-1}/).div(data_label: "Permissions").textarea(name: /permission/).text  }
  value(:action_request_review) { |author_level,b| b.div(id: "course_review_authors_and_collaborators_details").section(id: /line#{author_level-1}/).div(data_label: "Action Request").textarea(name: /action/).text }
  element(:empty_authors_collab_review) { |b| b.textarea(id: "emptyStringAuthorsAndCollaborators_control") }

  #SUPPORTING DOCS
  value(:supporting_docs_review) { |b| b.div(id: "supporting_document_review_section").text }
  element(:empty_supporting_docs_review) { |b| b.textarea(id: " ")}

  #SUBMIT
  action(:submit_proposal) { |b| b.button(text: "Submit").click; b.loading_wait }
  action(:submit_confirmation) { |b| b.div(class: "fancybox-outer").span(class: "ui-button-text", text: "Submit").click; b.loading_wait }
  value(:proposal_status) { |b| b.div(id: "KS-CourseView-LinkGroup").div(data_label: "Proposal Status").text }
end
