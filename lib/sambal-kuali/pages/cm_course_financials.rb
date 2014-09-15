class CmCourseFinancialsPage < BasePage

  wrapper_elements
  cm_elements

  element(:justification_of_fees) { |b| b.text_field(id: 'CM-Proposal-Course-Financials-FeeText_control') }

end
