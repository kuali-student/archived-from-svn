class CmCourseFinancials < BasePage

  wrapper_elements
  cm_elements

  element(:justification_of_fees) { |b| b.textarea(id: 'CourseView-Financials-Fee-Text_control') }

end
