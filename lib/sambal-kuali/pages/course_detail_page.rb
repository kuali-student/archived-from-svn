class CourseDetailPage < BasePage

  page_url "#{$test_site}kr-krad/inquiry"

  wrapper_elements
  frame_element
  expected_element :add_to_plan

  #10-course description header
  element(:course_detail_header) { |b| b.div(id: "course_details_back_link").span(:data_parent=>"course_details_back_link") }

  #20-course description page data
  action(:course_description) { |course_code,b| b.div(id: "#{course_code}_description") }
  action(:course_requisites) { |course_code,b| b.div(id: "#{course_code}_courseRequisites") }
  action(:scheduled_terms) { |course_code,b| b.div(id: "#{course_code}_scheduledTerms") }
  action(:projected_terms) { |course_code,b| b.div(id: "#{course_code}_projectedTerms") }
  action(:gened_requirements) { |course_code,b| b.div(id: "#{course_code}_courseGenEdRequirements") }
  action(:subject){ |course_code,b| b.div(id: "#{course_code}_courseSubject") }



  #30-course description page buttons
  element(:add_to_plan) { |b| b.button(id: /addPlannedCourse/) }
  action(:add_to_plan_click) { |b| b.add_to_plan.click }
  action(:add_bookmark) { |b| b.button(id: /addSavedCourse/).click }
  action(:remove_bookmark) { |b| b.button(id: /deleteSavedCourse/).click }
  element(:removebookmark){ |b| b.button(id:/deleteSavedCourse/,class:"btn btn-default uif-boxLayoutHorizontalItem")}
  element(:bookmark){ |b| b.button(id:/addSavedCourse/,class:"btn btn-default uif-boxLayoutHorizontalItem")}

  #40-add to plan popover elements
  element(:course_term) { |b| b.select(name: "termId") }
  element(:course_note) { |b| b.textarea(name: "courseNote") }

  #50-course description page links
  element(:section_details){|b|b.div(id:"u11to302").a(id:"ud5rpm1")}

  #message for bookmark and remove bookmark func
  element(:bookmark_message){|b|b.div(id:"bookmarkMessage",class:"uif-message uif-boxLayoutVerticalItem clearfix")}
  element(:remove_bookmark_message){|b|b.div(id:"bookmarkMessage",class:"uif-message uif-boxLayoutVerticalItem clearfix ksap-hide")}
  element(:count_for_bookmark) {|b|b.span(id:"Ksap-Header-Bookmark-Count-Value")}


  element(:term_cdp) { |b| b.select(id:"planner_term_input_control")}
  element(:add_to_plan_notes_cdp) { |b| b.text_field(name:"courseNote") }
  action (:add_to_plan_button_cdp) { |b| b.frm.button(id:"submit_dialog_button").click}

  element(:backup_checkbox_cdp) { |b|b.checkbox(id:"u11ka58i_control",class:"uif-checkboxControl valid")}
end

