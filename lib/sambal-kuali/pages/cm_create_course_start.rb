class CmCreateCourseStart < BasePage

  wrapper_elements
  cm_elements

  element(:blank_proposal) { |b| b.div(id:'CM-Proposal-Course-StartOption').input(id:'CM-Proposal-Course-StartOption_control_0') }
  #element(:curriculum_review_process) { |b| b.div(id:'createCourseInitial_is_reviewProcess').input(id:'createCourseInitial_is_reviewProcess_control') }
  action(:continue) { |b| b.button(id: 'CM-Proposal-Course-Start-ContinueCreate').click }
  action(:cancel) { |b| b.button(id: 'cancel').click }
  element(:curriculum_review_process) { |b| b.checkbox(id: "CM-Proposal-Course-Start-ReviewProcess_control")}
  element(:cm_proposal_start_options) {|b|b.div(id: "CM-Proposal-Course-StartOptions")}
  element(:start_blank_proposal) { |b| b.radio(value: 'startBlankProposal') }
  element(:copy_approved_course) { |b| b.radio(value: 'copyApprovedCourse') }
  element(:copy_proposed_course) { |b| b.radio(value: 'copyProposedCourse') }

  element(:cm_proposal_copy_course_code_field) {|b|b.text_field(id: "CM-Proposal-Course-Create-Start-CopyFromCourse_control")}
  element(:cm_proposal_copy_proposal_title_field) {|b|b.text_field(id: "CM-Proposal-Course-Create-Start-CopyFromProposal_control")}

  element(:modify_course_this_version) { |b| b.radio(value: 'modifyThisVersion') }
  element(:modify_course_new_version) { |b| b.radio(value: 'modifyNewVersion') }

end #class