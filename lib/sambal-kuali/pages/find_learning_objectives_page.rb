class CmFindLearningObjectivesPage < BasePage

  cm_elements

  expected_element :add_learning_objectives_button

  def frm
    iframe(class: "fancybox-iframe")
  end


  element(:keyword_in_learning_objective) { |b| b.frm.text_field(name: 'lookupCriteria[descr.plain]') }
  element(:learning_objective_category) { |b| b..text_field(name: 'lookupCriteria[name]') }
  element(:organization_name) { |b| b.frm.text_field(name: 'lookupCriteria[orgName]') }
  element(:organization_type) { |b| b.frm.select_list(name:'lookupCriteria[orgType]') }
  element(:add_learning_objectives_button) {|b|b.frm.button(id: 'KS-AddLo-Button')}

  SELECT_COLUMN = 0
  #The popup search result table is used for learning objectives or categories because the table id is the same for two tables
  element(:lookup_result_table) { |b| b.frm.table(id: "uLookupResults_layout") }
  action(:cancel) { |b| b.frm.button(id: 'cancel').click; b.loading_wait}
  action(:close) { |b| b.frm.a(title: "Close").click }

  #Find Learning Objectives popup
  action(:show_learning_objectives) {|b|b.frm.button(id: 'show_learning_objectives_button').click; b.loading_wait}
  action(:add_learning_objectives) {|b|b.frm.button(id: 'KS-AddLo-Button').click; b.loading_wait}

  def row_by_index(index)
    lookup_result_table.rows(index)
  end

  def select_learning_objective_by_index(index)
    if row_by_index(index).exists?
      row_by_index(index).checkbox.set
    else
      nil
    end
  end

  def select_learning_objectives(index_list)
    index_list.each do |index|
      row_by_index(index).checkbox.set
    end
  end

  def select_multiple_learning_objectives(index)
    count = 1
    begin
      lookup_result_table.rows[count].checkbox.set
      sleep 1
      count += 1
    end until count > index
  end

  def deselect_learning_objective(index)
    row_by_index(index).checkbox.clear
  end


  def deselect_learning_objectives(index_list)
    index_list.each do |index|
      row_by_index(index).checkbox.clear
    end
  end

end