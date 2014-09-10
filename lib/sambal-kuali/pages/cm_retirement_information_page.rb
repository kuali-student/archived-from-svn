class CmRetirementInformation < BasePage

  wrapper_elements
  cm_elements

  links('Retirement Information')

  element(:retire_proposal_title) { |b| b.text_field(id: "CM-Proposal-RetireCourse-ProposalTitle_control") }
  element(:retirement_rationale) { |b| b.textarea(id: "CM-Proposal-RetireCourse-Rationale_control") }
  value(:start_term) { |b| b.textarea(id: "CM-Proposal-RetireCourse-StartTerm_control").text }
  element(:end_term) { |b| b.select_list(id: "CM-Proposal-RetireCourse-EndTerm_control") }
  element(:last_term_offered) { |b| b.select_list(id: "CM-Proposal-RetireCourse-LastTerm_control") }
  element(:last_catalog_pub_year) { |b| b.select_list(id: "CM-Proposal-RetireCourse-PublicationYear_control") }
  element(:other_comments) { |b| b.textarea(id: "CM-Proposal-RetireCourse-OtherComment_control") }
  action(:review_retire_proposal) { |b| b.a(id: "CM-Proposal-Course-Retire-ReviewProposalLink").click; b.loading_wait }

end
