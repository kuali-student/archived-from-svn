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
  element(:selected_section_span) { |b| b.span(id: "selected_reg_group_code") }
  element(:selected_section) { |b| b.selected_section_span.text }
  element(:add_to_cart_button) { |b| b.button(id: "search_details_add_to_cart") }
  action(:add_to_cart) { |b| b.add_to_cart_button.click }
  element(:in_cart_button) { |b| b.button(id: "search_details_in_cart") }
  # add to cart confirmation dialog
  element(:edit_save_button) { |course_code,reg_group_code,context,b| b.button(id: "#{context}_save_#{course_code}_#{reg_group_code}") }
  action(:save_edits) { |course_code,reg_group_code,context,b| b.edit_save_button(course_code,reg_group_code,context).click }

  element(:add_to_waitlist_button) { |b| b.button(id: "search_details_add_to_waitlist") }
  action(:direct_waitlist) { |b| b.add_to_waitlist_button.when_present.click }
  element(:add_button_dropdown) { |b| b.button(id: "search_details_add_dropdown") }
  element(:alt_add_to_cart_link) { |b| b.a(id: "alt_add_to_cart") }
  element(:direct_register_link) { |b| b.a(id: "direct_register") }
  action(:direct_register) { |b| b.direct_register_link.click }

  element(:reg_options_continue) { |course_code,reg_group_code,b| b.button(id: "directReg_save_#{course_code}_#{reg_group_code}") }
  element(:reg_options_cancel) { |course_code,reg_group_code,b| b.button(id: "directReg_cancel_#{course_code}_#{reg_group_code}") }
  element(:register_confirm_button) { |course_code,reg_group_code,b| b.button(id: "directReg_edit_#{course_code}_#{reg_group_code}") }
  element(:register_cancel_button) { |course_code,reg_group_code,b| b.button(id: "directReg_remove_#{course_code}_#{reg_group_code}") }
  element(:direct_register_popup_course) { |b| b.span(id: "direct_register_popup_course") }
  value(:direct_register_popup_reason_message) { |course_code,reg_group_code,b| b.span(id: "reason_message_#{course_code}_#{reg_group_code}").text }
  value(:direct_waitlist_message) { |course_code,reg_group_code,b| b.span(id: "waitlisted_#{course_code}_#{reg_group_code}").text }
  element(:direct_register_popup_button) { |course_code,reg_group_code,b| b.button(id: "course_remove_#{course_code}_#{reg_group_code}") }
  action(:close_direct_register_popup) { |course_code,reg_group_code,b| b.direct_register_popup_button(course_code,reg_group_code).click }

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
  AO_INDICATOR = 0
  AO_DAYS = 1
  AO_TIME = 2
  AO_INSTRUCTOR = 3
  AO_LOCATION = 4
  AO_SEATS = 5
  AO_SELECT = 6

  # course code in cart
  element(:cart_course_code) { |course_code,reg_group_code,b| b.span(id: "course_code_#{course_code}_#{reg_group_code}") }

end