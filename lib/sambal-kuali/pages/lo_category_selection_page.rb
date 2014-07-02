class CmLoCategoryFindPage < BasePage

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

  SELECT_COLUMN = 0
  CATEGORY_NAME_COLUMN = 1
  CATEGORY_TYPE_COLUMN = 2

  def row_by_category(category)
    category_lookup_result_table.row(text: /\b#{Regexp.escape(category)}\b/)
  end

  def select_category(category)
    if row_by_category(category).exists? then
      row_by_category(category).checkbox.set
      return row_by_category(category).cells[CATEGORY_NAME_COLUMN].text
    else
      return nil
    end
  end

  def deselect_category(category)
    row_by_category(category).checkbox.clear
  end

  def row_by_index(index)
    category_lookup_result_table.rows.item(index)
  end

  def select_category_by_index(index)
    if row_by_index(index).exists? then
      row_by_index(index).checkbox.set
      return row_by_index(index).cells[CATEGORY_NAME_COLUMN].text
    else
      return nil
    end
  end

  def select_categories(index_list)
    index_list.each do |index|
      row_by_index(index).checkbox.set
    end
  end

  def select_all_categories()
    category_lookup_result_table.rows[0].checkbox.set
  end

  def deselect_all_categories()
    category_lookup_result_table.rows[0].checkbox.clear
  end


  def deselect_categories(index_list)
    index_list.each do |index|
      row_by_index(index).checkbox.clear
    end
  end

end