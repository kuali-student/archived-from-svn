class ApplyHold < BasePage

  wrapper_elements
  frame_element
  validation_elements

  element(:frm_popup) { |b| b.iframe(:class=>"fancybox-iframe")}

  ######################################################################################################################
  ###                                            Apply Hold Dialog Constants                                       ###
  ######################################################################################################################
  DIALOG_ACTION = 0

  ######################################################################################################################
  ###                                            Apply Hold Page                                        ###
  ######################################################################################################################
  element(:apply_hold_page) { |b| b.frm.main( id: "KS-ApplyHold-Page")}

  element(:apply_hold_btn) { |b| b.apply_hold_page.button(id: "applyHoldButton")}
  action(:apply_hold){ |b| b.apply_hold_btn.when_present.click}

  ######################################################################################################################
  ###                                            Apply Hold Section                                         ###
  ######################################################################################################################
  element(:apply_hold_section) { |b| b.frm.section(id: "KS-ApplyHold-HoldSection")}
  element(:hold_code_section) { |b| b.apply_hold_section.div(class: "input-group")}

  element(:hold_code_input) { |b| b.hold_code_section.text_field(name: "document.newMaintainableObject.dataObject.holdCode")}
  element(:find_hold_code_link) { |b| b.hold_code_section.a(id: "KS-ApplyHold-HoldCode-Section-CodeInput_quickfinder_act")}
  action(:find_hold_code){ |b| b.find_hold_code_link.when_present.click}
  element(:effective_date) { |b| b.apply_hold_section.text_field(name: "document.newMaintainableObject.dataObject.appliedHold.effectiveDate")}
  element(:first_term) { |b| b.apply_hold_section.text_field(id: /firstTerm/)}

  element(:show_btn) { |b| b.apply_hold_section.button(id: "show_button")}
  action(:show){ |b| b.show_btn.when_present.click}

  ######################################################################################################################
  ###                                             Active Hold Issue Dialog                                         ###
  ######################################################################################################################
  element(:active_hold_dialog) { |b| b.frm_popup.div(id: "holdIssueInfoLookupView")}
  element(:dialog_criteria_table){ |b| b.active_hold_dialog.div(id: "uLookupCriteria").table}
  element(:dialog_results_table){ |b| b.active_hold_dialog.section(id: "uLookupResults").table}

  element(:dialog_code_input) { |b| b.dialog_criteria_table.text_field(name: "lookupCriteria[holdCode]")}

  element(:dialog_search_btn){ |b| b.active_hold_dialog.button(id: "button_search")}
  action(:dialog_search){ |b| b.dialog_search_btn.when_present.click}

  element(:results_select_btn) { |index, b| b.dialog_results_table.rows[(index.to_i+1)].a( text: /Select/)}

  def results_select_by_code code
    index = 0
    index = get_hold( code) if code != nil
    results_select_btn(index).when_present.click

    loading.wait_while_present
    return hold_code_input.value
  end

  def get_hold( code)
    dialog_results_table.rows(text: /#{code}/).each do |row|
      return row.cells[DIALOG_ACTION].a().id[/\d+/]
    end
  end

end