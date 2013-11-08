class KradCurriculum < BasePage

  #PageFactory
  wrapper_elements
  krad_elements

  links('Create a Course', 'Course Information', 'Governance', 'Course Logistics', 'Learning Objectives', 'Active Dates',
        'Financials', 'Supporting Documents', 'Review Proposal')

  action(:authors_collaborators) { |b| b.link(text: 'Authors & Collaborators').click }

end
