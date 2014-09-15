class CmDecisionsPage < BasePage

  wrapper_elements
  cm_elements
  expected_element :close

  def frm
    self.iframe(class: "fancybox-iframe")
  end

  element(:close) { |b| b.frm.button(id: 'CM-Proposal-Course-CommentsLightBoxContents-cancel') }
  action(:close_dialog) { |b| b.close.click; b.loading_wait}
  action(:close_decision_dialog) { |b| b.frm.a(title: "Close").click }

  element(:decision_result_table) { |b| b.frm.div(id: 'CM-Proposal-Course-DecisionTable').table() }

  def row_by_index(index)
    #decision_result_table.rows.item(index)
    decision_result_table.rows[index].text
  end

  def cells_from_table_row(index)
    row_by_index(index).split
  end

  def cell_text(row, col)
    cells = cells_from_table_row(row)
    cells[col]
  end

end