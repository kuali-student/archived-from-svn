class ManageAppliedHold < BasePage

  wrapper_elements
  frame_element
  validation_elements

  expected_element :manage_applied_hold_studentid_input


  ######################################################################################################################
  ###                                            Manage Hold Constants                                               ###
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

  ######################################################################################################################
  ###                                            Manage Applied Hold Section                                         ###
  ######################################################################################################################
  element(:manage_applied_hold_page) { |b| b.main(id: "KS-AppliedHold-SearchInput-Page")}
  element(:manage_applied_hold_section) { |b| b.manage_applied_hold_page.div(id: "KS-AppliedHold-CriteriaSection")}

  ######################################################################################################################
  ###                                       Manage Hold Input Fields                                                 ###
  ######################################################################################################################
  element(:manage_applied_hold_studentid_input) { |b| b.loading.wait_while_present; b.manage_applied_hold_section.text_field(id:"studentIdField_control")}

  ######################################################################################################################
  ###                                            Manage Hold Buttons                                                 ###
  ######################################################################################################################
  element(:manage_applied_hold_show_btn) { |b| b.manage_applied_hold_section.button(id: "show_button")}
  action(:manage_applied_hold_show){ |b| b.manage_applied_hold_show_btn.when_present.click}


end