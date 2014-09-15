class CmRetireProposalReviewPage < CmReviewProposalPage

  #wrapper_elements
  #cm_elements

  value(:course_number_retire_review) { |b| b.textarea(id: "CM-Proposal-Review-RetireCourse-Number_control").text }
  value(:course_title_retire_review) { |b| b.textarea(id: "CM-Proposal-Review-RetireCourse-Title_control").text }
  value (:cross_listed_course_retire_review) { |b| b.textarea(id: "CM-Proposal-Review-RetireCourse-Joint-Crosslisted-Courses_control").text }
  value(:curriculum_oversight_retire_review) { |b| b.textarea(id: "CM-Proposal-Review-RetireCourse-CurricOversight_control").text }
  value(:proposal_title_retire_review) { |b| b.textarea(id:"CM-Proposal-Review-RetireCourse-Proposal-Name_control").text }
  value(:retirement_rationale_retire_review) { |b| b.textarea(id:"CM-Proposal-Review-RetireCourse-Rationale_control").text }
  value(:start_term_retire_review) { |b| b.textarea(id:"CM-Proposal-Review-RetireCourse-StartTerm_control").text }
  value(:end_term_retire_review) { |b| b.textarea(id:"CM-Proposal-Review-RetireCourse-EndTerm_control").text }
  value(:last_term_offered_retire_review) { |b| b.textarea(id:"CM-Proposal-Review-RetireCourse-LastTerm_control").text }
  value(:last_catalog_pub_year_retire_review) { |b| b.textarea(id:"CM-Proposal-Review-RetireCourse-PublicationYear_control").text }
  value(:other_comments_retire_review) { |b| b.textarea(id:"CM-Proposal-Review-RetireCourse-OtherComment_control").text }


end