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

  #40-add to plan popover elements
  element(:course_term) { |b| b.select(name: "termId") }
  element(:course_note) { |b| b.textarea(name: "courseNote") }




end

