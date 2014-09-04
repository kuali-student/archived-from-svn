class CreateHold < BasePage

  wrapper_elements
  frame_element
  validation_elements

  element(:frm_popup) { |b| b.iframe(:class => "fancybox-iframe")}

  ######################################################################################################################
  ###                                   Hold Constants                                          ###
  ######################################################################################################################
  NAME = 0
  AUTH_ORG = 0
  DIALOG_ACTION = 0
  CODE = 1
  AUTH_APPLY = 1
  CATEGORY = 2
  AUTH_EXPIRE = 2
  DESCRIPTION = 3
  OWNING_ORG = 4
  START_DATE = 5
  END_DATE = 6
  AUTHORIZATION = 7
  ACTIONS = 8

  ######################################################################################################################
  ###                                   Hold Page Section                                  ###
  ######################################################################################################################
  element(:hold_page) { |b| b.frm.main(id: "KS-Hold-Create-Page")}

  element(:error_message) { |b| b.hold_section.div(id: "KS-Hold-Create-Page_messages")}
  value(:get_error_message){ |b| b.loading.wait_while_present; b.error_message.text}

  element(:save_btn) { |b| b.hold_page.button(id: "saveHoldButton")}
  action(:save){ |b| b.loading.wait_while_present; b.save_btn.click}

  ######################################################################################################################
  ###                                           Hold Input Fields                                        ###
  ######################################################################################################################
  #Details Section
  element(:hold_section) { |b| b.hold_page.section(id: "KS-CreateHold-HoldSection")}

  element(:name_input) { |b| b.hold_section.text_field(name: /dataObject\.holdIssue\.name$/)}
  element(:category_input) { |b| b.hold_section.select(name: /dataObject\.holdIssue\.typeKey$/)}
  element(:code_input) { |b| b.hold_section.text_field(name: /dataObject\.holdIssue\.holdCode$/)}
  element(:descr_input) { |b| b.hold_section.textarea(name: /dataObject\.descr$/)}

  element(:duplicate_error_message) { |b| b.hold_section.div(id: "KS-CreateHold-HoldSection_messages")}
  value(:get_duplicate_error_message){ |b| b.loading.wait_while_present; b.duplicate_error_message.text}

  #Owning Org Section
  element(:owning_org_section) { |b| b.hold_page.div(id: "KS-CreateHold-OrgSection")}

  element(:owning_org_find_icon) { |b| b.owning_org_section.a(id: /quickfinder_act/)}
  action(:owning_org_find) { |b| b.loading.wait_while_present; b.owning_org_find_icon.click}

  element(:owning_org_contact) { |b| b.owning_org_section.text_field(id: /holdIssueOwnOrgContact/)}
  element(:owning_org_address) { |b| b.owning_org_section.text_field(id: /holdIssueOwnOrgAddress/)}

  def find_owning_org( owning_org)
    index = 1

    owning_org_find
    loading.wait_while_present

    org_dialog_search
    index = get_org_index owning_org if owning_org != nil
    org_dialog_select index
  end

  #Term Section
  element(:term_section) { |b| b.hold_page.div(id: "KS-CreateHold-TermSection")}

  element(:first_applied_date) { |b| b.term_section.text_field(id: /holdFirstAppliedDate/)}
  element(:last_applied_date) { |b| b.term_section.text_field(id: /holdLastAppliedDate/)}

  element(:term_based) { |b| b.term_section.text_field(id: /holdTermBased/)}
  element(:first_term) { |b| b.term_section.text_field(id: /holdFirstAppTerm/)}
  element(:last_term) { |b| b.term_section.text_field(id: /holdLastAppTerm/)}
  element(:history) { |b| b.term_section.text_field(id: /hold_History/)}

  #Auth Org Section
  element(:auth_org_section) { |b| b.hold_page.section(id: "KS-CreateHold-AuthorizationSection")}
  element(:auth_org_table_section) { | b| b.auth_org_section.div(id: "KS-CreateHold-Auth-OrgSection")}
  element(:auth_org_table) { |b| b.loading.wait_while_present; b.auth_org_table_section.table}

  element(:auth_org_name_cell) { |index, b| b.auth_org_table.rows[index].cells[AUTH_ORG]}
  element(:auth_org_find_icon) { |index, b| b.auth_org_name_cell(index).a(id: /quickfinder_act/)}
  action(:auth_org_find) { |index, b| b.loading.wait_while_present; b.auth_org_find_icon(index).click}

  element(:auth_org_apply_cell) { |index, b| b.auth_org_table.table.rows[index].cells[AUTH_APPLY]}
  element(:auth_apply_cbx) { |index, b| b.auth_org_apply_cell(index).checkbox(name: /dataObject\.authorizedOrgs\[\d+\]\.authOrgApply$/)}
  action(:auth_apply) { |index, b| b.auth_apply_cbx(index).when_present.click}

  element(:auth_table_expire_cell) { |index, b| b.auth_div.table.rows[index].cells[AUTH_EXPIRE]}
  element(:auth_expire_cbx) { |index, b| b.auth_table_expire_cell(index).checkbox(name: /dataObject\.authorizedOrgs\[\d+\]\.authOrgExpire$/)}
  action(:auth_expire) { |index, b| b.auth_expire_cbx(index).when_present.click}

  element(:add_auth_org_btn) { |b| b.auth_org_section.button(id: "KS-CreateHold-AuthorizationSection_Add")}
  action(:add_auth_org){ |b| b.loading.wait_while_present; b.add_auth_org_btn.click}

  def find_auth_org_to_add( auth_org)
    add_auth_org if auth_org_name_cell.text_field().value != ""
    index = auth_org_name_cell.text_field().id[/\d+/]

    auth_org_find( index)
    loading.wait_while_present

    org_dialog_search
    index = get_org_index auth_org if auth_org != nil
    org_dialog_select index
  end

  ######################################################################################################################
  ###                                             Hold Org Dialog                                         ###
  ######################################################################################################################
  element(:org_dialog) { |b| b.frm_popup.div(id: "organizationInfoLookupView")}
  element(:org_results_table_section) { |b| b.org_dialog.section(id: "uLookupResults")}
  element(:org_results_table){ |b| b.loading.wait_while_present; b.org_results_table_section.table}

  element(:org_dialog_select_btn) { |index, b| b.org_results_table.rows[index].a( text: /Select/)}
  action(:org_dialog_select){ |index, b| b.loading.wait_while_present; b.org_dialog_select_btn(index).click}
  element(:org_dialog_search_btn){ |b| b.org_dialog.button(id: "button_search")}
  action(:org_dialog_search){ |b| b.org_dialog_search_btn.when_present.click}

  action(:get_org_index) { |org, b| b.org_results_table.rows(text: "#{org}").name[/\d+/]}

  def auth_org_rows( org)
    auth_table_section.rows[1..-1].each do |row|
      if row.cells[AUTH_ORG].text_field().value == org
        return row
      end
    end
    return nil
  end

end