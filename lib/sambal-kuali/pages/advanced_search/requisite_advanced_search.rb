class CmRequisiteAdvancedSearchPage < BasePage

  expected_element :search_course_code

  def frm
    self.iframe(class: "fancybox-iframe")
  end


  action(:loading_wait) {|b| b.frm.image(alt: "Loading...").wait_while_present }

  element(:search_course_title) { |b| b.frm.text_field(name: 'lookupCriteria[title]') }
  element(:search_course_code) { |b| b.frm.text_field(name: 'lookupCriteria[code]') }
  element(:adv_plain_text_description) { |b| b.frm.text_field(name: 'lookupCriteria[description]') }

  action(:search_return_value) { |title_return_value, b| b.frm.link(title: 'return value ='+"#{title_return_value}").click }
  action(:course_search) { |b| b.frm.button(id: "button_search").click; b.loading_wait;}
  element(:searched_row) { |index, b| b.frm.a(id: /.*_line#{index}/)}
  action(:select_result) { |index, b| b.searched_row(index).click}
  element(:results_table) { |b| b.frm.table(id: "uLookupResults_layout")}

  def return_value(search_text)
    target_row(search_text).wait_until_present(60)
    target_row(search_text).link(text: "Select").wait_until_present(60)
    target_row(search_text).link(text: "Select").click
  end

  def target_row(search_text)
    results_table.row(text: /#{search_text}/)
  end

  def select_first_row
    results_table.link(text:"Select").wait_until_present(60)
  end

  def row_by_index(index)
    #lookup_result_table.rows.item(index)
    results_table.rows(index)
  end

  def select_row(index)
    searched_row(index).wait_until_present(60)
    select_result(index);
  end
end