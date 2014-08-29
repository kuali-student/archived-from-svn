class CreateHold < BasePage

  wrapper_elements
  frame_element
  validation_elements


  ######################################################################################################################
  ###                                            Create/Edit Hold Constants                                               ###
  ######################################################################################################################
  HOLD_NAME     = 0
  HOLD_CODE     = 1
  CATEGORY      = 2
  DESCRIPTION   = 3
  OWNING_ORG    = 4
  START_DATE    = 5
  END_DATE      = 6
  AUTHORIZATION = 7
  ACTIONS       = 8

  ######################################################################################################################
  ###                                   Create/Edit Hold Org Popup Constants                                         ###
  ######################################################################################################################
  POPUP_ACTION  = 0


  ######################################################################################################################
  element(:create_or_edit_hold_page) { |b| b.main(id: "KS-Hold-Create-Page")}
  element(:create_or_edit_hold_section) { |b| b.create_or_edit_hold_page.section(id: "KS-CreateHold-HoldSection")}
  element(:create_or_edit_hold_org_section) { |b| b.create_or_edit_hold_page.div(id: "KS-CreateHold-OrgSection")}
  element(:create_or_edit_hold_term_section) { |b| b.create_or_edit_hold_page.div(id: "KS-CreateHold-TermSection")}
  element(:create_or_edit_hold_auth_org_section) { |b| b.create_or_edit_hold_page.div(id: "KS-CreateHold-AuthorizationSection")}

  ######################################################################################################################
  ###                                           Create/Edit Hold Input Fields                                        ###
  ######################################################################################################################
  element(:create_or_edit_hold_name) { |b| b.create_or_edit_hold_section.text_field(id: /holdIssueName/)}
  element(:create_or_edit_hold_category) { |b| b.create_or_edit_hold_section.select(id: /holdIssueType/)}
  element(:create_or_edit_code_input) { |b| b.create_or_edit_hold_section.text_field(id: /holdIssueCode/)}
  element(:create_or_edit_hold_descr_input) { |b| b.create_or_edit_hold_section.textarea(id: /holdIssueDescr/)}

  element(:create_or_edit_hold_own_org_find_icon) { |b| b.create_or_edit_hold_org_section.a(id: /holdIssueOwnOrg_quickfinder_act/)}
  action(:create_or_edit_hold_own_org_find) { |b| b.create_or_edit_hold_own_org_find_icon.when_present.click}


  element(:create_or_edit_hold_own_org_contact) { |b| b.create_or_edit_hold_org_section.text_field(id: /holdIssueOwnOrgContact/)}
  element(:create_or_edit_hold_own_org_address) { |b| b.create_or_edit_hold_org_section.text_field(id: /holdIssueOwnOrgAddress/)}

  element(:create_or_edit_hold_first_applied_date) { |b| b.create_or_edit_hold_term_section.text_field(id: /holdFirstAppliedDate/)}
  element(:create_or_edit_hold_last_applied_date) { |b| b.create_or_edit_hold_term_section.text_field(id: /holdLastAppliedDate/)}

  element(:create_or_edit_hold_term_based) { |b| b.create_or_edit_hold_term_section.text_field(id: /holdTermBased/)}
  element(:create_or_edit_hold_first_term) { |b| b.create_or_edit_hold_term_section.text_field(id: /holdFirstAppTerm/)}
  element(:create_or_edit_hold_last_term) { |b| b.create_or_edit_hold_term_section.text_field(id: /holdLastAppTerm/)}
  element(:create_or_edit_hold_history) { |b| b.create_or_edit_hold_term_section.text_field(id: /hold_History/)}

   #Auth Org Table
  #element(:create_or_edit_hold_auth_org_find_icon) { |b| b.create_or_edit_hold_auth_org_table.a(id: /holdIssueOwnOrg_quickfinder_act/)}

  ######################################################################################################################
  ###                                             Create/Edit Hold Buttons                                           ###
  ######################################################################################################################
  element(:create_or_edit_hold_save_btn) { |b| b.create_or_edit_hold_page.button(id: "saveHoldButton")}
  action(:create_or_edit_hold_save){ |b| b.create_or_edit_hold_save_btn.when_present.click}

  element(:create_or_edit_hold_add_org_btn) { |b| b.create_or_edit_hold_page.button(id: "KS-CreateHold-AuthorizationSection_Add")}
  action(:create_or_edit_hold_add_org){ |b| b.create_or_edit_hold_add_org_btn.when_present.click}
  element(:create_or_edit_hold_auth_org_table) { |b| b.create_or_edit_hold_auth_org_section.table}

  ######################################################################################################################
  ###                                             Create/Edit Hold Org Popup                                         ###
  ######################################################################################################################
  element(:create_or_edit_hold_org_popup) { |b| b.frm_popup.div(id: "organizationInfoLookupView")}
  element(:create_or_edit_hold_org_popup_search_btn){ |b| b.create_or_edit_hold_org_popup.button(id: "button_search")}
  action(:create_or_edit_hold_org_popup_search){ |b| b.create_or_edit_hold_org_popup_search_btn.when_present.click}


end