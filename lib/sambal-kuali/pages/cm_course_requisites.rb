class CmCourseRequisites < BasePage

  wrapper_elements
  cm_elements

  action(:expand_all_rule_sections) { |b| b.link(text: '[+] expand all').click; b.loading_wait }
  # element(:add_rule_link) { |b| b.link(text: 'Add Rule') }
  action(:collapse_all_rule_sections) { |b| b.link(text: '[-] collapse all').click }

  action(:add_rule_student_eligibility) { |b| b.div(id: 'Course-AgendaManage-AddRule_ruleG').link(text: 'Add Rule').click; b.loading_wait }
  action(:edit_rule_student_eligibility) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleG').link(text: 'Edit Rule').click; b.loading_wait }
  action(:delete_rule_student_eligibility) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleG').link(text: 'Delete Rule').click; b.loading_wait }

  action(:add_rule_corequisite) { |b| b.div(id: 'Course-AgendaManage-AddRule_ruleH').link(text: 'Add Rule').click; b.loading_wait }
  action(:edit_rule_corequisite) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleH').link(text: 'Edit Rule').click; b.loading_wait }
  action(:delete_rule_corequisite) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleH').link(text: 'Delete Rule').click; b.loading_wait }

  action(:add_rule_recommended_prep) { |b| b.div(id: 'Course-AgendaManage-AddRule_ruleI').link(text: 'Add Rule').click; b.loading_wait }
  action(:edit_rule_recommended_prep) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleI').link(text: 'Edit Rule').click; b.loading_wait }
  action(:delete_rule_recommended_prep) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleI').link(text: 'Delete Rule').click; b.loading_wait }

  action(:add_rule_antirequisite) { |b| b.div(id: 'Course-AgendaManage-AddRule_ruleJ').link(text: 'Add Rule').click; b.loading_wait }
  action(:edit_rule_antirequisite) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleJ').link(text: 'Edit Rule').click; b.loading_wait }
  action(:delete_rule_antirequisite) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleJ').link(text: 'Delete Rule').click; b.loading_wait }

  action(:add_rule_repeatable_for_credit) { |b| b.div(id: 'Course-AgendaManage-AddRule_ruleK').link(text: 'Add Rule').click; b.loading_wait }
  action(:edit_rule_repeatable_for_credit) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleK').link(text: 'Edit Rule').click; b.loading_wait }
  action(:delete_rule_repeatable_for_credit) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleK').link(text: 'Delete Rule').click; b.loading_wait }

  action(:add_rule_restricts_credits) { |b| b.div(id: 'Course-AgendaManage-AddRule_ruleL').link(text: 'Add Rule').click; b.loading_wait }
  action(:edit_rule_restricts_credits) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleL').link(text: 'Edit Rule').click; b.loading_wait }
  action(:delete_rule_restricts_credits) { |b| b.div(id: 'Course-RuleEdit-ActionLinks_ruleL').link(text: 'Delete Rule').click; b.loading_wait }

end #class

