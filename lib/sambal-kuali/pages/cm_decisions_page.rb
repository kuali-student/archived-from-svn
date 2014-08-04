class CmDecisions < BasePage

  wrapper_elements
  cm_elements
  expected_element :close

  def frm
    self.iframe(class: "fancybox-iframe")
  end

  element(:close) { |b| b.frm.button(id: 'CM-Proposal-Course-DecisionsLightBoxContents-cancel') }
  action(:close_dialog) { |b| b.close.click; b.loading_wait}
  action(:close_decision_dialog) { |b| b.frm.a(title: "Close").click }

end