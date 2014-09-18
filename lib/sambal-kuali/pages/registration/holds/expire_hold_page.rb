class ExpireAppliedHold < BasePage

  wrapper_elements
  frame_element
  validation_elements

  expected_element :section_info

  ######################################################################################################################
  ###                                            Expire Hold Section                                                 ###
  ######################################################################################################################
  element(:expire_hold_page) { |b| b.main(id: "KS-ExpireHold-Page")}
  element(:expire_hold_section) { |b| b.expire_hold_page.section(id: "KS-ExpireHold-HoldSection")}
  element(:section_info) { |b| b.expire_hold_page.div(id: "KS-ExpireHold-Section-Info")}
  element(:exp_date) { |b| b.expire_hold_section.text_field(name: "document.newMaintainableObject.dataObject.appliedHold.expirationDate")}

  element(:expire_btn) { |b| b.expire_hold_page.button(id: "expireHoldButton")}
  action(:expire) { |b| b.expire_btn.when_present.click}

  def confirm_expire_hold (date)
    exp_date.set(date)
    expire
  end

end
