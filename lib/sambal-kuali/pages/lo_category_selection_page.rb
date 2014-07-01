class CmLoCategoryObject < BasePage

  wrapper_elements
  cm_elements

  def frm
    self.iframe(class: "fancybox-iframe")
  end

  element(:type_select_all_link) {|b| b.frm.a(id: 'Lo-type-selection-select-all-link') }
  element(:type_clear_all_link) {|index,b|b.frm.a(id: "Lo-type-selection-deselect-all-link")}
  element(:category_filter_input) {|b|b.frm.input(id: "LoCategory-Category-Filter-Input_control") }

  element(:category_lookup_result_table) { |b| b.frm.table(id: "uLookupResults_layout") }

  element(:add_categories_button) { |b| b.frm.button(id: 'KSCM-AddCategoryButton')}
  element(:comment_header_id_text) {|index, b|b.frm.header(id: "KSCM-CommentField-comment-header-id_line#{index}").text}

  action(:add_categories) { |b| b.frm.button(id: 'KSCM-AddCategoryButton').click; b.loading_wait }
  action(:cancel_add_categories) { |b| b.frm.button(id: 'cancel').click; b.loading_wait}
  action(:close_category_browser_dialog) { |b| b.frm.a(title: "Close").click }

end