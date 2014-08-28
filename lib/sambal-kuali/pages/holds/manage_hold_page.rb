class ManageHold < BasePage

  wrapper_elements
  frame_element
  validation_elements

  expected_element :manage_hold_name_input

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
  ACTION_COLUMN = 8

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

  def get_hold_code hold_code
    if manage_hold_results_table.exists?
      manage_hold_results_table.rows[1..-1].each do |row|
        return row if row.cells[HOLD_CODE].text=~ /#{Regexp.escape(hold_code)}/
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

end