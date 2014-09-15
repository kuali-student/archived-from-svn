class ManageAppliedHold < BasePage

  wrapper_elements
  frame_element
  validation_elements

  expected_element :student_id_input

  ######################################################################################################################
  ###                                            Constants                                       ###
  ######################################################################################################################
  APPLIED_HOLD  = 0
  HOLD_CODE     = 1
  CATEGORY      = 2
  CONSEQUENCE   = 3
  STATE         = 4
  START_DATE    = 5
  END_DATE      = 6
  START_TERM    = 7
  END_TERM      = 8
  ACTIONS       = 9

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

  ######################################################################################################################
  ###                                            Results Section                                ###
  ######################################################################################################################
  element(:results_section) { |b| b.frm.div( id: "KS-AppliedHold-SearchResults")}
  element(:results_table) { |b| b.results_section.table}

  def get_hold_by_code( code)
    loading.wait_while_present
    if results_table.exists?
      results_table.rows( ).each do |row|
        return row if row.text =~ /#{code}/
      end
    end

    return nil
  end
end