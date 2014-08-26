class AdminComments < BasePage

  wrapper_elements

  expected_element :comment_list_header

  def frm
    self.iframe(class: "fancybox-iframe")
  end

  element(:new_comment_field) { |b| b.frm.iframe(id: 'KS-NewCommentField_control_ifr').body }
  element(:add_comment_element) { |b| b.frm.button(text: 'Add Comment') } #TODO: static id
  element(:add_comment) { |b| b.add_comment_element.click; b.loading.wait_while_present; sleep 1 }

  element(:comment_list_header) { |b| b.frm.header(id: 'Comment_list_Header') }
  value(:comment_list_header_text) { |b| b.comment_list_header.text }
  value(:header_text_comments_count){ |b| b.comment_list_header_text[/\d+(?=\))/].to_i }

  #element(:comment_list_div) { |b| b.frm.div(id: 'u1bcxmtx') }
  element(:comments_list) { |b| b.frm.divs(id: /^KS-collection-rowId_line\d+$/) }

  def comment_by_text (comment_text)
    comments_list.each do |div|
      page_comment_text = div.div(id: /^KS-CommentField_UI_ID_line\d+$/).text
      return div if page_comment_text == comment_text
    end
    nil
  end

  def comment_index_by_text (comment_text)
    comments_list.each do |div|
      page_comment_text = div.div(id: /^KS-CommentField_UI_ID_line\d+$/).text
      return div.id[/\d+$/] if page_comment_text =~ /#{comment_text}/
    end
    -1
  end

  action(:comment_element){ |comment_index,b| b.frm.div(id: "KS-CommentField_UI_ID_line#{comment_index}") }
  value(:comment_text){ |comment_index,b| b.frm.comment_element(comment_index).text }
  element(:comment_hyperlink){ |comment_index,b| b.frm.comment_element(comment_index).link }
  value(:comment_created_by){ |comment_index,b| b.frm.p(id: "creator-name-id_line#{comment_index}").text }
  value(:comment_created_date){ |comment_index,b| b.frm.p(id: "creator-date-id_line#{comment_index}").text }
  action(:comment_text_editor){ |comment_index,b| b.frm.iframe(id: "KS-CommentField_ID_line#{comment_index}_control_ifr").body }

  element(:url_entry_dialog){ |b| b.frm.div(id: /mceu/,class: /mce-floatpanel/) }
  element (:url_entry){ |b| b.url_entry_dialog.text_field(index: 0) }
  element (:url_text){ |b| b.url_entry_dialog.text_field(index: 1) }
  element (:url_title){ |b| b.url_entry_dialog.text_field(index: 2) }
  #element (:url_target){ |b| b.frm.button(id: 'mceu_93-open') }
  element(:url_entry_save){ |b| b.url_entry_dialog.div(class: /mce-primary/).button }
  element(:url_entry_cancel){ |b| b.url_entry_dialog.button(index: 2) }

  action(:comment_save_edit){ |comment_index,b| b.frm.button(id: "KS-CommentSaveAction_ID_line#{comment_index}") }
  action(:comment_cancel_edit){ |comment_index,b| b.frm.button(id: "KS-CommentCancelAction_ID_line#{comment_index}") }

  value(:comment_edited_by){ |comment_index,b| b.frm.p(id: "lastEditor-name-id_line#{comment_index}").text }
  value(:comment_edited_date){ |comment_index,b| b.frm.p(id: "lastEditor-date-id_line#{comment_index}").text }

  action(:delete_comment_element){ |comment_index,b| b.frm.link(id: "KS-CommentDeleteAction_line#{comment_index}") }

  def delete_comment(comment_text, confirm_delete=true)
    comment_index = comment_index_by_text(comment_text)
    delete_comment_element(comment_index).click
    sleep 5
    #comment = comment_by_text(comment_text) #refresh occurs
    if confirm_delete
      confirm_delete_element(comment_index).click
    else
      cancel_delete_element(comment_index).click
    end
    sleep 2 #TODO: add proper synch here
    loading.wait_while_present #loading is part of iframe here
  end

  action(:confirm_delete_element){ |comment_index,b| b.frm.button(id: "KS-CommentDeleteAction_ID_line#{comment_index}") }
  action(:cancel_delete_element){ |comment_index,b| b.frm.button(id: "KS-CommentCancelDeleteAction_ID_line#{comment_index}") }
  action(:edit_comment_element){ |comment_index,b| b.frm.link(id: "KS-CommentEditAction_line#{comment_index}") }
  action(:close) { |b| b.frm.button(id: 'commentsLightBoxContents-cancel').click; sleep 3 } #sleep required after closing dialog, issue across this project
end