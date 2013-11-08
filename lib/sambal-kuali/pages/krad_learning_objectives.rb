class KradLearningObjectives < BasePage

  wrapper_elements
  krad_elements # for loading

  action(:lookup_multiple_lines) { |b| b.link(text: 'Lookup/Add Multiple Lines').click }
  #SEARCH POPUP
  element(:search_by) { |b| b.frame(class: 'fancybox-iframe').select_list(id: 'lookupCriteria[searchBy]') }
  # values are ['COURSE_AND_PROGRAM', 'COURSE_ONLY', 'PROGRAM_ONLY']
  element(:keyword_in_learning_objective) { |b| b.frame(class: 'fancybox-iframe').text_field(name: 'lookupCriteria[descr.plain]') }
  element(:learning_objective_category) { |b| b.frame(class: 'fancybox-iframe').text_field(name: 'lookupCriteria[name]') }
  element(:organization_name) { |b| b.frame(class: 'fancybox-iframe').text_field(name: 'lookupCriteria[orgName]') }
  element(:organization_type) { |b| b.frame(class: 'fancybox-iframe').select_list(name:'lookupCriteria[orgType]') }
  # ['Student Oversight Unit', 'Deployment Division', 'Financial Control Unit', 'Curriculum Oversight Unit', 'Student Oversight Division',
  # 'Financial Resources Division', 'Curriculum Oversight Division', 'Financial Resources Unit', 'Deployment Unit',
  # 'Administering Org', 'Financial Control Division', 'Curriculum Oversight', 'Institution']

  action(:search) { |b| b.frame(class: 'fancybox-iframe').button(id: 'button_search').click; b.loading_wait }
  action(:clear_search) { |b| b.frame(class: 'fancybox-iframe').button(id: 'button_clearValues').click }
  action(:close) { |b| b.frame(class: 'fancybox-iframe').button(id: 'button_close').click }
  action(:close_x) { |b| b.div(class: 'fancybox-item fancybox-close').click }

  action(:return_selected) { |b| b.frame(class: 'fancybox-iframe').button(text: 'return selected').click }

  action(:add_learning_objective) { |b| b.frame(class: 'fancybox-iframe').button(id: 'LearningObjective-CollectionSection_add').click; b.loading_wait }

  action(:objective_detail) { |objective_level='0', b| b.text_field(id: /^KS-LoDisplayInfoWrapper-descr_line#{objective_level}/) }
  action(:objective_category) {|objective_level='0', b| b.text_field(name: /^newCollectionLines\[\'document\.newMaintainableObject\.loDisplayWrapperModel\.loWrappers_#{objective_level}/) }

end