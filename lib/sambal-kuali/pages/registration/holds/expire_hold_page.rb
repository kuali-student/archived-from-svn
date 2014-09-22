class ExpireAppliedHold < BasePage

  wrapper_elements
  frame_element
  validation_elements

  expected_element :applied_hold_info_section

  ######################################################################################################################
  ###                                            Apply Hold Page                                        ###
  ######################################################################################################################
  element(:expire_hold_page) { |b| b.main(id: "KS-ExpireHold-Page")}

  element(:expire_hold_btn) { |b| b.expire_hold_page.button(id: "expireHoldButton")}
  action(:expire_hold) { |b| b.expire_hold_btn.when_present.click}
  element(:cancel_link) { |b| b.expire_hold_page.a(text: "Cancel")}
  action(:cancel) { |b| b.cancel_link.when_present.click}

  ######################################################################################################################
  ###                                            Expire Hold Section                                                 ###
  ######################################################################################################################
  element(:expire_hold_section) { |b| b.frm.section(id: "KS-ExpireHold-HoldSection")}
  element(:applied_hold_info_section) { |b| b.expire_hold_page.div(id: "KS-ExpireHold-Section-Info")}
  element(:expire_error_msg_section) { |b| b.expire_hold_section.div(id: "KS-ExpireHold-HoldSection_messages")}

  element(:expire_error_msg) { |b| b.expire_error_msg_section.ul(class: "uif-validationMessagesList")}
  value(:get_expire_error_msg) { |b| b.expire_error_msg.when_present.text}

  element(:expiration_date) { |b| b.expire_hold_section.text_field(name: "document.newMaintainableObject.dataObject.appliedHold.expirationDate")}
  element(:expiration_term) { |b| b.expire_hold_section.text_field(name: "document.newMaintainableObject.dataObject.expirationTerm")}

end
