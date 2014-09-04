class CoursePlannerPage < BasePage

  page_url  "#{$test_site}/kr-krad/planner"

  wrapper_elements
  frame_element


  expected_element :bookmark_gutter
  element(:course_planner_header) { |b| b.main(id:"plan-page").div(class:"uif-message")}

  #10 - planner page elements
  action(:add_to_term) { |term,b| b.div(id: "#{term}_planned_add").a(class: "uif-actionLink uif-boxLayoutHorizontalItem").click }

  #20 - add to plan popover elements
  element(:course_code_text) { |b| b.frm.text_field(name: "courseCd") }
  element(:credit) { |b| b.frm.text_field(name: "courseCredit") }
  element(:notes) { |b| b.frm.text_field(name: "courseNote") }
  action(:course_code_term) { |term,code,b| b.div(id:"kuali-atp-#{term}_courses_#{code}_code").p(class: "uif-message").text }
  action(:course_code_term_click) { |term,code,b| b.div(id:"kuali-atp-#{term}_courses_#{code}_code").p(class: "uif-message").click }

  #action(:course_code_term_backup) { |term,code,b| b.div(id:"kuali-atp-#{term}_backup_#{code}_code").p(class: "uif-message").text }
  action(:course_code_term_backup) { |term,code,b| b.div(id:"kuali-atp-#{term}_backup_#{code}_code").p(class: "uif-message").text }

  action(:course_code_term_click_backup) { |term,code,b| b.div(id:"kuali-atp-#{term}_backup_#{code}_code").p(class: "uif-message").click }
  #action(:course_code_term_click_backup) { |term,code,b| b.div(id:"kuali-atp-#{term}_backup_#{code}_code").p(class: "uif-message").click }
  action(:add_to_plan) { |b| b.frm.button(text: "Add to Plan").click }

  #30 - right click opera
  # actions

  action(:edit_plan_item_click) { |b| b.td(class: "jquerybubblepopup-innerHtml").a(:id => /planner_menu_edit_plan_item*/).click }
  action(:course_code_delete_click) { |b| b.td(class: "jquerybubblepopup-innerHtml").a(:id => /planner_menu_delete_plan_item*/).click }

  #40 - view course details popover elements
  element(:course_code_current_term_credit) { |b| b.div(class: "uif-messageField credit ks-plan-Bucket-itemCreditCount uif-boxLayoutHorizontalItem").span(class: "uif-message").text }
  element(:view_notes_popover) { |b| b.textarea(name: "courseNote").text }
  element(:view_variable_credit_popover) { |b| b.input(name: "courseCredit").value }
  element(:edit_plan_cancel_link) { |b| b.frm.link(text: "Cancel") }
  action(:edit_plan_cancel) { |b| b.edit_plan_cancel_link.click }
  element(:save) { |b| b.frm.button(text: "Save")}
  action(:save_click) { |b| b.save.click}

  #50 - delete course popover
  element(:delete_course) { |b| b.frm.button(text: "Delete") }
  action(:delete_course_click) { |b| b.delete_course.click }


  #60 - Verify the course code availability in my plan

  action(:course_code_term_myplan_click) { |b| b.course_code_term_myplan.click}
  action(:info_icon) { |term,code,b| b.img(id:"kuali-atp-#{term}_planned_#{code}_courseNote")}
  element(:view_course_summary) {|b| b.td(class:"jquerybubblepopup-innerHtml").a(class:"uif-actionLink uif-boxLayoutVerticalItem clearfix")}
  action(:view_course_summary_click) {|b| b.view_course_summary.click}
  element(:notes_content) {|b| b.textarea(class:"uif-textAreaControl ksap-characterCount ks-plan-Note-input").text}
  element(:close_popup) {|b| b.td(class:"jquerypopover-innerHtml").img(class:"ksap-popup-close")}
  action (:close_popup_click) {|b| b.close_popup.click}
  element(:bookmark_gutter) {|b|b.div(id:"bookmark_summary")}
  element(:view_more_details) {|b|b.a(id:"bookmark_widget_footer")}
  element(:course_interm) {|term,code,b|b.div(id:"kuali-atp-#{term}_planned_#{code}_code")}

  element(:academic_planner_header) {|b|b.div(class:"uif-messageField ksap-plan-header ks-plan-Header-headline uif-boxLayoutHorizontalItem")}
  element(:academic_planner_label) {|b|b.div(class:"uif-message uif-boxLayoutHorizontalItem")}
  element(:planner_courses_detail_list){ |b|b.div(id:"planner_courses_detail_list")}
  #action(:course_page_click) {|b| b.div(id:"applicationNavigation").a(text:"Find Courses").click}
  element(:ksap_loader_planner) {|b|b.div(class:"kasp-loader")}

end

