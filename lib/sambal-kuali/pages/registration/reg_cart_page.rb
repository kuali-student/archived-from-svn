class RegistrationCart < RegisterForCourseBase

  page_url "#{$test_site}/registration/index.jsp#/myCart"

  expected_element :credit_count_title

  #element(:item_count) { |b| b.span(id: "course_count") }
  element(:credit_count_title) { |b| b.div(id: "credit_count_title") }
  element(:register_button) { |b| b.button(id: "register") }
  action(:register) { |b| b.register_button.click }
  element(:register_confirm_button) { |b| b.button(id: "confirmRegistration") }
  action(:confirm_registration) { |b| b.register_confirm_button.click }

  element(:schedule_counts) { |b| b.span(id: "reg_course_count") }

  element(:course_code_input) { |b| b.text_field(id: "courseCode") }
  element(:reg_group_code_input) { |b| b.text_field(id: "regCode") }
  element(:submit_button) { |b| b.button(id: "submit") }
  action(:add_to_cart) { |b| b.submit_button.click }

  element(:credit_count_header) { |b| b.span(id: "credit_count_register_for_header") }

  element(:remove_course_button) { |course_code,reg_group_code,b| b.button(id: "remove_#{course_code}_#{reg_group_code}") }
  element(:course_code) { |course_code,reg_group_code,b| b.span(id: "course_code_#{course_code}_#{reg_group_code}") }
  element(:course_title) { |course_code,reg_group_code,b| b.div(id: "title_#{course_code}_#{reg_group_code}").text }
  element(:course_info_div) { |course_code,reg_group_code,b| b.div(id: "course_info_#{course_code}_#{reg_group_code}") }
  element(:course_info) { |course_code,reg_group_code,b| b.div(id: "course_info_#{course_code}_#{reg_group_code}").text }
  element(:grading_option_badge) { |course_code,reg_group_code,b| b.span(id: "grading_badge_#{course_code}_#{reg_group_code}") }
  element(:grading_option) { |course_code,reg_group_code,b| b.grading_option_badge(course_code,reg_group_code).text }
  element(:edit_course_options_button) { |course_code,reg_group_code,b| b.button(id: "edit_#{course_code}_#{reg_group_code}") }
  action(:edit_course_options) { |course_code,reg_group_code,b| b.edit_course_options_button(course_code,reg_group_code).click }
  element(:ao_type) { |course_code,reg_group_code,index,b| b.div(id: "ao_type_#{course_code}_#{reg_group_code}_#{index}").text }
  element(:course_schedule) { |course_code,reg_group_code,ao_index,index,b| b.div(id: "schedule_#{course_code}_#{reg_group_code}_#{ao_index}_#{index}").text }

  element(:user_message_div) { |b| b.div(id: "user_message") }
  element(:user_message) { |b| b.div(id: "user_message").text }
  element(:undo_remove_link) { |b| b.link(id: "userMessageInvoke") }
  action(:undo_remove) { |b| b.undo_remove_link.click }
  element(:result_status) { |course_code,reg_group_code,b| b.div(id: "result_status_#{course_code}_#{reg_group_code}").text }
  element(:add_to_waitlist_button) { |course_code,reg_group_code,b| b.button(id: "waitlist_#{course_code}_#{reg_group_code}") }

  # ADD NEW ITEM OPTIONS MODAL DIALOG
  element(:new_item_credits_selection) { |b| b.select(id: "newItemCredits") }
  element(:new_item_grading_audit) { |b| b.radio(id: "newItemGrading", value: "kuali.resultComponent.grade.audit") }
  element(:new_item_grading_letter) { |b| b.radio(id: "newItemGrading", value: "kuali.resultComponent.grade.letter") }
  element(:new_item_grading_pass_fail) { |b| b.radio(id: "newItemGrading", value: "kuali.resultComponent.grade.passFail") }
  element(:new_item_save_button) { |b| b.button(id: "newItemSave") }
  action(:save_new_item) { |b| b.new_item_save_button.click }
  element(:new_item_cancel_button) { |b| b.button(id: "newItemCancel") }
  action(:cancel_new_item) { |b| b.new_item_cancel_button.click }

  # EDIT COURSE OPTIONS DISCLOSURE
  element(:credits_selection) { |course_code,reg_group_code,b| b.select(id: "credits_#{course_code}_#{reg_group_code}") }
  element(:grading_audit) { |course_code,reg_group_code,b| b.radio(id: "grading_#{course_code}_#{reg_group_code}", value: "kuali.resultComponent.grade.audit") }
  element(:grading_letter) { |course_code,reg_group_code,b| b.radio(id: "grading_#{course_code}_#{reg_group_code}", value: "kuali.resultComponent.grade.letter") }
  element(:grading_pass_fail) { |course_code,reg_group_code,b| b.radio(id: "grading_#{course_code}_#{reg_group_code}", value: "kuali.resultComponent.grade.passFail") }
  element(:edit_save_button) { |course_code,reg_group_code,b| b.button(id: "save_#{course_code}_#{reg_group_code}") }
  action(:save_edits) { |course_code,reg_group_code,b| b.edit_save_button(course_code,reg_group_code).click }
  element(:edit_cancel_link) { |course_code,reg_group_code,b| b.link(id: "cancel_#{course_code}_#{reg_group_code}") }
  action(:cancel_edits) { |course_code,reg_group_code,b| b.edit_cancel_link(course_code,reg_group_code).click }

  def remove_course_from_cart(course_code, reg_group_code)
    remove_course_button(course_code,reg_group_code).click
  end

  def toggle_course_details(course_code, reg_group_code)
    course_code(course_code,reg_group_code).click
  end

  def select_credits_on_new_item(credits)
    new_item_credits_selection.select(credits)
  end

  def select_grading_on_new_item(grading_option)
    case grading_option
      when "Audit" then new_item_grading_audit.set
      when "Letter" then new_item_grading_letter.set
      when "Pass/Fail" then new_item_grading_pass_fail.set
    end
  end

  def select_credits_in_cart(course_code, reg_group_code, credits)
    credits_selection(course_code, reg_group_code).select(credits)
  end

  def select_grading_in_cart(course_code, reg_group_code, grading_option)
    case grading_option
      when "Audit" then grading_audit(course_code,reg_group_code).set
      when "Letter" then grading_letter(course_code,reg_group_code).set
      when "Pass/Fail" then grading_pass_fail(course_code,reg_group_code).set
    end
  end

  def find_user_message(message_text)
    begin
      wait_until { user_message_div.exists? }
      wait_until { user_message.include? message_text }
    rescue
      puts "Current exception: #{$!} "
      raise "\"#{message_text}\" not found in user message"
    end
  end

  def add_to_waitlist(course_code, reg_group_code)
    add_to_waitlist_button(course_code, reg_group_code).click
  end
end