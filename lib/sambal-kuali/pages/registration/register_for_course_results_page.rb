class RegisterForCourseSearchResults < RegisterForCourseBase

  # Facets
  element(:seats_avail_toggle) { |b| b.li(id: "search_facet_seatsAvailable_option_seatsAvailable") }
  action(:toggle_seats_avail) { |b| b.seats_avail_toggle.click }
  element(:credits_toggle) { |credits, b| b.li(id: "search_facet_creditOptions_option_#{credits}") }
  action(:toggle_credits) { |credits, b| b.credits_toggle(credits).click }
  element(:course_level_toggle) { |course_level,b| b.li(id: "search_facet_courseLevel_option_#{course_level}") }
  action(:toggle_course_level) { |course_level,b| b.course_level_toggle(course_level).click }
  element(:course_prefix_toggle) { |course_prefix,b| b.li(id: "search_facet_coursePrefix_option_#{course_prefix}") }
  action(:toggle_course_prefix) { |course_prefix,b| b.course_prefix_toggle(course_prefix).click }

  # Results
  element(:search_results_summary_div) { |b| b.div(id: "search_results_summary") }
  element(:search_results_summary) { |b| b.search_results_summary_div.text }
  element(:display_limit_select) { |b| b.select(id: "display_limit_select") }
  element(:results_table) { |b| b.table(id: "search_results_table") }

  # Table column indexes
  COURSE_CODE = 0
  COURSE_DESC = 1
  COURSE_CRED = 2

  def go_to_results_page (search_string,term_code)
    page_url = "#{$test_site}/registration/#/search/?searchCriteria=#{search_string}&term=#{term_code}"
    @browser.goto page_url
  end

  def target_result_row_by_course(course_code)
    results_table.rows.each do |row|
      return row if row.cells[COURSE_CODE].text.match course_code
    end
    return nil
  end
  
  def course_title_by_course (course_code)
    item = target_result_row_by_course (course_code)
    row.cells[COURSE_DESC].text
  end

  def course_desc_link_by_course (course_code)
    row = target_result_row_by_course (course_code)
    row.cells[COURSE_DESC].link
  end

  def credits_by_course (course_code)
    item = target_result_row_by_course (course_code)
    row.cells[COURSE_CRED].text
  end

  def target_result_row_by_index(ind)
    results_table.rows[ind]
  end

  def course_code_by_index(index)
    row = target_result_row_by_index (index)
    row.cells[COURSE_CODE].text
  end

  def course_title_by_index (index)
    item = target_result_row_by_index (index)
    row.cells[COURSE_DESC].text
  end
  
  def course_desc_link_by_index (index)
    row = target_result_row_by_index (index)
    row.cells[COURSE_DESC].link
  end

  def credits_by_index (index)
    item = target_result_row_by_index (index)
    row.cells[COURSE_CRED].text
  end

end