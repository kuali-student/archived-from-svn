class CmAuthorsCollaborators < BasePage

  wrapper_elements
  cm_elements

  element(:author_name) { |author_level,b| b.textarea(id: "KS-Author-displayName_line#{author_level-1}_control") }
  element(:author_permission) { |author_level,b| b.select_list(id: "KS-PermissionDropDown_line#{author_level-1}_control") }
  element(:action_required) { |author_level,b| b.select_list(id: "KS-ActionRequestDropDown_line#{author_level-1}_control" ) }
  element(:author_notation) { |author_level,b| b.checkbox(name: "document.newMaintainableObject.dataObject.collaboratorWrappers[#{author_level-1}].author") }
  action(:delete_author) { |author_level,b| b.div(id: "KS-CourseView-AuthorsAndCollaboratorsSubSection").a(id: /line#{author_level-1}/, title: "Delete").i(class: "ks-fontello-icon-cancel").click; b.loading_wait }
  action(:add_person) { |b| b.button(id: "KS-CourseView-AuthorsAndCollaborators-Section_add").click; b.loading_wait }
  action(:added_author_information) { |text_present, b| b.span(text: text_present) }
  # view, comment, edit, fyi, false, true, <complete_username>
end    #class