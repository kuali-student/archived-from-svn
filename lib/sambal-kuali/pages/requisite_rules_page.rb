class CmRequisiteRules < BasePage

  wrapper_elements
  cm_elements

  #Action buttons
  action(:add_btn) { |b| b.button(:text => /Add Statement/).when_present.click;  b.loading.wait_while_present}
  action(:edit_btn) { |b| b.button(:text => /Edit/).when_present.click;  b.loading.wait_while_present}
  action(:group_btn) { |b| b.button(:text => /Create Group/).when_present.click;  b.loading.wait_while_present}
  action(:down_btn) { |b| b.button(:text => /Move Down/).when_present.click;  b.loading.wait_while_present}
  action(:up_btn) { |b| b.button(:text => /Move Up/).when_present.click;  b.loading.wait_while_present}
  action(:left_btn) { |b| b.button(:text => /Move Out/).when_present.click; b.loading.wait_while_present}
  action(:right_btn) { |b| b.button(:text => /Move In/).when_present.click;  b.loading.wait_while_present}
  action(:preview_btn) { |b| b.button(:text => /Preview Change/).when_present.click;  b.loading.wait_while_present(60)}
  action(:copy_btn) { |b| b.button(:text => /Copy/).when_present.click;  b.loading.wait_while_present}
  action(:cut_btn) { |b| b.button(:text => /Cut/).when_present.click;  b.loading.wait_while_present}
  action(:paste_btn) { |b| b.button(:text => /Paste/).when_present.click;  b.loading.wait_while_present}
  action(:del_btn) { |b| b.button(:text => /Delete/).when_present.click;  b.loading.wait_while_present}
  action(:add_line_btn) { |b| b.button(:id=>/KRMS-ApprovedCourseStackedCollectionGroup_.*add/).when_present.click;  b.loading.wait_while_present}
  action(:delete_line_btn) { |b| b.button(:text => /delete/).when_present.click;  b.loading.wait_while_present}
  action(:update_rule_btn) { |b| b.button(id: "CM-Proposal-Course-Requisites-UpdateRule-Button").when_present.click; b.loading.wait_while_present(60)}

  element(:right_btn_element) { |b| b.button(:text => /Move In/) }
  element(:cancel_update_link) { |b| b.a(id: "CM-Proposal-Course-Requisites-CancelRule-Button")}
  action(:cancel) { |b| b.cancel_update_link.when_present.click}

  #Add Rule Section
  # This is the drop down for rule statement
  element(:rule_statement_option) {|b|b.select_list(:id => /KRMS-PropositionType-Dropdown.*node_0_parent_root_control/)}
  element(:search_link_element) { |b| b.a(:text => /Advanced Search/)}
  action(:search_link) { |b| b.search_link_element.click;  b.loading.wait_while_present}

  action(:cancel_statement) { |b| b.link(id: 'KS-CancelProp-Button_node_0_parent_root').click; b.loading_wait }

  element(:rule_dropdown) { |b| b.select(:name => /.*editTree.*proposition.typeId/)}
  element(:multi_course_dropdown) { |b| b.select(:name => /.*editTree.*proposition.multipleCourseType/)}
  element(:course_field) { |b| b.text_field(:name => /.*editTree.*proposition\.courseInfo\.code/)}
  element(:free_text_field) { |b| b.textarea(:name => /.*editTree.*proposition\.termParameter/)}
  element(:courses_field) { |b| b.text_field(:name => /.*editTree.*proposition\.courseSet\.clus\'\]\.code/)}
  element(:integer_field) { |b| b.text_field(:name => /.*editTree.*proposition\.parameters\[1\]\.value/)}
  element(:grade_dropdown) { |b| b.select(:name => /.*editTree.*proposition\.termParameter/)}
  element(:duration_field) { |b| b.text_field(:name => /.*editTree.*proposition\.duration/)}
  element(:duration_dropdown) { |b| b.select(:name => /.*editTree.*proposition\.durationType/)}
  element(:program_dropdown) { |b| b.select(:name => /.*editTree.*proposition\.programType/)}
  element(:term_field) { |b| b.text_field(:name => /.*editTree.*proposition\.termCode/)}
  element(:term_two_field) { |b| b.text_field(:name => /.*editTree.*proposition\.termCode2/)}
  element(:population_field) { |b| b.text_field(:name => /.*editTree.*proposition\.population\.name/)}

  action(:completed) { |b| b.radio(:id => /KRMS-GradeScale-Field.*_control_0/).when_present.click}
  action(:letter) { |b| b.radio(:id => /KRMS-GradeScale-Field.*_control_1/).when_present.click}
  action(:pass_fail) { |b| b.radio(:id => /KRMS-GradeScale-Field.*_control_2/).when_present.click}
  action(:percentage) { |b| b.radio(:id => /KRMS-GradeScale-Field.*_control_3/).when_present.click}
  action(:grade) { |b| b.radio(:id => /KRMS-GradeScale-Field.*_control_4/).when_present.click}

  element(:lookup_section) { |b| b.frm_popup.div(id: "CourseLookupView")}
  element(:lookup_results) { |b| b.frm_popup.section(id: "uLookupResults")}
  element(:lookup_course_title) { |b| b.frm_popup.text_field(name: "lookupCriteria[title]")}
  element(:lookup_course_code) { |b| b.frm_popup.text_field(name: "lookupCriteria[code]")}
  element(:lookup_description) { |b| b.frm_popup.text_field(name: "lookupCriteria[description]")}
  element(:lookup_set_name) { |b| b.frm_popup.text_field(name: "lookupCriteria[name]")}
  element(:lookup_population) { |b| b.frm_popup.text_field(name: "lookupCriteria[keyword]")}
  element(:lookup_abrev_org) { |b| b.frm_popup.text_field(name: "lookupCriteria[shortName]")}
  action(:lookup_search_button) { |b| b.frm_popup.button(id: "button_search").click;  b.loading.wait_while_present}
  element(:lookup_results_table) { |b| b.frm_popup.section(id: "uLookupResults").table() }

  element(:preview_change_btn) { |b| b.button(:id => /KS-RulePreview-Button.*parent_root/)}
  action(:preview_change) { |b| b.preview_change_btn.click; b.loading.wait_while_present}

#ADDING RULE COURSE THAT RESTRICTS CREDIT
  element(:rule_multicourse_type){ |b| b.select_list(id: 'KRMS-MultiCourse-Type-Field_control') }
# 'Approved Courses', 'Course Sets', 'Course Ranges (Course numbers, common learning objectives, etc)'
  element(:rule_course_code_multiple) { |b| b.text_field(name: 'newCollectionLines[\'document.newMaintainableObject.editTree.rootElement.children_0_.data.proposition.cluSet.clus\'].code') }
  action(:add_course_code) {|b| b.button(id:'KRMS-ApprovedCourseStackedCollectionGroup_node_0_parent_root_add').click; b.loading_wait }
  element(:course_lookup_table) { |b| b.frame(class: 'fancybox-iframe').table(id: "uLookupResults_layout") }
  element(:select_link) { |index, b| b.frame(class: 'fancybox-iframe').a(id: /line#{index}/) }
  action(:select_course) {|index, b|b.select_link(index).click;  b.loading_wait }

# editing rules
  element(:select_rule_operator) {|level1, level2, b|b.select(:id => "prop_compoundOpCode_node_#{level2}_parent_node_#{level1}_parent_root_control")}
  element(:rule_element_link) {|level, b|b.div(:id => /.*_node_#{level}_parent_node_0_parent_root/)}

# EDIT RULE LOGIC
  element(:edit_rule_logic_tab) { |b| b.link(text: "Edit Rule Logic") }
  action(:edit_rule_logic_action) { |b| b.edit_rule_logic_tab.click; b.loading_wait }
  element(:rule_logic_text) { |b| b.textarea(id: "logicArea_control") }
  action(:rule_logic_preview) { |b| b.button(id: "KRMS-LogicPreview-Button").when_present.click; b.loading_wait  }

end