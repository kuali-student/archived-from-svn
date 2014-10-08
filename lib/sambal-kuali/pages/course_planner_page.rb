class CoursePlannerPage < BasePage

  page_url  "#{$test_site}/kr-krad/planner"

  wrapper_elements
  frame_element


  expected_element :planner_courses_detail_list,120
  element(:course_planner_header) { |b| b.main(id:"plan-page").div(class:"uif-message")}

  #10 - planner page elements
  action(:add_to_term) { |term,b| b.div(id: "#{term}_planned_add").a(class: "uif-actionLink uif-boxLayoutHorizontalItem").click }

  #20 - add to plan popover elements
  element(:course_code_text) { |b| b.frm.text_field(name: "courseCd") }
  element(:credit) { |b| b.frm.text_field(name: "courseCredit") }
  element(:notes) { |b| b.frm.text_field(name: "courseNote") }
  action(:course_code_term) { |term,code,b| b.div(id:"kuali-atp-#{term}_courses_#{code}_code").p(class: "uif-message").text }
#  action(:course_code_term_backup) { |term,code,b| b.div(id:"kuali-atp-#{term}_backup_#{code}_code").p(class: "uif-message").text }
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
  action(:course_code_edit_click) { |b| b.td(class: "jquerybubblepopup-innerHtml").link(:id => /planner_menu_edit_plan_item_popup*/).click }

  #40 - view course details popover elements
  element(:course_code_current_term_credit) { |b| b.div(class: "uif-messageField credit ks-plan-Bucket-itemCreditCount uif-boxLayoutHorizontalItem").span(class: "uif-message").text }
  element(:view_notes_popover) { |b| b.textarea(name: "courseNote").text }
  element(:view_variable_credit_popover) { |b| b.input(name: "courseCredit").value }
  element(:edit_plan_cancel_link) { |b| b.frm.link(text: "Cancel") }
  action(:edit_plan_cancel) { |b| b.edit_plan_cancel_link.click }
  element(:save) { |b| b.frm.button(text: "Save")}
  action(:save_click) { |b| b.save.click}

  #50 - delete course popover
  element(:delete_course) { |b| b.frm.button(text: "Remove") }
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
  element(:ksap) {|b|b.div(id:"applicationLogo")}
  element(:plan) {|b|b.div(id:"applicationNavigation").a(text:"Plan")}
  element(:find_courses) {|b|b.div(id:"applicationNavigation").a(text:"Find Courses")}
  action(:find_courses_click) {|b|b.find_courses.click}
  element(:bookmarks) {|b|b.div(id:"applicationHeader").span(id:"Ksap-Header-Bookmark-Count-Label")}
  element(:academic_year_2013_2014) {|b|b.div(id:"planner_courses_detail").span(class:"uif-headerText-span")}
  element(:right_arrow) {|b|b.div(id:"planner_courses_detail").a(id:"next_year_button")}
  action(:right_arrow_click) {|b|b.right_arrow.click}
  element(:academic_year_2014_2015) {|b|b.div(id:"planner_courses_detail").span(class:"uif-headerText-span")}
  element(:left_arrow) {|b|b.div(id:"planner_courses_detail").a(id:"previous_year_button")}
  action(:left_arrow_click) {|b|b.left_arrow.click}
  element(:print) {|b|b.div(id:"planner_courses_detail").a(title:"Print")}
  element(:fall_2013) {|b|b.div(id:"planner_courses_detail_list").span(text:"Fall 2013")}
  element(:winter_2014) {|b|b.div(id:"planner_courses_detail_list").span(text:"Winter 2014")}
  element(:spring_2014) {|b|b.div(id:"planner_courses_detail_list").span(text:"Spring 2014")}
  element(:summer_1_2014) {|b|b.div(id:"planner_courses_detail_list").span(text:"Summer I 2014")}
  element(:course_registered_term) {|term,b|b.div(id:/kuali-atp-#{term}_registered.*/)}
  element(:course_planned_term) {|term,b|b.div(id:/kuali-atp-#{term}_courses.*/)}
  element(:course_backup_term) {|term,b|b.div(id:/kuali-atp-#{term}_backup.*/)}
  element(:credit_tally) {|b|b.div(id:"planner_courses_detail").div(class:"uif-messageField ksap-planner-credits uif-boxLayoutHorizontalItem")}
  element(:quick_add) {|state,planned_term,b|b.a(id:/#{planned_term}_#{state}_Addcourse/)}
  element(:course_code_quick_add) {|b|b.text_field(id:"code_control")}
  element(:add_to_plan_quick) {|b|b.button(id:"submit_dialog_button")}
  element(:exception_message) {|b|b.main(id:"planner_add_course_page").div(class:"uif-horizontalBoxGroup uif-boxLayoutVerticalItem clearfix ksap-feedback error ks-Popover-error")}
  action(:course_indicator) {|ccode,term,condition,b|b.div(id:/#{ccode}_kuali-atp-#{term}_#{condition}_statusMessage/).fire_event 'mouseover'}
  value(:indicator_popup) {|b|b.form(id:"kualiForm").td(class:"jquerybubblepopup-innerHtml").text}
  # Elements added for Add course from Bookmark
  element(:term_note_button) { |b| b.img(id:"_termNote") }
  value(:gutter_course_parent_div_id) { |course_code,b| b.div(id: "planner_sidebar_section").p(text: "#{course_code}").parent.attribute_value("id") }
  action(:add_course_bookmark_gutter_click) { |parent_id,b| b.div(id: "planner_sidebar_section").div(id: "#{parent_id}").a(id: /addLink/).click }
  element(:select_term_year) { |b| b.div(id: "planner_term_input").select(id: "planner_term_input_control") }
  element(:text_note) { |b| b.div(id: "notes").textarea(name: "courseNote")}
  element(:mark_as_backup_checkbox) { |b| b.input(type: "checkbox") }
  element(:add_to_plan_dialog) { |b| b.div(id: "KSAP-AddToPlanDialog-FormView") }
  element(:add_course_bookmark_page) { |course_code,b| b.a(id: "#{course_code}_addLink") }
  element(:added_course_planned) { |planned_term,course_code,b| b.div(id: "kuali-atp-#{planned_term}_courses_#{course_code}_code") }
  element(:added_course_backup) { |planned_term,course_code,b| b.div(id: "kuali-atp-#{planned_term}_backup_#{course_code}_code") }
  element(:current_term) {|b|b.h4(class:"uif-headerText")}

  # Elements for notes validation
  element(:edit_course) { |b| b.frm.button(text: "Save",id:"submit_dialog_button") }
  element(:quick_add_notes) { |b|b.text_field(id:"notes_control")}
  element(:added_course_note) { |planned_term,course_code,b|b.div(id: "kuali-atp-#{planned_term}_courses_#{course_code}_courseNote")}
  element(:added_course_note_backup) { |planned_term,course_code,b|b.div(id: "kuali-atp-#{planned_term}_backup_#{course_code}_courseNote")}
  #Elements for term notes validation
  value(:term_note_header_id) { |term,b| b.span(text:"#{term}").parent.parent.attribute_value("id") }
  action(:term_note_icon_click) { |header_id,b| b.header(id: "#{header_id}").div(id: /_termNote/).click }
  element(:term_note_dialog) { |b| b.div(id: "KSAP-TermNoteDialog-FormView") }
  element(:save_term_note) { |b| b.div(id: "KSAP-TermNoteDialog-FormView").button(id: "submit_dialog_button") }
  element(:term_note) { |b| b.div(id: "KSAP-TermNoteDialog-FormView").textarea(name: "termNote") }

end