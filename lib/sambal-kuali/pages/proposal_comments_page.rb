class CmProposalCommentsPage < BasePage

  wrapper_elements
  cm_elements
  expected_element :close, timeout = 90

  def frm
    self.iframe(class: "fancybox-iframe")
  end

  element(:comment_text_input) {|b| b.frm.textarea(id: 'CM-Proposal-Course-Comment-NewComment_control') }
  element(:comment_edit_link) {|index,b|b.frm.a(id: "CM-Proposal-Course-Comment-Edit_line#{index}")}
  element(:comment_delete_link) {|index,b|b.frm.a(id: "CM-Proposal-Course-Comment-Delete_line#{index}")}
  element(:edit_comment_text_field) {|index,b|b.frm.text_field(id: "CM-Proposal-Course-Comment-Add-Field_line#{index}_control") }
  element(:undo_delete_comment_link) {|b|b.frm.a(id: "CM-Proposal-Course-Comment-Undo-Delete")}
  element(:add_comment_button) { |b| b.frm.button(text: 'Add Comment')}
  element(:comment_header_id_text) {|index, b|b.frm.header(id: "CM-Proposal-Course-Comment-Header_line#{index}").text}

  action(:add_comment) { |b| b.frm.button(text: 'Add Comment').click; b.loading_wait }
  element(:close) { |b| b.frm.button(id: 'CM-Proposal-Course-CommentsLightBoxContents-cancel') }
  action(:close_dialog) { |b| b.close.click; b.loading_wait}
  action(:close_comment_dialog) { |b| b.frm.a(title: "Close").click }

  action(:save_edited_comment) { |index,b| b.frm.button(id: "CM-Proposal-Course-Comment-Save_line#{index}").click; b.loading_wait }
  action(:cancel_edited_comment) { |index,b| b.frm.button(id: "cancel_line#{index}").click; b.loading_wait }
  action(:edit_comment) {|index,b|b.frm.a(id: "CM-Proposal-Course-Comment-Edit_line#{index}").click}
  action(:delete_comment) {|index,b|b.frm.a(id: "CM-Proposal-Course-Comment-Delete_line#{index}").click}
  action(:undo_delete) {|b|b.frm.a(id: "CM-Proposal-Course-Comment-Undo-Delete").click}

  value(:comment_list_header_text) {|b|b.frm.div(id: "CM-Proposal-Course-Comment-List-Header").text}
  value(:comment_content_text) {|index,b|b.frm.div(id: "CM-Proposal-Course-Comment-Add-Field_line#{index}").text}

end