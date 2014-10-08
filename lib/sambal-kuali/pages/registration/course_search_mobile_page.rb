class CourseSearchMobilePage < RegisterForCourseBase

  page_url "#{$test_site}/registration/#/search"

  def go_to_results_page (search_string,term_code)
    new_url = "#{$test_site}/registration/#/search/?searchCriteria=#{search_string}&term=#{term_code}"
    @browser.goto new_url
    course_input_div.wait_until_present
  end

  # Search input
  element(:course_input_div){ |b| b.div(class: "kscr-SearchForm") }
  element(:course_input){ |b| b.text_field(id: "courseSearchCriteria") }
  element(:course_input_button) { |b| b.button(id: "searchSubmit") }
  action(:begin_course_search) { |b| b.course_input_button.click}

  def search_for_a_course(course)
    course_input.set course
    begin_course_search
  end

  # Facets
  element(:show_facets_toggle) { |b| b.link(id: "show_facets_toggle")}
  action(:toggle_show_facets) { |b| b.show_facets_toggle.click }
  #element(:show_facets) { |b| b.span(id: "showFacets")}
  element(:show_facets) { |b| b.span(class: "kscr-SearchFacets-toggle-label")}
  element(:seats_avail_facet_div){ |b| b.div(id: "search_facet_seatsAvailable") }
  element(:credit_facet_div){ |b| b.div(id: "search_facet_creditOptions") }
  element(:course_level_facet_div){ |b| b.div(id: "search_facet_courseLevel") }
  element(:course_prefix_facet_div){ |b| b.div(id: "search_facet_coursePrefix") }
  element(:clear_seats_avail_facet) { |b| b.div(id: "search_facet_clear_seatsAvailable") }
  element(:seats_avail_toggle) { |b| b.li(id: "search_facet_seatsAvailable_option_Seatsavailable") }
  action(:toggle_seats_avail) { |b| b.seats_avail_toggle.click }
  element(:seats_avail_count) { |b| b.seats_avail_toggle.span(index: 1).text }
  element(:credits_toggle) { |credits, b| b.li(id: "search_facet_creditOptions_option_#{credits}") }
  action(:toggle_credits) { |credits, b| b.credits_toggle(credits).click }
  element(:course_level_toggle) { |course_level,b| b.li(id: "search_facet_courseLevel_option_#{course_level}") }
  action(:toggle_course_level) { |course_level,b| b.course_level_toggle(course_level).click }
  element(:course_prefix_toggle) { |course_prefix,b| b.li(id: "search_facet_coursePrefix_option_#{course_prefix}") }
  action(:toggle_course_prefix) { |course_prefix,b| b.course_prefix_toggle(course_prefix).click }
  element(:clear_level_facet) { |b| b.div(id: "search_facet_clear_courseLevel") }
  element(:clear_prefix_facet) { |b| b.div(id: "search_facet_clear_coursePrefix") }
  element(:clear_credit_facet) { |b| b.div(id: "search_facet_clear_creditOptions") }

  # Results

  element(:results_list){ |b| b.div(id: "search-results-list")}
  element(:result_item) { |course_code,b| b.div(id: "course_detail_result_#{course_code}")}
  action(:select_course) { |course_code,b| b.result_item(course_code).click}
  element(:result_item_courseCode) { |course_code,b| b.div(id: "search-result-column-#{course_code}-courseCode")}
  element(:result_item_longName) { |course_code,b| b.div(id: "search-result-column-#{course_code}-longName")}
  element(:result_item_credits) { |course_code,b| b.div(id: "search-result-column-#{course_code}-creditOptions")}

  COURSE_CODE = 1
  COURSE_DESC = 2
  COURSE_CRED = 3

  #Gives the digit for course level comparison, eg ENGL200 would have 2 extracted and compared
  value(:courseLevel){ |row,b| row.cells[COURSE_CODE].text.slice(4,1) }

  #click on a card to go to details view
  def select_course(course_code)
    result_item(course_code).click
  end

  def all_subject_codes
    sleep 3 # wait for complete list to be rendered
    (all_results(COURSE_CODE).map! { |course_code| course_code[0, 4] }).uniq
  end

  def all_results (column=COURSE_CODE)
    class_name_suffix = case column
                          when COURSE_CODE then "courseCode"
                          when COURSE_DESC then "longName"
                          when COURSE_CRED then "creditOptions"
                        end
    results = []
    results_list.wait_until_present
    results_list.divs(class: "kscr-Search-result-column-#{class_name_suffix}").each do |div|
      results << div.text
    end
    results
  end

  def seats_avail_count_number
    seats_avail_count.match('(\d)')[1].to_i
  end

  def select_facet(facet_type,facet_value=nil)
    show_facets_toggle.wait_until_present
    toggle_show_facets if show_facets.visible?
    seats_avail_facet_div.wait_until_present
    case facet_type
      when "avail_seats" then
        toggle_seats_avail unless seats_avail_toggle.attribute_value("class") =~ /kscr-SearchFacet-option--Selected/i
        clear_seats_avail_facet.wait_until_present
      when "credit" then
        credit_facet_div.wait_until_present
        toggle_credits(facet_value) unless credits_toggle(facet_value).attribute_value("class") =~ /kscr-SearchFacet-option--Selected/i
        clear_credit_facet.wait_until_present
      when "course_level"
        course_level_facet_div.wait_until_present
        toggle_course_level(facet_value) unless course_level_toggle(facet_value).attribute_value("class") =~ /kscr-SearchFacet-option--Selected/i
        clear_level_facet.wait_until_present
      when "course_prefix"
        course_prefix_facet_div.wait_until_present
        toggle_course_prefix(facet_value) unless course_prefix_toggle(facet_value).attribute_value("class") =~ /kscr-SearchFacet-option--Selected/i
        clear_prefix_facet.wait_until_present
    end
    sleep 1
  end

  def clear_facet(facet_type,facet_value=nil)
    show_facets_toggle.wait_until_present
    toggle_show_facets if show_facets.visible?
    seats_avail_facet_div.wait_until_present
    case facet_type
      when "avail_seats" then
        toggle_seats_avail if seats_avail_toggle.attribute_value("class") =~ /kscr-SearchFacet-option--Selected/i
        clear_seats_avail_facet.wait_while_present
      when "credit" then
        toggle_credits(facet_value) if credits_toggle(facet_value).attribute_value("class") =~ /kscr-SearchFacet-option--Selected/i
        clear_credit_facet.wait_while_present
      when "course_level" then
        toggle_course_level(facet_value) if course_level_toggle(facet_value).attribute_value("class") =~ /kscr-SearchFacet-option--Selected/i
        clear_level_facet.wait_while_present
      when "course_prefix" then
        toggle_course_prefix(facet_value) if course_prefix_toggle(facet_value).attribute_value("class") =~ /kscr-SearchFacet-option--Selected/i
        clear_prefix_facet.wait_while_present
    end
  end

end

