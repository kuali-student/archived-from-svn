class PopulationsBase < BasePage

  wrapper_elements
  element(:child_populations_table) { |b| b.frm.section(id: "populations_table").table() }

  class << self

    def population_lookup_elements
      element(:keyword) { |b| b.frm.text_field(name: "lookupCriteria[keyword]") }
      element(:results_table) { |b| b.frm.table(id: "uLookupResults_layout")}

      element(:active) { |b| b.frm.radio(value: "kuali.population.population.state.active") }
      element(:inactive) { |b| b.frm.radio(value: "kuali.population.population.state.inactive") }
      element(:both) { |b| b.frm.radio(value: "both") }
    end

    def population_attribute_elements
      element(:name) { |b| b.frm.text_field(name: "document.newMaintainableObject.dataObject.populationInfo.name") }
      element(:description) { |b| b.frm.text_field(name: "document.newMaintainableObject.dataObject.populationInfo.descr.plain") }
      element(:rule) { |b| b.frm.select(name: "document.newMaintainableObject.dataObject.populationRuleInfo.ruleId") }
      element(:child_population) { |b| b.frm.text_field(name: "newCollectionLines['document.newMaintainableObject.dataObject.childPopulations'].name") }
      element(:reference_population) { |b| b.frm.text_field(name: "document.newMaintainableObject.dataObject.referencePopulation.name") }

      action(:lookup_population) { |b| b.frm.div(data_parent: 'populations_table').link(text: 'Find a Name').click; b.loading.wait_while_present }
      action(:lookup_ref_population) { |b| b.frm.div(data_label: 'Reference Population').when_present.link(text: 'Find a Population').click; b.loading.wait_while_present }
      action(:add) { |b| b.child_populations_table.button(text: "add").click; b.loading.wait_while_present; sleep 1.5 }
    end

    def population_view_elements
      element(:name_label) { |b| b.frm.div(data_label: "Name").label }
      value(:name) { |b| b.frm.div(data_label: "Name").text[/(?<=\n).*/] }
      value(:description) { |b| b.frm.div(data_label: "Description").text[/(?<=\n).*/] }
      value(:state) { |b| b.frm.div(data_label: "State").text[/(?<=\n).*/] }
      value(:rule) { |b| b.frm.div(data_label: "Rule").text[/(?<=\n).*/] }
      value(:operation) { |b| b.frm.div(data_label: "Operation").text[/(?<=\n).*/] }
      value(:reference_population) { |b| b.frm.div(data_label: "Reference Population").text[/(?<=\n).*/] }
    end

  end

end

module PopulationsSearch

  # Results Table Columns...
  ACTION = 0
  POPULATION_NAME = 1
  POPULATION_DESCRIPTION = 2
  POPULATION_TYPE = 3
  POPULATION_STATE = 4

  # Clicks the 'Select' link for the named row
  def return_value(name)
    target_row(name).wait_until_present
    target_row(name).link(text: "Select").wait_until_present
    begin
      target_row(name).link(text: "Select").click
    rescue Timeout::Error => e
      puts "rescued target_row(name).link(text: Select).click"
    end
    loading.wait_while_present
  end

  # Clicks the 'edit' link for the named item in the results table
  def edit(name)
    target_row(name).wait_until_present
    target_row(name).link(text: "edit").click
    loading.wait_while_present
    sleep 0.5 # Needed because the text doesn't immediately appear in the Populations field for some reason
  end

  # Clicks the link for the named item in the results table
  def view(name)
    target_row(name).wait_until_present
    results_table.link(text: name).click
    loading.wait_while_present
  end

  # Returns the status of the named item from the results
  # table. Note that this method assumes that the specified
  # item is actually listed in the results table.
  def status(name)
    target_row(name).wait_until_present
    target_row(name)[POPULATION_STATE].text
  end

  # Returns an array containing the names of the items returned in the search
  def results_list(max_length = 0)
    names = []
    results_table.wait_until_present
    results_table.rows.each do |row|
      names << row[POPULATION_NAME].text
      break if (max_length !=0 and names.length == max_length)
    end

    names.delete_if { |name| name == "" }
    names.delete_if { |name| name == "Name" }
    names
  end

  alias results_names results_list

  def results_descriptions
    descriptions = []
    results_table.wait_until_present
    results_table.rows.each { |row| descriptions << row[POPULATION_DESCRIPTION].text }
    descriptions.delete_if { |description| description == "" }
    descriptions
  end

  def results_states
    states = []
    results_table.wait_until_present
    results_table.rows.each { |row| states << row[POPULATION_STATE].text }
    states.delete_if { |state| state == "" }
    states.delete_if { |state| state == "State" }
    states
  end

  def search_for_random_pop(pops_used_list=[]) #checks to make sure pop not already used
    names = []
    on ActivePopulationLookup do |page|
      page.keyword.wait_until_present
      page.search
      #no_of_full_pages =  [(page.no_of_entries.to_i/10).to_i,5].min
      #page.change_results_page(1+rand(no_of_full_pages))
      names = page.results_list(10)
    end
    #next line ensures population is not used twice
    names = names - pops_used_list
    names[1+rand(names.length-1)]
  end

  def target_row(name)
    results_table.wait_until_present
    results_table.rows.each do |r|
      if (r.cells[POPULATION_NAME].text =~ /#{name}/)
        return r
      end
    end
  end

end

module CalendarUtils

  #there are existing calendars up to 2023, so most of the term codes are used
  BASE_UNUSED_CALENDAR_YEAR = 2230
  MAX_UNUSED_CALENDAR_YEAR = 2699
  def get_random_calendar_year(base_year =BASE_UNUSED_CALENDAR_YEAR, max_year = MAX_UNUSED_CALENDAR_YEAR)
    random_year = base_year + rand( max_year - base_year )
    #make sure that year and next are not already used
    year_used = true
    go_to_calendar_search
    while year_used
      on CalendarSearch do |page|
        page.search_for "Academic Calendar", "", random_year + 1
      end
      on CalendarSearch do |page|
        if page.results_table.exists? then
          year_used = true
          random_year =  random_year + 1
        else
          year_used = false
        end
      end
    end
    puts "ACAL get_random_calendar_year: #{random_year}"
    random_year
  end

end

module CalendarStickyFooter

  PageFactory.element(:acal_sticky_footer_div) { |b| b.frm.div(class: /uif-stickyButtonFooter/,data_parent: /CalendarEditPage/) } # persistent id not possible

  def save(opts = {})
    defaults = {
        :exp_success => true
    }
    options = defaults.merge(opts)
    loading.wait_while_present #solves general sync issues
    sleep 2
    #find elements directly to avoid 'Element is no longer attached to the DOM' error
    @browser.div(class: /uif-stickyButtonFooter/,data_parent: /CalendarEditPage/).button(text: "Save").when_present.click
    #usual way of finding loading icon can be too slow here
    @browser.h1(index: -1).image(alt: "Loading...").wait_until_present(60) #UI just hangs here when saving large ACAL
    loading.wait_while_present(60)
    if options[:exp_success]
      growl_msg_txt = growl_text
      raise "save was not successful - growl text: #{growl_msg_txt}" unless growl_msg_txt.match /saved successfully/
      growl_div.div(class: "jGrowl-close").click
    end
  end

  def cancel
    acal_sticky_footer_div.link(text: "Cancel").click
  end

  def delete_draft
    acal_sticky_footer_div.link(text: "Delete").click
    loading.wait_while_present
    sleep 2 #no growl message shown here
  end
end

module DatePicker
  PageFactory.element(:date_picker_dialog) { |b| b.frm.div(id: "ui-datepicker-div") }
  PageFactory.action(:date_picker_next_month) { |b| b.date_picker_dialog.link(title: 'Next').click }
  PageFactory.action(:date_picker_prev_month) { |b| b.date_picker_dialog.link(title: 'Prev').click }
  PageFactory.action(:date_picker_pick_day) { |day,b| b.date_picker_dialog.link(text: "#{day.to_i}").click }
  PageFactory.value(:date_picker_month_str) { |b| b.date_picker_dialog.span(class: "ui-datepicker-month").text }
  PageFactory.value(:date_picker_month_int) { |b| b.date_picker_dialog.td(class: "ui-datepicker-current-day").attribute_value('data-month').to_i + 1 }
  PageFactory.value(:date_picker_year) { |b| b.date_picker_dialog.span(class: "ui-datepicker-year").text }
  PageFactory.value(:date_picker_day) { |b| b.date_picker_dialog.td(class: "ui-datepicker-current-day").text }

  def date_picker_set (date_picker_element, date_str)
    date_picker_element.click
    temp = date_str.split('/')
    day = temp[1]
    month = temp[0]
    year = temp[2]
    date_picker_pick_year year
    date_picker_pick_month month
    date_picker_pick_day day
  end

  def date_picker_pick_year year
    while year != self.date_picker_year
      if year < self.date_picker_year
        self.date_picker_prev_month
      else
        self.date_picker_next_month
      end
      sleep 0.1
    end
  end

  def date_picker_pick_month month
    int_month = month.to_i
    while int_month != self.date_picker_month_int
      if int_month < self.date_picker_month_int
        self.date_picker_prev_month
      else
        self.date_picker_next_month
      end
      sleep 0.1
    end
  end
end


module PopulationEdit

  def child_populations
    names = []
    child_populations_table.divs(class: "uif-field").each { |div| names << div.text }
    names.delete_if { |name| name == "" || name == "delete" || name == "add" }
  end

  def remove_population(name)
    child_populations_table.row(text: /#{name}/).button(index: 0).click
    loading.wait_while_present
    wait_until { description.enabled? }
    sleep 2 #FIXME - Needed because otherwise the automation causes an application error
  end

end

class RegistrationWindowsBase < BasePage

  wrapper_elements
  validation_elements
  frame_element
  #element(:frm) { |b| b.frame(id: /easyXDM/).frame(id: "iframeportlet") }
  #element(:child_populations_table) { |b| b.frm.div(id: "populations_table").table() }

  class << self


    def registration_window_lookup_elements
      element(:term_type) { |b| b.frm.select(name: "termType") }
      element(:year) { |b| b.frm.text_field(name: "termYear") }
      action(:search) { |b| b.frm.button(text: "Search").click; b.loading.wait_while_present } # Persistent ID needed!
    end

    def registration_window_period_lookup_elements
      element(:period_id) { |b| b.frm.select(name: "periodId") }
      action(:show) { |b| b.frm.button(text: "Show").click; b.loading.wait_while_present }
    end

  end

end

module RegistrationWindowsConstants
  START_DATES_MAP_NAME = 'start_dates_map'
  END_DATES_MAP_NAME = 'end_dates_map'
  DATE_WITHIN = "DATE_WITHIN"
  DATE_WITHIN_REVERSE = "WITHIN_REVERSE"
  DATE_BEFORE = "BEFORE"
  DATE_AFTER = "AFTER"
  DATE_BOUND_START = "START"
  DATE_BOUND_END = "END"
  METHOD_ONE_SLOT_PER_WINDOW = "One Slot per Window"
  METHOD_MAX_SLOTTED_WINDOW = "Max Slotted Window"
  METHOD_UNIFORM_SLOTTED_WINDOW = "Uniform Slotted Window"
end

class RegisterForCourseBase < BasePage

  # expected_element :cr_header_div

  element(:cr_header_div) { |b| b.div(class: "kscr-Header-container ng-scope") }
  element(:header_term_name) { |b| b.span(id: "header_term_name") }

  element(:menu_button) { |b| b.cr_header_div.button(id: "reg_menu_button")}
  action(:menu) { |b| b.menu_button.click }
  element(:term_select) { |b| b.select(id: "searchTerm") }
  element(:search) { |b| b.cr_header_div.link(id: "goToSearch")}
  element(:schedule_link) { |b| b.cr_header_div.link(id: "goToSchedule") }
  element(:cart_link) { |b| b.cr_header_div.link(id: "goToCart") }
  element(:logout_button) { |b| b.cr_header_div.button(id: "logout") }
  action(:logout) { |b| b.logout_button.click }

  element(:reg_locked_message) { |b| b.span(id: "reg_locked_message") }

  def select_term(term)
    term_select.select(term)
  end
end

class LargeFormatRegisterForCourseBase < BasePage

  expected_element :header_term_name

  element(:cr_header_div) { |b| b.div(class: "kscr-Header-container ng-scope") }
  element(:header_term_name) { |b| b.span(id: "header_termName") }

  element(:term_select) { |b| b.select(id: "searchTermDesktop") }
  element(:user_menu_link) { |b| b.span(id: "header_user") }
  action(:user_menu) { |b| b.user_menu_link.click }
  element(:logout_link) { |b| b.li(id:"reg_user_menu_logout") }
  action(:logout) { |b| b.logout_link.click }

  element(:reg_locked_message) { |b| b.span(id: "reg_locked_message").text }

  def select_term(term)
    term_select.select(term)
  end
end

