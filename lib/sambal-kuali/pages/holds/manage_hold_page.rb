class ManageHold < BasePage

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
  element(:manage_hold_page) { |b| b.main(id: "KS-Hold-SearchInput-Page")}
  element(:manage_hold_section) { |b| b.manage_hold_page.div(id: "KS-Hold-CriteriaSection")}

  ######################################################################################################################
  ###                                       Manage Hold Input Fields                                                 ###
  ######################################################################################################################
  element(:manage_hold_name_input) { |b| b.manage_hold_section.text_field(id: /manageHoldNameField/)}
  element(:manage_hold_code_input) { |b| b.manage_hold_section.text_field(id: /manageHoldCodeField/)}
  element(:manage_hold_category_select) { |b| b.manage_hold_section.select(id: /manageHoldCategoryField/)}
  element(:manage_hold_descr_input) { |b| b.manage_hold_section.textarea(id: /manageHoldDescrField/)}

  ######################################################################################################################
  ###                                            Manage Hold Buttons                                                 ###
  ######################################################################################################################
  element(:manage_hold_show_btn) { |b| b.manage_hold_section.button(id: "show_button")}
  action(:manage_hold_show){ |b| b.manage_hold_show_btn.when_present.click}

  ######################################################################################################################
  ###                                      Manage Hold Results Table                                                 ###
  ######################################################################################################################
  element(:manage_hold_results) { |b| b.manage_hold_page.div( id: "KS-HoldSearch-Results")}
  element(:manage_hold_results_table) { |b| b.manage_hold_results.table}

  def get_hold_name_and_description (hold_name, hold_descr)
    if manage_hold_results_table.exists?
      manage_hold_results_table.rows[1..-1].each do |row|
        if ((row.cells[HOLD_NAME].text=~ /#{Regexp.escape(hold_name)}/) || (row.cells[DESCRIPTION].text=~ /#{Regexp.escape(hold_descr)}/))
          return row
        end
      end
    end
    return nil
  end

  def get_hold_rows
    array = []
    if manage_hold_results_table.exists?
      manage_hold_results_table.rows().each do |row|
        array << row
      end
    end
    return array
  end

  def edit_hold (hold_code)
    loading.wait_while_present
    wait_until { manage_hold_results_table.row(text: /#{hold_code}/).present? }
    actions = manage_hold_results_table.row(text: /#{hold_code}/).cells[ACTIONS]
    actions.a(id: /manageHoldEditLink_line\d+/).click
  end

  ######################################################################################################################
  ###                                               Create/Edit Hold Section                                         ###
  ######################################################################################################################
  element(:create_or_edit_hold_page) { |b| b.main(id: "KS-Hold-Create-Page")}
  element(:create_or_edit_hold_section) { |b| b.create_or_edit_hold_page.section(id: "KS-CreateHold-HoldSection")}
  element(:create_or_edit_hold_org_section) { |b| b.create_or_edit_hold_page.div(id: "KS-CreateHold-OrgSection")}

  ######################################################################################################################
  ###                                           Create/Edit Hold Input Fields                                        ###
  ######################################################################################################################
  element(:create_or_edit_hold_own_org_find_icon) { |b| b.create_or_edit_hold_org_section.a(id: /holdIssueOwnOrg_quickfinder_act/)}
  action(:create_or_edit_hold_own_org_find) { |b| b.create_or_edit_hold_own_org_find_icon.when_present.click}

  ######################################################################################################################
  ###                                             Create/Edit Hold Buttons                                           ###
  ######################################################################################################################
  element(:create_or_edit_hold_save_btn) { |b| b.create_or_edit_hold_page.button(id: "saveHoldButton")}
  action(:create_or_edit_hold_save){ |b| b.create_or_edit_hold_save_btn.when_present.click}

  element(:create_or_edit_hold_add_org_btn) { |b| b.create_or_edit_hold_page.button(id: "KS-CreateHold-AuthorizationSection_Add")}
  action(:create_or_edit_hold_add_org){ |b| b.create_or_edit_hold_add_org_btn.when_present.click}

  ######################################################################################################################
  ###                                             Create/Edit Hold Org Popup                                         ###
  ######################################################################################################################
  element(:create_or_edit_hold_org_popup) { |b| b.frm_popup.div(id: "organizationInfoLookupView")}
  element(:create_or_edit_hold_org_popup_search_btn){ |b| b.create_or_edit_hold_org_popup.button(id: "button_search")}
  action(:create_or_edit_hold_org_popup_search){ |b| b.create_or_edit_hold_org_popup_search_btn.when_present.click}

end