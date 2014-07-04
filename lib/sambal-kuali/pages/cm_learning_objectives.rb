class CmLearningObjectives < BasePage

  wrapper_elements
  cm_elements # for loading

  def frm
    frame(class: "fancybox-iframe")
  end

  element(:keyword_in_learning_objective) { |b| b.frame(class: 'fancybox-iframe').textarea(name: 'lookupCriteria[descr.plain]') }
  element(:learning_objective_category) { |b| b.frame(class: 'fancybox-iframe').textarea(name: 'lookupCriteria[name]') }
  element(:organization_name) { |b| b.frame(class: 'fancybox-iframe').textarea(name: 'lookupCriteria[orgName]') }
  element(:organization_type) { |b| b.frame(class: 'fancybox-iframe').select_list(name:'lookupCriteria[orgType]') }
  # ['Student Oversight Unit', 'Deployment Division', 'Financial Control Unit', 'Curriculum Oversight Unit', 'Student Oversight Division',
  # 'Financial Resources Division', 'Curriculum Oversight Division', 'Financial Resources Unit', 'Deployment Unit',
  # 'Administering Org', 'Financial Control Division', 'Curriculum Oversight', 'Institution']

  action(:add_learning_objective) { |b| b.button(id: "LearningObjective-ToolBar-AddNewObjective").click; b.loading_wait }
  action(:find_learning_objective) { |b| b.button(id: "KS-LearningObjective-QuickFinder_act").click; b.loading_wait }

  action(:objective_detail) { |objective_level, b| b.textarea(id: "KS-LoDisplayInfoWrapper-descr_line#{objective_level-1}_control") }
  action(:search_for_lo) { |objective_level,b| b.a(id: "KS-LoDisplayInfoWrapper-descr_line#{objective_level-1}_quickfinder_act") }
  action(:delete_learning_objective) { |objective_level, b| b.a(id: "LearningObjectives-Icon-Delete_line#{objective_level}").click ; b.loading_wait }

  action(:category_detail) { |category_level,b| b.textarea(id: "KS-LearningObjective-Category_line#{category_level-1}_add_control") }
  element(:category_type) { |category_level, b| b.select_list(id: "KS-LearningObjective-CategoryType_line#{category_level-1}_add_control") }
  action(:find_categories) { |category_level, b| b.a(id: "KS-LearningObjective-Category-QuickFinder_line#{category_level-1}_act").click; b.loading_wait }
  action(:add_category) { |objective_level,b| b.button(id: "KS-LearningObjective-Category-Add_line#{objective_level-1}_add").click; b.loading_wait }

  action(:category_detail_added) { |objective_level,category_level,b| b.textarea(id: "KS-LearningObjective-Category_line#{objective_level-1}_line#{category_level-1}" ) }
  action(:delete_category) { |objective_level,category_level,b| b.button(id: "KS-LearningObjective-Category-Delete_line#{objective_level}_line#{category_level}").click; b.loading_wait }

  SELECT_COLUMN = 0
  #The popup search result table is used for learning objectives or categories because the table id is the same for two tables
  element(:lookup_result_table) { |b| b.frm.table(id: "uLookupResults_layout") }
  action(:cancel) { |b| b.frm.button(id: 'cancel').click; b.loading_wait}
  action(:close) { |b| b.frm.a(title: "Close").click }

  #Find Learning Objectives popup
  action(:show_learning_objectives) {|b|b.frm.button(id: 'show_learning_objectives_button').click; b.loading_wait}
  action(:add_learning_objectives) {|b|b.frm.button(id: 'KS-AddLo-Button').click; b.loading_wait}

  #Select Categories popup
  element(:type_select_all_link) {|b| b.frm.a(id: 'Lo-type-selection-select-all-link') }
  element(:type_clear_all_link)  {|b|b.frm.a(id: 'Lo-type-selection-deselect-all-link')}
  element(:category_filter_input) {|b|b.frm.input(id: 'LoCategory-Category-Filter-Input_control') }


  element(:add_categories_button) { |b| b.frm.button(id: 'KSCM-AddCategoryButton')}

  action(:add_categories) { |b| b.frm.button(id: 'KSCM-AddCategoryButton').click; b.loading_wait }

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
    lookup_result_table.rows.item(index)
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
    lookup_result_table.rows[0].checkbox.set
  end

  def deselect_all_categories()
    lookup_result_table.rows[0].checkbox.clear
  end


  def deselect_categories(index_list)
    index_list.each do |index|
      row_by_index(index).checkbox.clear
    end
  end

end
