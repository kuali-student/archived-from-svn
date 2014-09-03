class CreateHold < BasePage

  wrapper_elements
  frame_element
  validation_elements

  element(:frm_popup) { |b| b.iframe(:class=>"fancybox-iframe")}

  ######################################################################################################################
  ###                                   Create/Edit Hold Constants                                          ###
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
  AUTH_ORG      = 0
  AUTH_APPLY    = 1
  AUTH_EXPIRE   = 2

  ######################################################################################################################
  ###                                   Create/Edit Hold Org Popup Constants                                         ###
  ######################################################################################################################
  POPUP_ACTION  = 0


  ######################################################################################################################
  ###                                   Create/Edit Hold Org Page/Section Constants                                  ###
  ######################################################################################################################
  element(:hold_page) { |b| b.frm.main(id: "KS-Hold-Create-Page")}
  element(:hold_section) { |b| b.hold_page.section(id: "KS-CreateHold-HoldSection")}
  element(:hold_org_section) { |b| b.frm.div(id: "KS-CreateHold-OrgSection")}
  element(:hold_term_section) { |b| b.hold_page.div(id: "KS-CreateHold-TermSection")}
  element(:hold_auth_org_section) { |b| b.hold_page.section(id: "KS-CreateHold-AuthorizationSection")}
  element(:hold_duplicate_error_message) { |b| b.frm.div(id: "KS-CreateHold-HoldSection_messages")}
  value(:get_hold_duplicate_error_message){ |b| b.loading.wait_while_present; b.hold_duplicate_error_message.text}
  element(:hold_error_message) { |b| b.frm.div(id: "KS-Hold-Create-Page_messages")}
  value(:get_hold_error_message){ |b| b.loading.wait_while_present; b.hold_error_message.text}

  ######################################################################################################################
  ###                                           Create/Edit Hold Input Fields                                        ###
  ######################################################################################################################
  element(:hold_name) { |b| b.hold_section.text_field(name: /dataObject\.holdIssue\.name$/)}
  element(:hold_category) { |b| b.hold_section.select(name: /dataObject\.holdIssue\.typeKey$/)}
  element(:code_input) { |b| b.hold_section.text_field(name: /dataObject\.holdIssue\.holdCode$/)}
  element(:hold_descr_input) { |b| b.hold_section.textarea(name: /dataObject\.descr$/)}

  element(:hold_own_org_find_icon) { |b| b.hold_org_section.a(id: /quickfinder_act/)}
  action(:hold_own_org_find) { |b| b.hold_own_org_find_icon.when_present.click}


  element(:hold_own_org_contact) { |b| b.hold_org_section.text_field(id: /holdIssueOwnOrgContact/)}
  element(:hold_own_org_address) { |b| b.hold_org_section.text_field(id: /holdIssueOwnOrgAddress/)}

  element(:hold_first_applied_date) { |b| b.hold_term_section.text_field(id: /holdFirstAppliedDate/)}
  element(:hold_last_applied_date) { |b| b.hold_term_section.text_field(id: /holdLastAppliedDate/)}

  element(:hold_term_based) { |b| b.hold_term_section.text_field(id: /holdTermBased/)}
  element(:hold_first_term) { |b| b.hold_term_section.text_field(id: /holdFirstAppTerm/)}
  element(:hold_last_term) { |b| b.hold_term_section.text_field(id: /holdLastAppTerm/)}
  element(:hold_history) { |b| b.hold_term_section.text_field(id: /hold_History/)}

   #Auth Org Table
  element(:hold_add_org_btn) { |b| b.hold_page.button(id: "KS-CreateHold-AuthorizationSection_Add")}
  action(:hold_add_org){ |b| b.hold_add_org_btn.when_present.click}

  element(:hold_auth_div) { |b| b.hold_auth_org_section.div(id: "KS-CreateHold-Auth-OrgSection")}
  element(:hold_auth_table_section) { | b| b.loading.wait_while_present; b.hold_auth_div.table}
  element(:hold_auth_table) { |line, b| b.loading.wait_while_present; b.hold_auth_div.table.rows[line].cells[AUTH_ORG]}
  element(:hold_auth_find_icon) { |line, b| b.hold_auth_table(line).a(id: /_quickfinder_act$/)}
  action(:hold_auth_find_btn) { |line, b| b.hold_auth_find_icon(line).when_present.click}

  element(:hold_auth_table_apply) { |line, b| b.loading.wait_while_present; b.hold_auth_div.table.rows[line].cells[AUTH_APPLY]}
  element(:hold_auth_apply_cbx) { |line, b| b.hold_auth_table_apply(line).checkbox(name: /dataObject\.authorizedOrgs\[\d+\]\.authOrgApply$/)}
  action(:hold_auth_apply) { |line, b| b.hold_auth_apply_cbx(line).when_present.click}

  element(:hold_auth_table_expire) { |line, b| b.loading.wait_while_present; b.hold_auth_div.table.rows[line].cells[AUTH_EXPIRE]}
  element(:hold_auth_expire_cbx) { |line, b| b.hold_auth_table_expire(line).checkbox(name: /dataObject\.authorizedOrgs\[\d+\]\.authOrgExpire$/)}
  action(:hold_auth_expire) { |line, b| b.hold_auth_expire_cbx(line).when_present.click}


  ######################################################################################################################
  ###                                             Create/Edit Hold Buttons                                           ###
  ######################################################################################################################
  element(:hold_save_btn) { |b| b.hold_page.button(id: "saveHoldButton")}
  action(:hold_save){ |b| b.hold_save_btn.when_present.click}

  ######################################################################################################################
  ###                                             Create/Edit Hold Org Popup                                         ###
  ######################################################################################################################
  element(:hold_popup) { |b| b.frm_popup.div(id: "organizationInfoLookupView")}
  element(:hold_popup_search_btn){ |b| b.hold_popup.button(id: "button_search")}
  action(:hold_popup_search){ |b| b.hold_popup_search_btn.when_present.click}

  element(:hold_popup_table_section) { |b| b.hold_popup.section(id: "uLookupResults")}
  element(:hold_popup_table){ |b| b.loading.wait_while_present; b.hold_popup_table_section.table}

  element(:hold_popup_table_select_btn) { |index, b| b.hold_popup_table.rows[index].a( text: /Select/)}
  action(:hold_popup_table_select){ |index, b| b.hold_popup_table_select_btn(index).when_present.click}


  def auth_org_rows(org)
      hold_auth_table_section.rows[1..-1].each do |row|
      if row.cells[AUTH_ORG].text_field().value == org
        return row
      end
      end
    return nil
  end

end