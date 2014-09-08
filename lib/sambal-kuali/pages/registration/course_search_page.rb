class CourseSearchPage < LargeFormatRegisterForCourseBase

  page_url "#{$test_site}/registration/#/myCart"

  STATUS_SCHEDULE = "schedule"
  STATUS_WAITLIST = "waitlist"
  PREFIX_WAITLIST = "waitlist_"

  def go_to_results_page (search_string)
    new_url = "#{$test_site}/registration/index.jsp#/search/#{search_string}"
    @browser.goto new_url
    course_input_div.wait_until_present
  end

  # Search input
  element(:course_input_div){ |b| b.div(class: "kscr-Responsive-searchFormWrapper kscr-SearchForm") }
  element(:course_input){ |b| b.text_field(id: "courseSearchCriteria") }
  element(:course_input_button) { |b| b.button(id: "searchSubmit") }
  action(:begin_course_search) { |b| b.course_input_button.click}

  # Add to Cart
  element(:course_code_input) { |b| b.text_field(id: "courseCode") }
  element(:reg_group_code_input) { |b| b.text_field(id: "regCode") }
  element(:add_to_cart_toggle) { |b| b.div(id: "add_to_cart") }
  action(:toggle_add_dialog) { |b| b.add_to_cart_toggle.click }
  element(:submit_button) { |b| b.button(id: "submit") }
  action(:add_to_cart) { |b| b.submit_button.click }

  # Course cards
  element(:remove_course_button) { |course_code,reg_group_code,status=STATUS_SCHEDULE,b| b.button(id: "#{prefix(status)}remove_#{course_code}_#{reg_group_code}") }
  element(:course_code) { |course_code,reg_group_code,status=STATUS_SCHEDULE,b| b.span(id: "#{prefix(status)}course_code_#{course_code}_#{reg_group_code}") }
  element(:edit_course_options_button) { |course_code,reg_group_code,status=STATUS_SCHEDULE,b| b.button(id: "#{prefix(status)}edit_#{course_code}_#{reg_group_code}") }
  action(:edit_course_options) { |course_code,reg_group_code,status=STATUS_SCHEDULE,b| b.edit_course_options_button(course_code,reg_group_code,status).click }

# EDIT COURSE OPTIONS DIALOG
#   context = newItem or cart
  element(:credits_selection_div) { |course_code,reg_group_code,context,b| b.div(id:"#{context}_credits_#{course_code}_#{reg_group_code}") }
  element(:credit_options_more) { |course_code,reg_group_code,status=STATUS_SCHEDULE,b| b.div(id: "#{status}_credits_#{course_code}_#{reg_group_code}_more") }
  action(:more_credit_options) { |course_code,reg_group_code,status=STATUS_SCHEDULE,b| b.credit_options_more(course_code,reg_group_code,status).click }
  element(:credit_option_selection) { |course_code,reg_group_code,status=STATUS_SCHEDULE,credits,b| b.i(id: "#{status}_credits_#{course_code}_#{reg_group_code}_#{credits}") }
  action(:select_credit_option) { |course_code,reg_group_code,status=STATUS_SCHEDULE,credits,b| b.credit_option_selection(course_code,reg_group_code,status,credits).click}
  element(:grading_audit) { |course_code,reg_group_code,context,b| b.i(id: "#{context}_grading_#{course_code}_#{reg_group_code}_Audit") }
  element(:grading_letter) { |course_code,reg_group_code,context,b| b.i(id: "#{context}_grading_#{course_code}_#{reg_group_code}_Letter") }
  element(:grading_pass_fail) { |course_code,reg_group_code,context,b| b.i(id: "#{context}_grading_#{course_code}_#{reg_group_code}_Pass/Fail") }
  element(:edit_save_button) { |course_code,reg_group_code,context,b| b.button(id: "#{context}_save_#{course_code}_#{reg_group_code}") }
  action(:save_edits) { |course_code,reg_group_code,context,b| b.edit_save_button(course_code,reg_group_code,context).click }
  element(:edit_cancel_button) { |course_code,reg_group_code,context,b| b.button(id: "#{context}_cancel_#{course_code}_#{reg_group_code}") }
  action(:cancel_edits) { |course_code,reg_group_code,context,b| b.edit_cancel_button(course_code,reg_group_code,context).click }


  # Facets
  element(:seats_avail_facet_div){ |b| b.div(id: "search_facet_seatsAvailable") }
  element(:seats_avail_toggle) { |b| b.li(id: "search_facet_seatsAvailable_option_Seatsavailable") }
  element(:clear_seats_avail_facet) { |b| b.div(id: "search_facet_clear_seatsAvailable") }
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
  element(:search_results_summary_div) { |b| b.div(id: "search_results_summary") }
  element(:search_results_summary) { |b| b.search_results_summary_div.text }
  element(:display_limit_select) { |b| b.select(id: "display_limit_select") }
  element(:results_table) { |b| b.table(id: "search_results_table") }
  element(:sort_selector) { |column,b| b.i(id: "sort_selector_#{column}") }
  action(:sort_results_by) { |column,b| b.sort_selector(column).click }
  element(:course_code_result_link) { |course_code,b| b.tr(id: "course_detail_row_#{course_code}").td(index: 0).span }
  element(:course_code_result_row) { |course_code,b| b.tr(id: "course_detail_row_#{course_code}") }
  element(:row_result_link) { |result_row,b| result_row.td(index: 0).span }

  # Pagination
  element(:first_page_on) { |b| b.a(id: "firstPageLink") }
  element(:first_page_off) { |b| b.span(id: "firstPage") }
  action(:first_page) { |b| b.first_page_on.click }
  element(:previous_page_on) { |b| b.a(id: "prevPageLink") }
  element(:previous_page_off) { |b| b.span(id: "prevPage") }
  action(:previous_page) { |b| b.previous_page_on.click }
  element(:next_page_on) { |b| b.a(id: "nextPageLink") }
  element(:next_page_off) { |b| b.span(id: "nextPage") }
  action(:next_page) { |b| b.next_page_on.click }
  element(:last_page_on) { |b| b.a(id: "lastPageLink") }
  element(:last_page_off) { |b| b.span(id: "lastPage") }
  action(:last_page) { |b| b.last_page_on.click }

  # Details view
  element(:back_to_search_results) { |b| b.a(id: "returnToSearch") }
  element(:course_description) { |b| b.div(id: "courseDescription").text }

  def self.prefix(status)
    return (status==STATUS_SCHEDULE)?"":PREFIX_WAITLIST
  end

  # Results table column indexes
  COURSE_SEATS_INDICATOR = 0
  COURSE_CODE = 1
  COURSE_DESC = 2
  COURSE_CRED = 3

  COLUMN_HEADINGS = ["","Code","Title","Credits"]

  #Gives the digit for course level comparison, eg ENGL200 would have 2 extracted and compared
  value(:courseLevel){ |row,b| row.cells[COURSE_CODE].text.slice(4,1) }

  def target_result_row_by_course(course_code)
    results_table.rows.each do |row|
      return row if row.cells[COURSE_CODE].text.match course_code
    end
    return nil
  end

  def course_desc_link_by_course (course_code)
    row = target_result_row_by_course (course_code)
    return row
  end

  def course_prefix_by_row(row)
    row.cells[COURSE_CODE].text.slice(0,4)
  end

  def seats_avail_count_number
    seats_avail_count.match('(\d)')[1].to_i
  end


  def show_add_dialog
    toggle_add_dialog unless submit_button.visible?
  end

  def hide_add_dialog
    toggle_add_dialog if submit_button.visible?
  end

  def select_facet(facet_type,facet_value=nil)
    seats_avail_facet_div.wait_until_present
    case facet_type
      when "avail_seats" then
        toggle_seats_avail unless seats_avail_toggle.attribute_value("class") =~ /kscr-SearchFacet-option--Selected/i
        clear_seats_avail_facet.wait_until_present
      when "credit" then
        toggle_credits(facet_value) unless credits_toggle(facet_value).attribute_value("class") =~ /kscr-SearchFacet-option--Selected/i
        clear_credit_facet.wait_until_present
      when "course_level"
        toggle_course_level(facet_value) unless course_level_toggle(facet_value).attribute_value("class") =~ /kscr-SearchFacet-option--Selected/i
        clear_level_facet.wait_until_present
      when "course_prefix"
        toggle_course_prefix(facet_value) unless course_prefix_toggle(facet_value).attribute_value("class") =~ /kscr-SearchFacet-option--Selected/i
        clear_prefix_facet.wait_until_present
    end
    sleep 1
  end

  def clear_facet(facet_type,facet_value=nil)
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

  def show_course_details(course_code, reg_group_code, course_status=STATUS_SCHEDULE)
    sleep 2
    toggle_course_details(course_code, reg_group_code, course_status) unless remove_course_button(course_code, reg_group_code, course_status).visible?
  end

  def select_credits(course_code, reg_group_code, credits, status=STATUS_SCHEDULE)
    # Firefox workaround
    toggle_course_details course_code,reg_group_code,status
    sleep 1
    show_course_details course_code,reg_group_code,status
    sleep 1

    more_credit_options(course_code, reg_group_code, status) if credit_options_more(course_code, reg_group_code, status).visible?
    select_credit_option(course_code, reg_group_code, status, credits)
  end

  def select_grading(course_code, reg_group_code, grading_option, status=STATUS_SCHEDULE)
    case grading_option
      when "Audit" then grading_audit(course_code,reg_group_code,status).click
      when "Letter" then grading_letter(course_code,reg_group_code,status).click
      when "Pass/Fail" then grading_pass_fail(course_code,reg_group_code,status).click
    end
  end

  def sort_results opts={}
    return nil if opts[:sort_key].nil?
    column = case opts[:sort_key]
               when "course code" then
                 COLUMN_HEADINGS[COURSE_CODE]
               when "title" then
                 COLUMN_HEADINGS[COURSE_DESC]
               when "credits" then
                 COLUMN_HEADINGS[COURSE_CRED]
             end
      wait_until { sort_selector(column).visible? }
      sort_results_by(column)
  end

  def navigate_to_course_detail_page opts={}
    return nil if opts[:course_code].nil?
    course_desc_link_by_course(opts[:course_code]).click
  end

  def remove_course_from_cart(course_code, reg_group_code)
    remove_course_button(course_code,reg_group_code,STATUS_SCHEDULE).click
  end

  def toggle_course_details(course_code, reg_group_code, course_status=STATUS_SCHEDULE)
    course_code(course_code,reg_group_code,course_status).wait_until_present
    course_code(course_code,reg_group_code,course_status).click
  end


  def results_list (column=COURSE_CODE)
    list = []
    no_of_rows = get_results_table_rows_no - 1
    (0..no_of_rows).each { |index| list << get_table_row_value(index, column).upcase }   # convert to uppercase because application sort is case-insensitive
    list.delete_if { |item| item == COLUMN_HEADINGS[column].upcase }
    list.delete_if {|item| item == "" }
    list
  end
  private :results_list

  def results_all_pages (column=COURSE_CODE)
    complete_list = []
    first_page if first_page_on.visible?
    if next_page_on.visible?
      until next_page_off.visible?
        partial_list = results_list column
        complete_list.concat(partial_list)
        next_page_on.wait_until_present
        next_page
        wait_until { next_page_on.visible? || next_page_off.visible? }
      end
      partial_list = results_list column
      complete_list.concat(partial_list)
      wait_until { next_page_on.visible? || next_page_off.visible? }
    else
      complete_list = results_list
    end
    complete_list
  end

  def get_table_row_value(index,column,rescues=0)
    begin
      column_name = case column
                      when COURSE_CODE then "code"
                      when COURSE_DESC then "title"
                      when COURSE_CRED then "credits"
                    end
      code = results_table.rows[index].cells[column].text
      return code
    rescue => e
      rescues = rescues+1
      puts "Retrieve #{column_name} for row #{index} rescue from #{e.message}: #{rescues}"
      if rescues<5
        sleep(1)
        get_table_row_value(index,column,rescues)
      else
        puts "Failed to retrieve #{column_name} for row #{index}"
        return ""
      end
    end
  end

  #click on a row to go to details view
  def select_course(course_code)
    course_code_result_row(course_code).click
  end

  # Get number of data table rows safely
  def get_results_table_rows_no(rescues=0)
    begin
      sleep(2)
      return results_table.rows.length
    rescue => e
      rescues = rescues+1
      puts "Retrieve length rescue from #{e.message}: #{rescues}"
      if rescues<5
        return get_results_table_rows_no(rescues)
      else
        puts "Failed to retrieve length"
        return 0
      end
    end
  end

  def results_list_courses (expected)
    trimmed_array_list = Array.new
    if expected.length == 4 || expected.length > 4 && expected[4] == ','
      trimmed_array_list<<(results_all_pages(COURSE_CODE).map! {|x| x.slice(0,4) }).uniq
    elsif expected.length == 5
      trimmed_array_list<<(results_all_pages(COURSE_CODE).map! {|x| x.slice(0,5) }).uniq
    else
      trimmed_array_list<<(results_all_pages(COURSE_CODE).map! {|x| x }).uniq
    end
    trimmed_array_list
  end

end

