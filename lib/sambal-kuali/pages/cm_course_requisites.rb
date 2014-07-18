class CmCourseRequisitesPage < BasePage

  wrapper_elements
  cm_elements

  action(:expand_all_rule_sections) { |b| b.div(id: "CourseRequisites-DisclosureLinks-AgendaMaintenance").link(text: '[+] expand all').click; b.loading_wait }
  # element(:add_rule_link) { |b| b.link(text: 'Add Rule') }
  action(:collapse_all_rule_sections) { |b| b.link(text: '[-] collapse all').click }

  #node: A,G,M,S
  action(:add_rule_student_eligibility) { |node, b| b.div(id: "Course-AgendaManage-AddRule_rule#{node}").link(text: 'Add Rule').click; b.loading_wait }
  action(:edit_rule_student_eligibility) { |node, b| b.div(id: "Course-RuleEdit-ActionLinks_rule#{node}").link(text: 'Edit Rule').click; b.loading_wait }
  action(:delete_rule_student_eligibility) { |node, b| b.div(id: "Course-RuleEdit-ActionLinks_rule#{node}").link(text: 'Delete Rule').click; b.loading_wait }

  #node: B,H,N,T
  action(:add_rule_corequisite) { |node, b| b.div(id: "Course-AgendaManage-AddRule_rule#{node}").link(text: 'Add Rule').click; b.loading_wait }
  action(:edit_rule_corequisite) { |node, b| b.div(id: "Course-RuleEdit-ActionLinks_rule#{node}").link(text: 'Edit Rule').click; b.loading_wait }
  action(:delete_rule_corequisite) { |node, b| b.div(id: "Course-RuleEdit-ActionLinks_rule#{node}").link(text: 'Delete Rule').click; b.loading_wait }

  #node: C,I,O,U
  action(:add_rule_recommended_prep) { |node, b| b.div(id: "Course-AgendaManage-AddRule_rule#{node}").link(text: 'Add Rule').click; b.loading_wait }
  action(:edit_rule_recommended_prep) { |node, b| b.div(id: "Course-RuleEdit-ActionLinks_rule#{node}").link(text: 'Edit Rule').click; b.loading_wait }
  action(:delete_rule_recommended_prep) { |node, b| b.div(id: "Course-RuleEdit-ActionLinks_rule#{node}").link(text: 'Delete Rule').click; b.loading_wait }

  #node: D,J,P,V
  action(:add_rule_antirequisite) { |node, b| b.div(id: "Course-AgendaManage-AddRule_rule#{node}").link(text: 'Add Rule').click; b.loading_wait }
  action(:edit_rule_antirequisite) { |node, b| b.div(id: "Course-RuleEdit-ActionLinks_rule#{node}").link(text: 'Edit Rule').click; b.loading_wait }
  action(:delete_rule_antirequisite) { |node, b| b.div(id: "Course-RuleEdit-ActionLinks_rule#{node}").link(text: 'Delete Rule').click; b.loading_wait }

  #node: E,K,Q,W
  action(:add_rule_repeatable_for_credit) { |node, b| b.div(id: "Course-AgendaManage-AddRule_rule#{node}").link(text: 'Add Rule').click; b.loading_wait }
  action(:edit_rule_repeatable_for_credit) { |node, b| b.div(id: "Course-RuleEdit-ActionLinks_rule#{node}").link(text: 'Edit Rule').click; b.loading_wait }
  action(:delete_rule_repeatable_for_credit) { |node, b| b.div(id: "Course-RuleEdit-ActionLinks_rule#{node}").link(text: 'Delete Rule').click; b.loading_wait }

  #node: F,L,R,X
  action(:add_rule_restricts_credits) { |node, b| b.div(id: "Course-AgendaManage-AddRule_rule#{node}").link(text: 'Add Rule').click; b.loading_wait }
  action(:edit_rule_restricts_credits) { |node, b| b.div(id: "Course-RuleEdit-ActionLinks_rule#{node}").link(text: 'Edit Rule').click; b.loading_wait }
  action(:delete_rule_restricts_credits) { |node, b| b.div(id: "Course-RuleEdit-ActionLinks_rule#{node}").link(text: 'Delete Rule').click; b.loading_wait }

end #class

