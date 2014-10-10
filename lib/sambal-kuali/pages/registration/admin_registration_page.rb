class AdminRegistration < BasePage

  expected_element :student_term_go_button

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
  element(:banner_section) { |b| b.admin_registration_page.div(id: "AdminRegistration-ContextBar")}
  element(:header_section) { |b| b.admin_registration_page.h1(class: "uif-headerText")}

  #################################################################
  ### Student Term Issues
  #################################################################
  element(:term_issues_section) { |b| b.frm.div(id: "KS-AdminRegistration-TermEligibility-Results")}
  element(:term_issues_table) { |b| b.term_issues_section.table}
  element(:term_warning_row) { |b| b.term_issues_table.row(class: "alert-warning")}

  element(:dismiss_term_btn) { |b| b.term_results_success.i(class: "ks-fontello-icon-cancel")}
  action(:dismiss_term){ |b| b.loading.wait_while_present; b.dismiss_term_btn.click}

  def get_term_warning
    begin
      wait_until(120) { term_issues_table.exists? }

      array = []
      term_issues_table.rows[1..-1].each do |row|
        if row.attribute_value('class') =~ /alert-warning/
          array << row.text
        end
      end

      return array.to_s
    rescue Watir::Wait::TimeoutError
      return "Term Eligibility warning took longer than 120s to appear"
    end
  end

  #################################################################
  ### Student and Term
  #################################################################
  element(:student_term_section) { |b| b.frm.div(id: "KS-AdminRegistration-StudentAndTermSection")}
  element(:term_eligibility_warning_section) { |b| b.frm.div(id: "KS-AdminRegistration-TermEligibilityWarning")}

  element(:student_id_input) { |b| b.loading.wait_while_present; b.student_term_section.text_field(id: "studentIdField_control")}
  element(:term_code_input) { |b| b.loading.wait_while_present; b.student_term_section.text_field(id: "termCodeField_control")}

  value(:get_student_info) { |b| b.loading.wait_while_present; b.header_section.text}
  value(:get_term_info) { |b| b.loading.wait_while_present; b.banner_section.div(class: /termName/).text}

  element(:student_term_go_button) { |b| b.student_term_section.button(id: "go_button")}
  action(:student_term_go){ |b| b.loading.wait_while_present; b.student_term_go_button.click}

  element(:student_term_error_messages) { |b| b.student_term_section.div(class: "alert alert-danger")}
  element(:term_warning_message) { |b| b.term_eligibility_warning_section.p(id: "termEligibilityWarning")}
  value(:get_term_warning_message){ |b| b.loading.wait_while_present; b.term_warning_message.text}

  def get_student_term_error_msg( section)
    student_term_error_messages.lis().each do |msg|
      if msg.attribute_value('data-messageitemfor') =~ /student/ and section == "student"
        return msg.text
      elsif msg.attribute_value('data-messageitemfor') =~ /term/ and section == "term"
        return msg.text
      end
    end
    return nil
  end

  #################################################################
  ### Course Code and Section
  #################################################################
  element(:reg_for_section) { |b| b.frm.div(id: "KS-AdminRegistration-RegFor")}
  element(:reg_for_table) { |b| b.reg_for_section.table}

  element(:course_code_input) { |b| b.get_blank_row("code")}
  element(:section_code_input) { |b| b.get_blank_row("section")}

  element(:course_credits_message) { |index, b| b.reg_for_table.rows[index].cells[COURSE_CREDITS]}
  value(:get_course_credits_message){ |index, b| b.loading.wait_while_present; b.course_credits_message(index).div(class: "uif-messageField").text}
  element(:course_description_message) { |index, b| b.reg_for_table.rows[index].cells[DESCRIPTION]}
  value(:get_course_description_message){ |index, b| b.loading.wait_while_present; b.course_description_message(index).text}
  element(:reg_for_error_message) { |b| b.reg_for_section.div(id: "KS-AdminRegistration-RegFor_messages")}
  value(:get_reg_for_error_message){ |b| b.loading.wait_while_present; b.reg_for_error_message.text}
  element(:section_error_message) { |b| b.reg_for_error_message.li(class: 'uif-errorMessageItem')}
  value(:get_section_error_message){ |b| b.loading.wait_while_present; b.section_error_message.text}

  element(:course_addline_btn) { |b| b.reg_for_section.button(id: "addLineButton")}
  action(:course_addline){ |b| b.loading.wait_while_present; b.course_addline_btn.click}
  element(:course_register_btn) { |b| b.reg_for_section.button(id: "KS-AdminRegistration-RegisterButton")}
  action(:course_register){ |b| b.loading.wait_while_present; b.course_register_btn.click}
  element(:course_delete_btn) { |index, b| b.reg_for_section.button(id: /KS-AdminRegistration-RegFor_del_line#{index}/)}
  action(:course_delete) { |index, b| b.loading.wait_while_present; b.course_delete_btn(index).click}
  element(:registering_in_progress) { |b| b.reg_for_section.div(id: "KS-AdminRegistration-Registering").img(class: "uif-image", alt: "Registration in progress.....")}

  def get_blank_row(cell_type)
    loading.wait_while_present
    reg_for_table.rows[1..-1].each do |row|
      row.text_fields.each do |input|
        if input.text == "" and input.attribute_value('name') =~ /#{Regexp.escape(cell_type)}/
          return input if input.attribute_value('value') == ""
        end
      end
    end
    return nil
  end

  def get_last_course_code_value
    reg_for_table.rows[-1].cells[MULTI_COURSE_CODE].text_field().value
  end

  def get_last_section_value
    reg_for_table.rows[-1].cells[MULTI_SECTION].text_field().value
  end

  def get_course_code_value text
    reg_for_table.rows(text: /#{text}/).each do |row|
      return row.cells[COURSE_CODE].text_field().value
    end
    return nil
  end

  def get_section_value text
    rows = reg_for_table.rows(text: /#{text}/)
    rows.each do |row|
      return row.cells[SECTION].text_field().value
    end
    return nil
  end

  #################################################################
  ### Registration Issues
  #################################################################
  element(:registration_issues_section) { |b| b.frm.div(id: "KS-AdminRegistration-Results")}
  element(:registration_issues_table) { |b| b.registration_issues_section.table}
  element(:results_warning_rows) { |b| b.registration_issues_table.row(class: "alert-warning")}

  element(:dismiss_results_btn) { |b| b.registration_results_success.i(class: "ks-fontello-icon-cancel")}
  action(:dismiss_results){ |b| b.loading.wait_while_present; b.dismiss_results_btn.click}

  def get_results_warning
    begin
      wait_until(120) { registration_issues_table.exists? }

      array = []
      registration_issues_table.rows[1..-1].each do |row|
        if row.attribute_value('class') =~ /alert-warning/
          array << row.text
        end
      end

      return array.to_s
    rescue Watir::Wait::TimeoutError
      return "Registration results took longer than 120s to appear"
    end
  end

  #################################################################
  ### Register Courses Table
  #################################################################
  element(:registered_courses_div) { |b| b.frm.div( id: "KS-AdminRegistration-RegisteredTab")}
  element(:registered_courses_table) { |b| b.registered_courses_div.div(id: "KS-AdminRegistration-Registered").table}
  element(:registered_header) { |b| b.registered_courses_div.div( id: "KS-AdminRegistration-RegisteredHeaderText")}
  value(:registered_courses_header) { |b| b.registered_header.h4(class: "uif-headerText").text}
  value(:get_registered_course_code_sort){ |b| b.loading.wait_while_present; b.registered_courses_table.th(class: "sorting_asc").text}

  value(:get_registered_course_credits){ |row, b| b.loading.wait_while_present; row.cells[CREDITS].text}
  value(:get_registered_course_reg_options){ |row, b| b.loading.wait_while_present; row.cells[REG_OPTIONS].text}
  value(:get_registered_course_effective_date){ |row, b| b.loading.wait_while_present; row.cells[EFFECTIVE_DATE].text}

  element(:registered_course_edit_link) { |b| b.registered_courses_table.a(id: "registeredEditLink")}
  action(:registered_course_edit){ |b| b.loading.wait_while_present; b.registered_course_edit_link.click}

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
    wait_until(60) { registered_courses_table.row(text: /#{course} \(#{section}\)/).present? }
    actions = registered_courses_table.row(text: /#{course} \(#{section}\)/).cells[ACTIONS]
    actions.a(id: /registeredEditLink_line\d+/).click
  end

  def delete_registered_course(course, section)
    loading.wait_while_present
    wait_until(60) { registered_courses_table.row(text: /#{course} \(#{section}\)/).present? }
    actions = registered_courses_table.row(text: /#{course} \(#{section}\)/).cells[ACTIONS]
    actions.a(id: /registeredDropLink_line\d+/).click
  end

  def calculate_registered_credits
    loading.wait_while_present
    credits = 0
    registered_courses_rows.each do |row|
      credits += get_registered_course_credits(row).to_i
    end
    return credits
  end

  #################################################################
  ### Wait listed Courses Table
  #################################################################
  element(:waitlisted_courses_section) { |b| b.registered_courses_div.div( id: "KS-AdminRegistration-Waitlist")}
  element(:waitlisted_courses_table) { |b| b.waitlisted_courses_section.table}
  element(:waitlisted_header) { |b| b.registered_courses_div.div( id: "KS-AdminRegistration-WaitlistedHeaderText")}
  value(:waitlisted_courses_header) { |b| b.waitlisted_header.h4(class: "uif-headerText").text}
  value(:get_waitlisted_course_code_sort){ |b| b.waitlisted_courses_table.th(class: "sorting_asc").text}

  value(:get_waitlisted_course_credits){ |row, b| b.loading.wait_while_present; row.cells[CREDITS].text}

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
    loading.wait_while_present
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
  element(:confirm_registration_dialog) { |b| b.frm.section(id: "registerConfirmDialog")}
  element(:confirm_registration_table) { |b| b.confirm_registration_dialog.div(id: "KS-AdminRegistration-DialogCollection").table}

  element(:confirm_course_credits) { |code, section, b| b.get_confirm_registration_row(code, section).cells[POPUP_CREDITS]}
  element(:set_confirm_course_credits){ |code, section, b| b.confirm_course_credits(code, section).select()}
  value(:get_confirm_course_credits){ |code, section, b| b.confirm_course_credits(code, section).text}
  element(:confirm_course_reg_options) { |code, section, b| b.get_confirm_registration_row(code, section).cells[POPUP_REG_OPTIONS]}
  element(:set_confirm_course_reg_options){ |code, section, b| b.confirm_course_reg_options(code, section).select()}
  value(:get_confirm_course_reg_options){ |code, section, b| b.confirm_course_reg_options(code, section).text}
  element(:confirm_course_effective_date) { |code, section, b| b.get_confirm_registration_row(code, section).cells[POPUP_REG_EFFECTIVE_DATE]}
  element(:set_confirm_course_effective_date){ |code, section, b| b.confirm_course_effective_date(code, section).text_field()}
  value(:get_confirm_course_effective_date){ |code, section, b| b.confirm_course_effective_date(code, section).text_field().value}

  element(:confirm_registration_btn) { |b| b.confirm_registration_dialog.button(id: "confirmRegistrationButton")}
  action(:confirm_registration){ |b| b.loading.wait_while_present; b.confirm_registration_btn.click}
  element(:cancel_registration_link) { |b| b.confirm_registration_dialog.a(id: "cancelRegistrationLink")}
  action(:cancel_registration){ |b| b.loading.wait_while_present; b.cancel_registration_link.click}

  def get_confirm_registration_row(code, section)
    loading.wait_while_present
    if confirm_registration_table.exists?
      confirm_registration_table.rows(text: /#{code}/).each do |row|
        return row if row.text =~ /#{section}/
      end
    end
    return nil
  end

  #################################################################
  ### Edit Course Dialog
  #################################################################
  element(:course_edit_dialog) { |b| b.frm.section(id: "courseEditDialog")}
  element(:course_edit_table) { |b| b.course_edit_dialog.div(id: "KS-AdminRegistration-Courses-Edit").table}

  value(:edit_course_dialog_error_msg) { |b| b.course_edit_dialog.div(class: /uif-messageField uif-boxLayoutVerticalItem/).text}

  element(:edit_course_credits) { |b| b.course_edit_table.rows[1].cells[POPUP_CREDITS]}
  element(:set_edit_course_credits) { |b| b.edit_course_credits.select()}
  value(:get_edit_course_credits){ |b| b.edit_course_credits.text}
  element(:edit_course_reg_options) { |b| b.course_edit_table.rows[1].cells[POPUP_REG_OPTIONS]}
  element(:set_edit_course_reg_options) { |b| b.edit_course_reg_options.select()}
  value(:get_edit_course_reg_options){ |b| b.edit_course_reg_options.text}
  element(:edit_course_effective_date) { |b| b.course_edit_table.rows[1].cells[POPUP_REG_EFFECTIVE_DATE]}
  element(:set_edit_course_effective_date) { |b| b.edit_course_effective_date.text_field()}
  value(:get_edit_course_effective_date) { |b| b.edit_course_effective_date.text}

  element(:course_edit_save_btn) { |b| b.course_edit_dialog.button(id: "saveEditCourseButton")}
  action(:save_edited_course){ |b| b.loading.wait_while_present; b.course_edit_save_btn.click}
  element(:cancel_edit_link) { |b| b.course_edit_dialog.a(id: "cancelEditCourseLink")}
  action(:cancel_edited_course){ |b| b.loading.wait_while_present; b.cancel_edit_link.click}

  #################################################################
  ### Drop Course Dialog
  #################################################################
  element(:drop_course_dialog) { |b| b.frm.section(id: "dropCourseDialog")}
  element(:drop_registered_effective_date) { |b| b.drop_course_dialog.text_field(name: "pendingDropCourse.registeredDropDate")}

  value(:drop_course_dialog_error_msg) { |b| b.drop_course_dialog.div(class: /uif-messageField uif-boxLayoutVerticalItem/).text}

  element(:confirm_course_drop_btn) { |b| b.drop_course_dialog.button(id: "confirmRegDropBtn")}
  action(:confirm_course_drop) { |b| b.loading.wait_while_present; b.confirm_course_drop_btn.click}
  element(:cancel_course_drop_btn) { |b| b.drop_course_dialog.a(text: /Cancel/)}
  action(:cancel_course_drop) { |b| b.loading.wait_while_present; b.cancel_course_drop_btn.click}

end