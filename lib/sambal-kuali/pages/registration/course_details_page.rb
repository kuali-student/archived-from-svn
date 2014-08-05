class CourseDetailsPage < RegisterForCourseBase

  expected_element :details_course_credits_div

  # return to search
  element(:return_to_search_link) { |b| b.link(id: "returnToSearch") }
  action(:return_to_search) { |b| b.return_to_search_link.click }

  # header
  element(:details_course_code) { |b| b.span(id: "search_details_code").text }
  element(:details_course_title) { |b| b.span(id: "search_details_title").text }
  element(:details_course_credits_div) { |b| b.span(id: "search_details_credits") }
  element(:details_course_credits) { |b| b.details_course_credits_div.text }

  # description
  element(:details_course_description_div) { |course_code,b| b.div(id: "courseDescription_#{course_code}") }
  element(:details_course_description) { |course_code,b| b.details_course_description_div(course_code).text }

  # add to cart
  element(:add_to_cart_button) { |b| b.button(id: "search_details_add_to_cart") }
  action(:add_to_cart) { |b| b.add_to_cart_button.click }
  # add to cart confirmation dialog
  element(:edit_save_button) { |course_code,reg_group_code,context,b| b.button(id: "#{context}_save_#{course_code}_#{reg_group_code}") }
  action(:save_edits) { |course_code,reg_group_code,context,b| b.edit_save_button(course_code,reg_group_code,context).click }

  # heading
  element(:details_heading) { |activity_type, b| b.div(id: "#{activity_type}_details_heading") }

  # selected messages
  element(:selected_message) { |b| b.div(id: "one_ao_selected") }

  # activities
  element(:results_table) { |activity_type,b| b.table(id: "#{activity_type}_search_results_table") }
  element(:table_row) { |activity_type, ao_code, b| b.results_table(activity_type).row(id: "course_detail_row_#{ao_code}") }
  element(:select_box) { |ao_code, b| b.span(id: "select_#{ao_code}") }
  action(:toggle_ao_select) { |ao_code, b| b.select_box(ao_code).click }

  # Detail AO table column indexes
  AO_DAYS = 0
  AO_TIME = 1
  AO_INSTRUCTOR = 2
  AO_LOCATION = 3
  AO_SEATS = 4
  AO_SELECT = 5

  # course code in cart
  element(:cart_course_code) { |course_code,reg_group_code,b| b.span(id: "course_code_#{course_code}_#{reg_group_code}") }

end