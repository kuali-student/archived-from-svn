class CmLOAdvancedSearchPage < BasePage

  cm_elements

  expected_element :add_categories_button

  #Select Categories popup
  element(:type_select_all_link) {|b| b.frm.a(id: 'CM-Proposal-Course-LoCategory-SelectAll') }
  element(:type_clear_all_link)  {|b|b.frm.a(id: 'CM-Proposal-Course-LoCategoryDeselectAll')}
  element(:category_filter_input) {|b|b.frm.text_field(id: 'CM-Proposal-Course-LoCategory-Filter-Input_control') }


  element(:add_categories_button) { |b| b.frm.button(id: 'CM-Proposal-Course-LoCategory-AddCategory')}
  action(:add_categories) { |b| b.frm.button(id: 'CM-Proposal-Course-LoCategory-AddCategory').click; b.loading_wait }


  element(:lookup_result_table) { |b| b.frm.table(id: "uLookupResults_layout") }
  action(:cancel) { |b| b.frm.button(id: 'cancel').click; b.loading_wait}
  action(:close) { |b| b.frm.a(title: "Close").click }

  element(:selection_option) { |b| b.lookup_result_table.rows[0].a(class: "dropdown-toggle")}
  element(:select_all_results) { |b| b.lookup_result_table.rows[0].div(class: "dropdown dropdown inlineBlock open").link(text: "select all items") }


  CATEGORY_NAME_COLUMN = 1
  CATEGORY_TYPE_COLUMN = 2

  def row_by_category(category)
    lookup_result_table.row(text: /\b#{Regexp.escape(category)}\b/)
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
    #lookup_result_table.rows.item(index)
    lookup_result_table.rows(index)
  end

  def select_category_by_index(index)
    if row_by_index(index).exists?
      row_by_index(index).checkbox.set
      row_by_index(index).cells[CATEGORY_NAME_COLUMN].text
    else
      nil
    end
  end

  def select_categories(index_list)
    index_list.each do |index|
      row_by_index(index).checkbox.set
    end
  end

  def select_multiple_categories(index)
    count = 1
    begin
      lookup_result_table.rows[count].checkbox.set
      sleep 1
      count += 1
    end until count > index
  end

  def select_all_categories
    selection_option.click
    select_all_results.when_present.click

  end

  def deselect_all_categories
    lookup_result_table.rows[0].checkbox.clear
  end


  def deselect_categories(index_list)
    index_list.each do |index|
      row_by_index(index).checkbox.clear
    end
  end

end