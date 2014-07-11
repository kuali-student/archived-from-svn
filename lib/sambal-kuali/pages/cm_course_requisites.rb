class CmCourseRequisites < BasePage

  wrapper_elements
  cm_elements

  action(:expand_all_rule_sections) { |b| b.link(text: '[+] expand all').click; b.add_rule_link.wait_until_present }
  # element(:add_rule_link) { |b| b.link(text: 'Add Rule') }
  action(:collapse_all_rule_sections) { |b| b.link(text: '[-] collapse all').click }

  action(:add_rule_student_eligibility) { |b| b.div(id: 'Course-AgendaManage-AddRule_ruleA').link(text: 'Add Rule').click; b.loading_wait }
  action(:edit_rule_student_eligibility) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleA').link(text: 'Edit Rule').click; b.loading_wait }
  action(:delete_rule_student_eligibility) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleA').link(text: 'Delete Rule').click; b.loading_wait }

  action(:add_rule_corequisite) { |b| b.div(id: 'Course-AgendaManage-AddRule_ruleB').link(text: 'Add Rule').click; b.loading_wait }
  action(:edit_rule_corequisite) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleB').link(text: 'Edit Rule').click; b.loading_wait }
  action(:delete_rule_corequisite) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleB').link(text: 'Delete Rule').click; b.loading_wait }

  action(:add_rule_recommended_prep) { |b| b.div(id: 'Course-AgendaManage-AddRule_ruleC').link(text: 'Add Rule').click; b.loading_wait }
  action(:edit_rule_recommended_prep) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleC').link(text: 'Edit Rule').click; b.loading_wait }
  action(:delete_rule_recommended_prep) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleC').link(text: 'Delete Rule').click; b.loading_wait }

  action(:add_rule_antirequisite) { |b| b.div(id: 'Course-AgendaManage-AddRule_ruleD').link(text: 'Add Rule').click; b.loading_wait }
  action(:edit_rule_antirequisite) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleD').link(text: 'Edit Rule').click; b.loading_wait }
  action(:delete_rule_antirequisite) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleD').link(text: 'Delete Rule').click; b.loading_wait }

  action(:add_rule_repeatable_for_credit) { |b| b.div(id: 'Course-AgendaManage-AddRule_ruleE').link(text: 'Add Rule').click; b.loading_wait }
  action(:edit_rule_repeatable_for_credit) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleE').link(text: 'Edit Rule').click; b.loading_wait }
  action(:delete_rule_repeatable_for_credit) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleE').link(text: 'Delete Rule').click; b.loading_wait }

  action(:add_rule_restricts_credits) { |b| b.div(id: 'Course-AgendaManage-AddRule_ruleF').link(text: 'Add Rule').click; b.loading_wait }
  action(:edit_rule_restricts_credits) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleF').link(text: 'Edit Rule').click; b.loading_wait }
  action(:delete_rule_restricts_credits) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleF').link(text: 'Delete Rule').click; b.loading_wait }

end #class

