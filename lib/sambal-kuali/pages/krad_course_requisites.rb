class KradCourseRequisites < BasePage

  wrapper_elements
  krad_elements

  action(:expand_all_rule_sections) { |b| b.link(text: '[+] expand all').click; b.add_rule_link.wait_until_present }
  element(:add_rule_link) { |b| b.link(text: 'Add Rule') }
  action(:collapse_all_rule_sections) { |b| b.link(text: '[-] collapse all').click }

  action(:add_rule_student_eligibility) { |b| b.div(id: 'KS-AgendaManage-RulePrototype_ruleA').link(text: 'Add Rule').click; b.loading_wait }
  action(:add_rule_corequisite) { |b| b.div(id: 'KS-AgendaManage-RulePrototype_ruleB').link(text: 'Add Rule').click; b.loading_wait }
  action(:add_rule_recommended_prep) { |b| b.div(id: 'KS-AgendaManage-RulePrototype_ruleC').link(text: 'Add Rule').click; b.loading_wait }
  action(:add_rule_antirequisite) { |b| b.div(id: 'KS-AgendaManage-RulePrototype_ruleD').link(text: 'Add Rule').click; b.loading_wait }
  action(:add_rule_repeatable_for_credits) { |b| b.div(id: 'KS-AgendaManage-RulePrototype_ruleE').link(text: 'Add Rule').click; b.loading_wait }
  action(:add_rule_restricts_credits) { |b| b.div(id: 'KS-AgendaManage-RulePrototype_ruleF').link(text: 'Add Rule').click; b.loading_wait }


  #ADD RULE SECTION

  action(:add_statement) { |b| b.button(text: 'Add Statement').click; b.loading_wait}
  action(:cancel_statement) { |b| b.link(id: 'KS-CancelProp-Button_node_0_parent_root').click; b.loading_wait }

  element(:select_rule_type) { |b| b.select_list(id: 'KRMS-PropositionType-Dropdown_node_0_parent_root_control') }
  action(:preview_change) { |b| b.button(text: 'Preview Change').click }

  action(:delete_rule) { |b| b.button(class: 'btn btn tree-bar-button uif-boxLayoutHorizontalItem kr-delete-button kr-button-primary tree-bar-button-selected').click }

   #BUGS FOR ADDING RULES RIGHT NOW.





  action(:update_rule) { |b| b.button(id: 'KS-UpdateRule-Button').click; b.loading_wait }
  action(:cancel_rule) { |b| b.link(id: 'KS-CancelRule-Button').click; b.loading_wait }

end #class

