class CmRetireCourseStart < BasePage

  wrapper_elements
  cm_elements

  action(:continue_retire) { |b| b.button(id: "CM-Proposal-Course-Retire-ContinueRetire").click; b.loading_wait }
  element(:admin_retire) { |b| b.radio(value: "startAdministrativeRetire") }
  #Cancel footer link
  action(:cancel) { |b| b.button(id: 'cancel').click }

end
