class CreateHold < BasePage

  wrapper_elements
  frame_element
  validation_elements

  ######################################################################################################################
  ###                                   Hold Authorization Constants                                                 ###
  ######################################################################################################################
  AUTH_ORG = 0
  AUTH_APPLY = 1
  AUTH_EXPIRE = 2

  ######################################################################################################################
  ###                                   Hold Organization Lookup Constants                                           ###
  ######################################################################################################################
  DIALOG_ACTION = 0

  ######################################################################################################################
  ###                                   Hold Page Section                                                            ###
  ######################################################################################################################
  element(:hold_page) { |b| b.frm.main(id: "KS-Hold-Create-Page")}

  element(:error_message) { |b| b.hold_page.div(id: "KS-Hold-Create-Page_messages")}
  value(:get_error_message){ |b| b.loading.wait_while_present; b.error_message.text}

  element(:save_btn) { |b| b.hold_page.button(id: "saveHoldButton")}
  action(:save){ |b| b.loading.wait_while_present; b.save_btn.click}

  ######################################################################################################################
  ###                                           Hold Input Fields                                                    ###
  ######################################################################################################################
  #Details Section
  element(:hold_section) { |b| b.hold_page.section(id: "KS-CreateHold-HoldSection")}

  element(:name_input) { |b| b.hold_section.text_field(name: "document.newMaintainableObject.dataObject.holdIssue.name")}
  element(:category_input) { |b| b.hold_section.select(name: "document.newMaintainableObject.dataObject.holdIssue.typeKey")}
  element(:code_input) { |b| b.hold_section.text_field(name: "document.newMaintainableObject.dataObject.holdIssue.holdCode")}
  element(:descr_input) { |b| b.hold_section.textarea(name: "document.newMaintainableObject.dataObject.descr")}

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

    org_dialog_abbr_input.when_present.set owning_org
    org_dialog_search
    index = get_org owning_org if owning_org != nil
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

  element(:auth_org_name_cell) { |index, b| b.auth_org_table.rows[index.to_i].cells[AUTH_ORG]}
  element(:auth_org_apply_cell) { |index, b| b.auth_org_table.rows[index.to_i].cells[AUTH_APPLY]}
  element(:auth_table_expire_cell) { |index, b| b.auth_org_table.rows[index.to_i].cells[AUTH_EXPIRE]}

  element(:auth_org_find_icon) { |index, b| b.auth_org_table.a(id: /line#{index}_quickfinder_act/)}
  action(:auth_org_find) { |index, b| b.loading.wait_while_present; b.auth_org_find_icon(index).click}

  element(:auth_apply_cbx) { |index, b| b.auth_org_table.checkbox(name: /dataObject\.authorizedOrgs\[#{index}\]\.authOrgApply/)}
  action(:auth_apply) { |index, b| b.loading.wait_while_present; b.auth_apply_cbx(index).click}

  element(:auth_expire_cbx) { |index, b| b.auth_org_table.checkbox(name: /dataObject\.authorizedOrgs\[#{index}\]\.authOrgExpire/)}
  action(:auth_expire) { |index, b| b.loading.wait_while_present; b.auth_expire_cbx(index).click}

  element(:add_auth_org_btn) { |b| b.auth_org_section.button(id: "KS-CreateHold-AuthorizationSection_Add")}
  action(:add_auth_org){ |b| b.loading.wait_while_present; b.add_auth_org_btn.click}

  def get_index_for_empty_row
    if auth_org_name_cell(-1).text_field().id[/line(\d+)/]
      return $1
    end
  end

  def find_auth_org_to_add( auth_org_abbr, index)
    dialog_index = 0

    add_auth_org if auth_org_table.text_field(id: /line#{index}/).value != ""
    auth_org_find( index)

    wait_until { frm_popup.exists? }
    org_dialog_abbr_input.set( auth_org_abbr) if auth_org_abbr != nil
    org_dialog_search

    dialog_index = get_org( auth_org_abbr) if auth_org_abbr != nil
    org_dialog_select dialog_index
  end

  def auth_org_rows( org)
    auth_org_table.rows[1..-1].each do |row|
      if row.cells[AUTH_ORG].text_field().value == org
        return row
      end
    end
    return nil
  end

  ######################################################################################################################
  ###                                             Hold Org Dialog                                                    ###
  ######################################################################################################################
  element(:frm_popup) { |b| b.iframe(:class => "fancybox-iframe")}

  element(:org_dialog) { |b| b.frm_popup.div(id: "organizationInfoLookupView")}
  element(:org_results_table_section) { |b| b.org_dialog.section(id: "uLookupResults")}
  element(:org_results_table){ |b| b.loading.wait_while_present; b.org_results_table_section.table}

  element(:org_dialog_abbr_input) { |b| b.org_dialog.text_field(name: "lookupCriteria[shortName]")}
  element(:org_dialog_name_input) { |b| b.org_dialog.text_field(name: "lookupCriteria[longName]")}

  element(:org_dialog_select_btn) { |index, b| b.org_results_table.rows[index.to_i].a( text: /Select/)}
  action(:org_dialog_select){ |index, b| b.loading.wait_while_present; b.org_dialog_select_btn(index).click}
  element(:org_dialog_search_btn){ |b| b.org_dialog.button(id: "button_search")}
  action(:org_dialog_search){ |b| b.org_dialog_search_btn.when_present.click}

  def get_org org
    org_results_table.rows(text: /#{org}/).each do |row|
      return row.cells[DIALOG_ACTION].a().id[/\d+/]
    end
  end

end