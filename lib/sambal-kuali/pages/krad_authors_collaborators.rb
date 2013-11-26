class KradAuthorsCollaborators < BasePage

  wrapper_elements
  krad_elements

  element(:author_name) { |b| b.text_field(name: /displayName$/) }

  element(:author_permission) { |b| b.select_list(name: /permission$/) }
  element(:action_request) { |b| b.select_list(name: /action$/) }
  element(:author_notation) { |b| b.checkbox(name: /author$/) }

  action(:add_author) { |b| b.button(text: 'add').click; b.adding_line_wait }
  action(:delete_author) { |b| b.button(text: 'delete').click }

  action(:added_author_information) { |text_present, b| b.span(text: text_present) }
  # view, comment, edit, fyi, false, true, <complete_username>

  # ADVANCED SEARCH
  # text fields on base page
  #adv_name
  #adv_username

  #adv_search

end