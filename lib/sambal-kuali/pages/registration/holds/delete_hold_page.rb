class DeleteAppliedHold < BasePage

  wrapper_elements
  frame_element
  validation_elements

  expected_element :section_info

  ######################################################################################################################
  ###                                            Delete Hold Section                                                 ###
  ######################################################################################################################
  element(:delete_hold_page) { |b| b.main(id: "KS-DeleteHold-Page")}
  element(:section_info) { |b| b.delete_hold_page.div(id: "KS-DeleteHold-Section-Info")}

  element(:delete_btn) { |b| b.delete_hold_page.button(id: "deleteHoldButton")}
  action(:delete) { |b| b.delete_btn.when_present.click}

  def confirm_delete_hold
    loading.wait_while_present
    delete
  end

end
