class CourseSectionPage < BasePage

  page_url "#{$test_site}kr-krad/inquiry"

  wrapper_elements
  frame_element
  expected_element :course_termlist,120

 #10-Elements in the course section
  element(:course_detail_header) { |b| b.main(id:"coursedetails-page").header(id:"courseCodeTitle")}
  value(:course_detail) { |b| b.main(id:"coursedetails-page").header(id:"courseCodeTitle").text}
  value(:term_and_course_offering){ |b|b.a(id:"kuali-atp-2014Spring_section_toggle").text }
  element(:term_and_course){ |b|b.a(id:"u128z5dt_line0_toggle")}
  element(:course_offering){ |b|b.section(id:"u11k4e1o_line0_line0").header(id:"u1rmsfyv_line0_line0")}
  element(:course_description){ |b|b.div(id:"courseOfferingDescription_line0_line0")}
  value(:activity_offering_code){|coursedesc_level,courseterm_level,formatlist_level,fo_level,ao_level,b|b.div(id:"code_line#{coursedesc_level}_line#{courseterm_level}_line#{formatlist_level}_line#{fo_level}_line#{ao_level}").text}
  value(:activity_offering_instructor) {|coursedesc_level,courseterm_level,formatlist_level,fo_level,ao_level,b|b.div(id:"instructor_line#{coursedesc_level}_line#{courseterm_level}_line#{formatlist_level}_line#{fo_level}_line#{ao_level}").text}
  value(:activity_offering_days){|coursedesc_level,courseterm_level,formatlist_level,fo_level,ao_level,b|b.div(id:"days_line#{coursedesc_level}_line#{courseterm_level}_line#{formatlist_level}_line#{fo_level}_line#{ao_level}").text}
  value(:activity_offering_time){|coursedesc_level,courseterm_level,formatlist_level,fo_level,ao_level,b|b.div(id:"time_line#{coursedesc_level}_line#{courseterm_level}_line#{formatlist_level}_line#{fo_level}_line#{ao_level}").text}
  value(:activity_offering_location){|coursedesc_level,courseterm_level,formatlist_level,fo_level,ao_level,b|b.div(id:"location_line#{coursedesc_level}_line#{courseterm_level}_line#{formatlist_level}_line#{fo_level}_line#{ao_level}").text}
  value(:activity_offering_seats){|coursedesc_level,courseterm_level,formatlist_level,fo_level,ao_level,b|b.div(id:"seats_line#{coursedesc_level}_line#{courseterm_level}_line#{formatlist_level}_line#{fo_level}_line#{ao_level}").text}
  value(:activity_offering_additional_details){|coursedesc_level,courseterm_level,formatlist_level,fo_level,ao_level,b|b.div(id:"additionalDetails_line#{coursedesc_level}_line#{courseterm_level}_line#{formatlist_level}_line#{fo_level}_line#{ao_level}").text}
  value(:activity_offering_select){|coursedesc_level,courseterm_level,formatlist_level,fo_level,ao_level,b|b.div(id:"select_line#{coursedesc_level}_line#{courseterm_level}_line#{formatlist_level}_line#{fo_level}_line#{ao_level}").text}
  element(:add_plan_link){|coursedesc_level,courseterm_level,formatlist_level,fo_level,ao_level,b|b.div(id:"addPlanLink_line#{coursedesc_level}_line#{courseterm_level}_line#{formatlist_level}_line#{fo_level}_line#{ao_level}")}
  element(:website){|coursedesc_level,courseterm_level,formatlist_level,fo_level,ao_level,b|b.a(id:"classUrl_line#{coursedesc_level}_line#{courseterm_level}_line#{formatlist_level}_line#{fo_level}_line#{ao_level}")}
  element(:restrictions){|coursedesc_level,courseterm_level,formatlist_level,fo_level,ao_level,b|b.a(id:"requirementsUrl_line#{coursedesc_level}_line#{courseterm_level}_line#{formatlist_level}_line#{fo_level}_line#{ao_level}")}
  #Checkbox for adding to plan
  element(:activityoffering_checkbox){|coursedesc_level,courseterm_level,formatlist_level,fo_level,ao_level,b|b.checkbox(id:"select_line#{coursedesc_level}_line#{courseterm_level}_line#{formatlist_level}_line#{fo_level}_line#{ao_level}_control")}
  element(:add_to_button_enabled) {|b|b.button(class:"btn btn-primary btn btn-primary uif-boxLayoutHorizontalItem")}
  element(:add_to_button_disabled) {|b|b.button(id:/addButton/,class:"btn btn-primary btn btn-primary uif-boxLayoutHorizontalItem disabled")}
  element(:add_to_plan_link) {|b|b.a(id:/addLink/)}
#  action(:lecture_lab_discussion) { |course_code,b| b.div(id: /#{course_code}_formatOfferingOptions/).radio(index:0) }
#  action(:lecture) { |course_code,b| b.div(id: /#{course_code}_formatOfferingOptions/).radio(index:1) }
  element(:lecture_lab_discussion) {|b|b.radio(label:"Lecture + Lab + Discussion")}
  element(:lecture) {|b|b.radio(label:"Lecture Only")}
  action(:ao_lecture){|course_code,b| b.div(id: /#{course_code}.*activity-offering-lecture/) }
  action(:ao_discussion){|course_code,b| b.div(id: /#{course_code}.*activity-offering-discussion/) }
  action(:ao_lab){|course_code,b| b.div(id: /#{course_code}.*activity-offering-lab/) }
   element(:course_termlist) {|b|b.div(id:"course-term-list")}
  element(:term_credit) {|term_credit,b|b.a(id:/#{term_credit}_section_toggle/)}
  element(:course_variable_credit) {|course_variable_credit,course_code,b|b.a(id:/#{course_variable_credit}_#{course_code}_section_toggle/)}
  value(:actual_course_code) {|coursedesc_level,courseterm_level,formatlist_level,fo_level,b|b.div(id:"code_line#{coursedesc_level}_line#{courseterm_level}_line#{formatlist_level}_line#{fo_level}").text}
  value(:actual_course_instructor) {|coursedesc_level,courseterm_level,formatlist_level,fo_level,b|b.div(id:"instructor_line#{coursedesc_level}_line#{courseterm_level}_line#{formatlist_level}_line#{fo_level}").text}
  value(:actual_course_days) {|coursedesc_level,courseterm_level,formatlist_level,fo_level,b|b.div(id:"days_line#{coursedesc_level}_line#{courseterm_level}_line#{formatlist_level}_line#{fo_level}").text}
  value(:actual_course_time) {|coursedesc_level,courseterm_level,formatlist_level,fo_level,b|b.div(id:"time_line#{coursedesc_level}_line#{courseterm_level}_line#{formatlist_level}_line#{fo_level}").text}
  value(:actual_course_location) {|coursedesc_level,courseterm_level,formatlist_level,fo_level,b|b.div(id:"location_line#{coursedesc_level}_line#{courseterm_level}_line#{formatlist_level}_line#{fo_level}").text}
  value(:actual_course_seatsopen) {|coursedesc_level,courseterm_level,formatlist_level,fo_level,b|b.div(id:"seats_line#{coursedesc_level}_line#{courseterm_level}_line#{formatlist_level}_line#{fo_level}").text}
  element(:ksap_loader) {|b|b.div(class:"ksap-loader")}
  action(:plan_link_coursesection_click) {|b|b.a(href:"planner?methodToCall=start&viewId=Planner-FormView").click}
  end

