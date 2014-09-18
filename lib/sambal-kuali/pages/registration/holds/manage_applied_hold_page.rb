class ManageAppliedHold < BasePage

  wrapper_elements
  frame_element
  validation_elements

  expected_element :student_id_input

  ######################################################################################################################
  ###                                            Constants                                       ###
  ######################################################################################################################

  CHECK_HOLD    = 0
  APPLIED_HOLD  = 1
  HOLD_CODE     = 2
  CATEGORY      = 3
  CONSEQUENCE   = 4
  STATE         = 5
  START_DATE    = 6
  END_DATE      = 7
  START_TERM    = 8
  END_TERM      = 9
  ACTIONS       = 10

  ######################################################################################################################
  ###                                            Manage Applied Hold Page                                ###
  ######################################################################################################################
  element(:manage_applied_hold_view) { |b| b.frm.div(id: "KS-AppliedHoldManagementView")}
  element(:banner_section) { |b| b.manage_applied_hold_view.div(class: "container-fluid uif-viewHeader ks-unified-header uif-sticky")}
  element(:header_section) { |b| b.manage_applied_hold_view.h1(class: "uif-headerText")}

  value(:get_student_info) { |b| b.header_section.when_present.text}

  element(:student_term_error_messages) { |b| b.manage_applied_hold_view.div(class: /alert alert-danger/)}

  def get_student_term_error_msg( section)
    student_term_error_messages.lis().each do |msg|
      if msg.attribute_value('data-messageitemfor') =~ /studentIdField/ and section == "student"
        return msg.text
      end
    end
    return nil
  end

  ######################################################################################################################
  ###                                            Criteria Section                                ###
  ######################################################################################################################
  element(:criteria_section) { |b| b.frm.div(id: "KS-AppliedHold-CriteriaSection")}

  element(:student_id_input) { |b| b.criteria_section.text_field(id: "studentIdField_control")}

  element(:show_btn) { |b| b.criteria_section.button(id: "show_button")}
  action(:show){ |b| b.show_btn.when_present.click}

  ######################################################################################################################
  ###                                            Toolbar Section                                ###
  ######################################################################################################################
  element(:toolbar_section) { |b| b.frm.div(id: "KS-Hold-ToolBarSection")}

  element(:apply_new_hold_btn) { |b| b.toolbar_section.button(id: "KS-Hold-ToolBar-Add-Applied-Hold")}
  action(:apply_new_hold){ |b| b.apply_new_hold_btn.when_present.click}
  element(:expire_new_hold_btn) { |b| b.toolbar_section.button(id: "KS-Hold-ToolBar-Expire-Applied-Hold")}
  action(:expire_new_hold){ |b| b.expire_new_hold_btn.when_present.click}

  ######################################################################################################################
  ###                                            Results Section                                ###
  ######################################################################################################################
  element(:results_section) { |b| b.frm.div( id: "KS-AppliedHold-SearchResults")}
  element(:results_table) { |b| b.results_section.table}

  def expire_hold (hold_code)
    if results_table.exists?
      results_table.rows[1..-1].each do |row|
        if((row.cells[HOLD_CODE].text=~ /#{Regexp.escape(hold_code)}/) and (row.cells[STATE].text=~ /Active/))
          row.cells[CHECK_HOLD].click
          loading.wait_while_present
          expire_new_hold
        end
      end
    end
  end

  def get_hold_by_code( code)
    loading.wait_while_present
    if results_table.exists?
      results_table.rows( ).each do |row|
        return row if row.text =~ /#{code}/
      end
    end

    return nil
  end

  def get_holds_states (hold_code, hold_state)
    if results_table.exists?
      results_table.rows[1..-1].each do |row|
        if((row.cells[HOLD_CODE].text=~ /#{Regexp.escape(hold_code)}/) and (row.cells[STATE].text=~ /#{Regexp.escape(hold_state)}/))
          return row
        end
      end
    end
    return nil
  end

end