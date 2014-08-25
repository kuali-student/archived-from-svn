class AdminRegistration < BasePage

  expected_element :student_info_input

  wrapper_elements
  frame_element
  validation_elements

  COURSE_CODE = 0
  MULTI_COURSE_CODE = 1
  COURSE_NAME = 1
  SECTION = 1
  POPUP_CREDITS = 1
  MULTI_SECTION = 2
  POPUP_REG_OPTIONS = 2
  CREDITS = 2
  COURSE_CREDITS = 3
  POPUP_REG_EFFECTIVE_DATE = 3
  REG_OPTIONS = 3
  DESCRIPTION = 4
  ACTIVITY = 4
  DATE_TIME = 5
  INSTRUCTOR = 6
  ROOM = 7
  EFFECTIVE_DATE = 9
  ACTIONS = 10

  element(:admin_registration_page) { |b| b.frm.div(id: "KS-AdminRegistration")}

  #################################################################
  ### Student and Term
  #################################################################
  element(:student_info_section) { |b| b.frm.div(id: "KS-AdminRegistration-StudentInfo")}
  element(:student_info_input) { |b| b.loading.wait_while_present; b.student_info_section.text_field(id: /studentIdField/)}
  element(:student_info_go_btn) { |b| b.student_info_section.button(id: "go_button")}
  action(:student_info_go){ |b| b.loading.wait_while_present; b.student_info_go_btn.when_present.click}

  element(:student_info_msg) { |b| b.student_info_section.div(id: /studentInfoMsg/)}
  value(:student_info_msg_value){ |b| b.student_info_msg.when_present.text}
  element(:student_error_message) { |b| b.student_info_section.li(class: 'uif-errorMessageItem')}
  value(:get_student_error_message){ |b| b.student_error_message.when_present.text}

  element(:registration_change_term_section) { |b| b.frm.div(id: "KS-AdminRegistration-ChangeTermSection")}
  element(:change_term_input) { |b| b.loading.wait_while_present; b.registration_change_term_section.text_field(id: /termCodeField/)}
  element(:change_term_go_btn) { |b| b.registration_change_term_section.button(id: /changeTermGoButton/)}
  action(:change_term_go){ |b| b.change_term_go_btn.when_present.click}

  element(:change_term_info_msg) { |b| b.registration_change_term_section.div(id: "changeTermInfoMsg")}
  value(:get_change_term_info_message){ |b| b.change_term_info_msg.when_present.text}
  element(:change_term_error_message) { |b| b.registration_change_term_section.li(class: 'uif-errorMessageItem')}
  value(:get_term_error_message){ |b| b.change_term_error_message.when_present.text}

  element(:change_term_warning_message) { |b| b.registration_change_term_section.p(id: "changeTermEligibilityWarning")}
  value(:get_change_term_warning_message){ |b| b.change_term_warning_message.when_present.text}

  #################################################################
  ### Course Code and Section
  #################################################################
  element(:admin_registration_reg_for_section) { |b| b.frm.div(id: "KS-AdminRegistration-RegFor")}
  element(:admin_registration_reg_for_table) { |b| b.admin_registration_reg_for_section.table}
  element(:course_code_input) { |b| b.get_blank_row("code")}
  element(:section_code_input) { |b| b.get_blank_row("section")}
  element(:course_credits_message) { |index, b| b.admin_registration_reg_for_table.rows[index].cells[COURSE_CREDITS]}
  element(:course_description_message) { |index, b| b.admin_registration_reg_for_table.rows[index].cells[DESCRIPTION]}

  value(:get_course_credits_message){ |index, b| b.loading.wait_while_present; b.course_credits_message(index).div(class: "uif-messageField").text}
  value(:get_course_description_message){ |index, b| b.loading.wait_while_present; b.course_description_message(index).text}

  element(:reg_for_error_message) { |b| b.frm.div(id: "KS-AdminRegistration-RegFor_messages")}

  element(:course_addline_btn) { |b| b.admin_registration_reg_for_section.button(id: "addLineButton")}
  action(:course_addline){ |b| b.course_addline_btn.when_present.click}
  element(:course_register_btn) { |b| b.admin_registration_reg_for_section.button(id: "KS-AdminRegistration-RegisterButton")}
  action(:course_register){ |b| b.course_register_btn.when_present.click}
  element(:course_delete_link) { |index, b| b.admin_registration_reg_for_section.a(id: /removeCourseAction_line#{index}/)}
  action(:course_delete) { |index, b| b.course_delete_link(index).when_present.click}
  element(:cancelled_section_error_message) { |b| b.reg_for_error_message.li(class: 'uif-errorMessageItem')}
  value(:get_cancelled_section_error_message){ |b| b.cancelled_section_error_message.when_present.text}

  element(:confirm_registration_popup_section) { |b| b.frm.section(id: "registerConfirmDialog")}
  element(:confirm_registration_popup_table) { |b| b.frm.div(id: "KS-AdminRegistration-DialogCollection").table}
  element(:confirm_registration_btn) { |b| b.confirm_registration_popup_section.button(id: "confirmRegistrationButton")}
  action(:confirm_registration){ |b| b.confirm_registration_btn.when_present.click}
  element(:cancel_registration_link) { |b| b.confirm_registration_popup_section.a(id: "cancelRegistrationLink")}
  action(:cancel_registration){ |b| b.cancel_registration_link.when_present.click}

  element(:admin_registration_issues_section) { |b| b.frm.div(id: "KS-AdminRegistration-Results").table}
  element(:registration_results_success) { |b| b.admin_registration_issues_section.row(class: "alert-success")}
  element(:registration_results_warning) { |b| b.admin_registration_issues_section.row(class: "alert-warning")}

  element(:dismiss_registration_results_btn) { |b| b.registration_results_success.i(class: "ks-fontello-icon-cancel")}
  action(:dismiss_registration_result){ |b| b.dismiss_registration_results_btn.when_present.click}

  element(:confirm_registration_issue_btn) { |b| b.registration_results_warning.button(id: /allowActionButton/)}
  action(:confirm_registration_issue){ |b| b.confirm_registration_issue_btn.when_present.click}
  element(:deny_registration_issue_btn) { |b| b.registration_results_warning.button(id: /denyActionButton/)}
  action(:deny_registration_issue){ |b| b.deny_registration_issue_btn.when_present.click}

  element(:get_registration_results_success) { |b| b.registration_results_success.div(class: "uif-horizontalBoxGroup clearfix").when_present.text}
  element(:get_registration_results_warning) { |b| b.registration_results_warning.div(class: "uif-horizontalBoxGroup clearfix").when_present.text}

  def get_blank_row(cell_type)
    loading.wait_while_present
    admin_registration_reg_for_table.rows[1..-1].each do |row|
      row.text_fields.each do |input|
        if input.text == "" and input.attribute_value('name') =~ /#{Regexp.escape(cell_type)}/
          return input if input.attribute_value('value') == ""
        end
      end
    end
    return nil
  end

  def get_confirm_registration_row(text)
    confirm_registration_popup_table.rows[1..-1].each do |row|
      return row if row.text =~ /#{Regexp.escape(text)}/
    end
  end

  def get_last_course_code_value
    admin_registration_reg_for_table.rows[-1].cells[MULTI_COURSE_CODE].text_field().value
  end

  def get_last_section_value
    admin_registration_reg_for_table.rows[-1].cells[MULTI_SECTION].text_field().value
  end

  def get_course_code_value text
    rows = admin_registration_reg_for_table.rows(text: /#{text}/)
    rows.each do |row|
      return row.cells[COURSE_CODE].text_field().value
    end
    return nil
  end

  def get_section_value text
    rows = admin_registration_reg_for_table.rows(text: /#{text}/)
    rows.each do |row|
      return row.cells[SECTION].text_field().value
    end
    return nil
  end

  #################################################################
  ### Register Courses Table
  #################################################################
  element(:registered_courses_section) { |b| b.frm.section( id: "KS-AdminRegistration-Registered")}
  element(:registered_courses_table) { |b| b.registered_courses_section.table}
  value(:registered_courses_header) { |b| b.registered_courses_section.text}

  value(:get_registered_course_code_sort){ |b| b.loading.wait_while_present; b.registered_courses_table.th(class: "sorting_asc").text}
  value(:get_registered_course_credits){ |row, b| b.loading.wait_while_present; row.cells[CREDITS].text}
  value(:get_registered_course_reg_options){ |row, b| b.loading.wait_while_present; row.cells[REG_OPTIONS].text}
  value(:get_registered_course_effective_date){ |row, b| b.loading.wait_while_present; row.cells[EFFECTIVE_DATE].text}

  element(:registered_course_edit_link) { |b| b.registered_courses_table.a(id: "registeredEditLink")}
  action(:registered_course_edit){ |b| b.registered_course_edit_link.when_present.click}
  element(:transaction_date_float_table) { |b| b.div(id: /jquerybubblepopup/, data_for: /effectiveDateInfo_line\d+/).table}

  def registered_courses_rows
    array = []

    loading.wait_while_present
    if registered_courses_table.exists?
      registered_courses_table.rows().each do |row|
        array << row
      end
    end

    return array
  end

  def get_registered_course(course)
    loading.wait_while_present
    if registered_courses_table.exists?
      registered_courses_table.rows[1..-1].each do |row|
        return row if row.text=~ /#{Regexp.escape(course)}/
      end
    end
    return nil
  end

  def edit_registered_course(course, section)
    loading.wait_while_present
    wait_until { registered_courses_table.row(text: /#{course} \(#{section}\)/).present? }
    actions = registered_courses_table.row(text: /#{course} \(#{section}\)/).cells[ACTIONS]
    actions.a(id: /registeredEditLink_line\d+/).click
  end

  def delete_registered_course(course, section)
    loading.wait_while_present
    wait_until { registered_courses_table.row(text: /#{course} \(#{section}\)/).present? }
    actions = registered_courses_table.row(text: /#{course} \(#{section}\)/).cells[ACTIONS]
    actions.a(id: /registeredDropLink_line\d+/).click
  end

  def get_transaction_date_float date
    registered_courses_rows[1..-1].each do |row|
      loading.wait_while_present
      row.cells[EFFECTIVE_DATE].click
      table = transaction_date_float_table
      table.rows(text: /#{date}/).each do |row|
        return row.text
      end
    end
    return nil
  end

  #################################################################
  ### Wait listed Courses Table
  #################################################################
  element(:waitlisted_courses_section) { |b| b.frm.section( id: "KS-AdminRegistration-Waitlist")}
  element(:waitlisted_courses_table) { |b| b.waitlisted_courses_section.table}
  value(:waitlisted_courses_header) { |b| b.waitlisted_courses_section.text}
  value(:get_waitlisted_course_credits){ |row, b| b.loading.wait_while_present; row.cells[CREDITS].text}
  value(:get_waitlisted_course_code_sort){ |b| b.waitlisted_courses_table.th(class: "sorting_asc").text}

  def waitlisted_courses_rows
    array = []

    loading.wait_while_present
    if waitlisted_courses_table.exists?
      waitlisted_courses_table.rows().each do |row|
        array << row
      end
    end

    return array
  end

  def get_waitlisted_course (course)
    if waitlisted_courses_table.exists?
      waitlisted_courses_table.rows[1..-1].each do |row|
        return row.text if row.text=~ /#{Regexp.escape(course)}/
      end
    end
    return nil
  end

  #################################################################
  ### Confirm Registration Dialog
  #################################################################
  element(:confirm_course_credits) { |code, b| b.get_confirm_reg_dialog_row(code).cells[POPUP_CREDITS]}
  element(:confirm_course_reg_options) { |code, b| b.get_confirm_reg_dialog_row(code).cells[POPUP_REG_OPTIONS]}
  element(:confirm_course_effective_date) { |code, b| b.get_confirm_reg_dialog_row(code).cells[POPUP_REG_EFFECTIVE_DATE]}

  element(:set_confirm_course_credits){ |code, b| b.confirm_course_credits(code).select()}
  element(:set_confirm_course_reg_options){ |code, b| b.confirm_course_reg_options(code).select()}
  element(:set_confirm_course_effective_date){ |code, b| b.confirm_course_effective_date(code).text_field()}

  value(:get_confirm_course_credits){ |code, b| b.confirm_course_credits(code).text}
  value(:get_confirm_course_reg_options){ |code, b| b.confirm_course_reg_options(code).text}
  value(:get_confirm_course_effective_date){ |code, b| b.confirm_course_effective_date(code).text_field().value}

  def get_confirm_reg_dialog_row(text)
    loading.wait_while_present
    if confirm_registration_popup_table.exists?
      confirm_registration_popup_table.rows[1..-1].each do |row|
        return row if row.text =~ /#{text}/
      end
    end
  end

  #################################################################
  ### Edit Course Dialog
  #################################################################
  element(:course_edit_popup_section) { |b| b.frm.section(id: "courseEditDialog")}
  element(:course_edit_popup_table) { |b| b.frm.div(id: "KS-AdminRegistration-Courses-Edit").table}

  value(:edit_course_dialog_error_msg) { |b| b.course_edit_popup_section.div(class: /uif-messageField uif-boxLayoutVerticalItem/).text}

  element(:edit_course_credits) { |b| b.course_edit_popup_table.rows[1].cells[POPUP_CREDITS]}
  element(:edit_course_reg_options) { |b| b.course_edit_popup_table.rows[1].cells[POPUP_REG_OPTIONS]}
  element(:edit_course_effective_date) { |b| b.course_edit_popup_table.rows[1].cells[POPUP_REG_EFFECTIVE_DATE]}

  element(:set_edit_course_credits) { |b| b.edit_course_credits.select()}
  element(:set_edit_course_reg_options) { |b| b.edit_course_reg_options.select()}
  element(:set_edit_course_effective_date) { |b| b.edit_course_effective_date.text_field()}

  value(:get_edit_course_credits){ |b| b.edit_course_credits.text}
  value(:get_edit_course_reg_options){ |b| b.edit_course_reg_options.text}
  value(:get_edit_course_effective_date) { |b| b.edit_course_effective_date.text}

  element(:course_edit_save_btn) { |b| b.course_edit_popup_section.button(id: "saveEditCourseButton")}
  action(:save_edited_course){ |b| b.course_edit_save_btn.when_present.click}
  element(:cancel_edit_link) { |b| b.course_edit_popup_section.a(id: "cancelEditCourseLink")}
  action(:cancel_edited_course){ |b| b.cancel_edit_link.when_present.click}

  #################################################################
  ### Drop Course Dialog
  #################################################################
  element(:drop_course_dialog) { |b| b.section(id: "dropCourseDialog")}
  element(:drop_registered_effective_date) { |b| b.drop_course_dialog.text_field(name: "pendingDropCourse.registeredDropDate")}

  element(:confirm_course_drop_btn) { |b| b.drop_course_dialog.button(id: "confirmRegDropBtn")}
  action(:confirm_course_drop) { |b| b.confirm_course_drop_btn.when_present.click}
  element(:cancel_course_drop_btn) { |b| b.drop_course_dialog.a(text: /Cancel/)}
  action(:cancel_course_drop) { |b| b.cancel_course_drop_btn.when_present.click}

end