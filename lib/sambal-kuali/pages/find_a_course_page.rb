class CmFindACoursePage < BasePage

  wrapper_elements
  cm_elements

  COURSE_CODE = 0
  COURSE_TITLE = 1
  COURSE_DESCRIPTION = 3

  # Example of options 'Spring 1980', 'Fall 1985'
  element(:course_code) { |b| b.text_field(id: "courseLookup_code_control") }
  element(:course_code_dirty_error) { |b| b.text_field(id:"courseLookup_code_control", class: /error/ ) }
  action(:find_courses) { |b| b.button(id: "courseLookup_searchButton").click; b.loading_wait }
  element(:results_table) { |b| b.table(id: "uLookupResults_layout") }
  element(:no_lookup_results) { |b| b.p(id: "KS-Uif-Message-ZeroLookupResults") }
  value(:no_lookup_results_text) { |b| b.p(id: "KS-Uif-Message-ZeroLookupResults").text }
  value(:validation_message) { |b| b.div(id: "Uif-ViewContentWrapper").ul(class: "uif-validationMessagesList").text }

  def results_list_course_code
    code_list = []
    results_table.rows.each do |row|
      sleep(1)
      code_list << row[COURSE_CODE].text
    end
    code_list.delete_if { |item| item == "Code" }
    code_list.delete_if {|item| item == "" }
    code_list
  end

end
