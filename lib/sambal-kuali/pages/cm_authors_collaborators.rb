class CmAuthorsCollaborators < BasePage

  wrapper_elements
  cm_elements

  element(:author_name) { |author_level,b| b.text_field(id: "CM-Proposal-Course-AuthorsAndCollaborators-Name_line#{author_level-1}_control") }
  element(:author_permission) { |author_level,b| b.select_list(id: "CM-Proposal-Course-AuthorsAndCollaborator-Permission_line#{author_level-1}_control") }
  element(:action_required) { |author_level,b| b.select_list(id: "CM-Proposal-Course-AuthorsAndCollaborator-ActionRequest_line#{author_level-1}_control" ) }
  element(:author_notation) { |author_level,b| b.checkbox(name: "document.newMaintainableObject.dataObject.collaboratorWrappers[#{author_level-1}].author") }
  action(:delete_author) { |author_level,b| b.div(id: "CM-Proposal-Course-AuthorsAndCollaborators-Section").a(id: /line#{author_level-1}/, title: "Delete").i(class: "ks-fontello-icon-cancel").click; b.loading_wait }
  action(:add_person) { |b| b.button(id: "CM-Proposal-Course-AddAuthorsAndCollaborators").click; b.loading_extended_wait }
  action(:added_author_information) { |text_present, b| b.span(text: text_present) }
  # view, comment, edit, fyi, false, true, <complete_username>
end    #class