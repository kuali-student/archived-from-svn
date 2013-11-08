class KradActiveDates < BasePage

  wrapper_elements
  krad_elements # for loading

  element(:start_term) {|b| b.select_list(name: /dataObject\.startTerm$/) }
  element(:pilot_course) { |b| b.checkbox(name: /dataObject\.pilotCourse$/) }

  action(:set_pilot_course) { |b| b.pilot_course.set; b.loading_wait }

  element(:end_term) { |b| b.select_list(name: /dataObject\.endTerm$/) }
  # Spring  or Fall followed by date starting 1980
end
