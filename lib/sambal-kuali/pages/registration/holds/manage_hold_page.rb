class ManageHoldIssue < BasePage

  wrapper_elements
  frame_element
  validation_elements

  expected_element :manage_hold_name_input

  element(:frm_popup) { |b| b.iframe(:class=>"fancybox-iframe")}

  ######################################################################################################################
  ###                                            Manage Hold Constants                                               ###
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
  ###                                            Manage Hold Section                                                 ###
  ######################################################################################################################
  element(:manage_hold_page) { |b| b.main(id: "KS-HoldIssue-SearchInput-Page")}
  element(:manage_hold_section) { |b| b.manage_hold_page.section(id: "KS-HoldIssue-CriteriaSection")}

  ######################################################################################################################
  ###                                       Manage Hold Input Fields                                                 ###
  ######################################################################################################################
  element(:manage_hold_name_input) { |b| b.manage_hold_section.text_field(id: "manageHoldNameField_control")}
  element(:manage_hold_code_input) { |b| b.manage_hold_section.text_field(id: "manageHoldCodeField_control")}
  element(:manage_hold_category_select) { |b| b.manage_hold_section.select(id: "manageHoldCategoryField_control")}
  element(:manage_hold_descr_input) { |b| b.manage_hold_section.textarea(id: "manageHoldDescrField_control")}

  ######################################################################################################################
  ###                                            Manage Hold Buttons                                                 ###
  ######################################################################################################################
  element(:manage_hold_show_btn) { |b| b.manage_hold_section.button(id: "show_button")}
  action(:manage_hold_show){ |b| b.manage_hold_show_btn.when_present.click}
  element(:add_hold_btn) { |b| b.manage_hold_section.button(id: "addHoldButton")}
  action(:add_hold){ |b| b.add_hold_btn.when_present.click}
  
  ######################################################################################################################
  ###                                      Manage Hold Results Table                                                 ###
  ######################################################################################################################
  element(:manage_hold_results) { |b| b.manage_hold_page.div( id: "KS-HoldIssue-SearchResults")}
  element(:manage_hold_results_table) { |b| b.manage_hold_results.table}

  def get_hold_code (hold_code)
    if manage_hold_results_table.exists?
      manage_hold_results_table.rows[1..-1].each do |row|
        if ((row.cells[HOLD_CODE].text=~ /#{Regexp.escape(hold_code)}/))
          return row
        end
      end
    end
    return nil
  end

  def get_hold_org (hold_org)
    if manage_hold_results_table.exists?
      manage_hold_results_table.rows[1..-1].each do |row|
        if (row.cells[OWNING_ORG].text=~ /#{Regexp.escape(hold_org)}/)
          return row
        end
      end
    end
    return nil
  end

  def get_hold_auth (hold_auth)
    if manage_hold_results_table.exists?
      manage_hold_results_table.rows[1..-1].each do |row|
        if (row.cells[AUTHORIZATION].text=~ /#{Regexp.escape(hold_auth)}/)
          return row
        end
      end
    end
    return nil
  end

  def edit_hold (hold_name)
    loading.wait_while_present
    wait_until { manage_hold_results_table.row(text: /#{hold_name}/).present? }
    manage_hold_results_table.row(text: /#{hold_name}/).a(id: /manageHoldEditLink_line\d+/).click
  end

  ######################################################################################################################
  ###                                               Create/Edit Hold Section                                         ###
  ######################################################################################################################
  element(:hold_page) { |b| b.main(id: "KS-Hold-Create-Page")}
  element(:hold_section) { |b| b.hold_page.section(id: "KS-CreateHold-HoldSection")}
  element(:hold_org_section) { |b| b.hold_page.div(id: "KS-CreateHold-OrgSection")}
  element(:hold_auth_section) { |b| b.hold_page.section(id: "KS-CreateHold-AuthorizationSection")}

  ######################################################################################################################
  ###                                           Create/Edit Hold Input Fields                                        ###
  ######################################################################################################################
  element(:hold_code_input) { |b| b.hold_section.text_field(name: /dataObject\.holdIssue\.holdCode/)}

  element(:hold_org_find_icon) { |b| b.hold_org_section.a(id: /_quickfinder_act$/)}
  action(:hold_org_find) { |b| b.hold_org_find_icon.when_present.click}

  element(:hold_auth_div) { |b| b.hold_auth_section.div(id: "KS-CreateHold-Auth-OrgSection")}
  element(:hold_auth_find_icon) { |b| b.hold_auth_div.a(id: /_quickfinder_act$/)}
  action(:hold_auth_find_btn) { |b| b.hold_auth_find_icon.when_present.click}

  element(:hold_auth_apply_cbx) { |b| b.hold_auth_div.checkbox(name: /dataObject\.authorizedOrgs\[\d+\]\.authOrgApply$/)}
  action(:hold_auth_apply) { |b| b.hold_auth_apply_cbx.when_present.click}

  ######################################################################################################################
  ###                                             Create/Edit Hold Buttons                                           ###
  ######################################################################################################################
  element(:hold_save_btn) { |b| b.hold_page.button(id: "saveHoldButton")}
  action(:hold_save){ |b| b.hold_save_btn.when_present.click}

  element(:hold_add_org_btn) { |b| b.hold_page.button(id: "KS-CreateHold-AuthorizationSection_Add")}
  action(:hold_add_org){ |b| b.hold_add_org_btn.when_present.click}

  ######################################################################################################################
  ###                                             Create/Edit Hold Org Popup                                         ###
  ######################################################################################################################
  element(:hold_popup) { |b| b.frm_popup.div(id: "organizationInfoLookupView")}
  element(:hold_popup_search_btn){ |b| b.hold_popup.button(id: "button_search")}
  action(:hold_popup_search){ |b| b.hold_popup_search_btn.when_present.click}

  element(:hold_popup_table_section) { |b| b.hold_popup.section(id: "uLookupResults")}
  element(:hold_popup_table){ |b| b.hold_popup_table_section.table}

  element(:hold_popup_table_select_btn) { |index, b| b.hold_popup_table.rows[index].a( text: /Select/)}
  action(:hold_popup_table_select){ |index, b| b.hold_popup_table_select_btn(index).when_present.click}


end