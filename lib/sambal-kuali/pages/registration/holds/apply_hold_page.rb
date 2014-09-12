class ApplyHold < BasePage

  wrapper_elements
  frame_element
  validation_elements
  ######################################################################################################################
  ###                                           Apply Hold Constants                                       ###
  ######################################################################################################################


  ######################################################################################################################
  ###                                            Apply Hold Section                                         ###
  ######################################################################################################################
  element(:apply_hold_view) { |b| b.frm.div(id: "KS-AppliedHoldMaintenanceView")}


  element(:apply_hold_page) { |b| b.main(id: "KS-Hold-Apply-Page")}
  element(:apply_hold_section) { |b| b.apply_hold_page.div(id: "KS-ApplyHold-HoldSection")}


  ######################################################################################################################
  ###                                      Apply Hold Input Fields                                         ###
  ######################################################################################################################
  element(:hold_code) { |b| b.apply_hold_section.text_field(name: "document.newMaintainableObject.dataObject.holdCode")}
  element(:first_applied_date) { |b| b.apply_hold_section.text_field(name: "document.newMaintainableObject.dataObject.appliedHold.effectiveDate")}
  element(:first_term) { |b| b.apply_hold_section.text_field(name: "document.newMaintainableObject.dataObject.firstTerm")}
  ######################################################################################################################
  ###                                            Apply Hold Buttons                                         ###
  ######################################################################################################################
  element(:apply_hold_show_btn) { |b| b.apply_hold_section.button(id: "show_button")}
  action(:apply_hold_show){ |b| b.apply_hold_show_btn.when_present.click}
  element(:apply_hold_btn) { |b| b.apply_hold_section.button(id: "applyHoldButton")}
  action(:apply_hold){ |b| b.apply_hold__btn.when_present.click}

  ################################################################
  ### Apply Holds error Methods
  #################################################################

end