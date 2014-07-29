class CmCreateCourseStart < BasePage

  wrapper_elements
  cm_elements

  element(:blank_proposal) { |b| b.div(id:'CM-Proposal-Course-StartOption').input(id:'CM-Proposal-Course-StartOption_control_0') }
  #element(:curriculum_review_process) { |b| b.div(id:'createCourseInitial_is_reviewProcess').input(id:'createCourseInitial_is_reviewProcess_control') }
  action(:continue) { |b| b.button(id: 'CM-Proposal-Course-Start-ContinueCreate').click }
  action(:cancel) { |b| b.button(id: 'cancel').click }
  element(:curriculum_review_process) { |b| b.checkbox(id: "CM-Proposal-Course-Start-ReviewProcess_control")}


end #class