class PopulationsBase < BasePage

  wrapper_elements

  class << self

    def population_lookup_elements
      element(:keyword) { |b| b.frm.text_field(name: "lookupCriteria[keyword]") }
      element(:results_table) { |b| b.frm.table(xpath: "//div[@id='lookup_population']//table") } 

      element(:active) { |b| b.frm.radio(value: "kuali.population.population.state.active") }
      element(:inactive) { |b| b.frm.radio(value: "kuali.population.population.state.inactive") }
      element(:both) { |b| b.frm.radio(value: "both") }
    end

    def population_attribute_elements
      element(:name) { |b| b.frm.text_field(name: "document.newMaintainableObject.dataObject.populationInfo.name") }
      element(:description) { |b| b.frm.text_field(name: "document.newMaintainableObject.dataObject.populationInfo.descr.plain") }
      element(:rule) { |b| b.frm.select(name: "document.newMaintainableObject.dataObject.populationRuleInfo.agendaIds[0]") }
      element(:population) { |b| b.frm.text_field(name: "newCollectionLines['document.newMaintainableObject.dataObject.childPopulations'].name") }
      element(:reference_population) { |b| b.frm.text_field(name: "document.newMaintainableObject.dataObject.referencePopulation.name") }

      action(:lookup_population) { |b| b.frm.link(id: "lookup_searchPopulation_add").click; b.loading.wait_while_present } 
      action(:lookup_ref_population) { |b| b.frm.link(id: "lookup_searchRefPopulation").click; b.loading.wait_while_present }
      action(:add) { |b| b.frm.button(id: "button_searchPopulation_add").click; b.loading.wait_while_present; sleep 1.5 }
    end

  end

end

module PopulationsSearch

  # Results Table Columns...
  POPULATION_NAME = 1
  POPULATION_DESCRIPTION = 2
  POPULATION_TYPE = 3
  POPULATION_STATE = 4

  # Clicks the 'return value' link for the named row
  def return_value(name)
    target_row(name).wait_until_present
    target_row(name).link(text: "return value").wait_until_present
    target_row(name).link(text: "return value").click
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
  def results_list
    names = []
    results_table.wait_until_present
    results_table.rows.each { |row| names << row[POPULATION_NAME].text }
    names.delete_if { |name| name == "" }
    names
  end

  private

  def target_row(name)
    results_table.row(text: /#{name}/)
  end

end

module PopulationEdit

  # Returns (as a string) one of the rules listed in the Rule selection list.
  def random_rule
    rules = []
    rule.options.to_a.each { |item| rules << item.text }
    rules.shuffle!
    rules[0]
  end

  def remove_population(name)
    self.div(text:/#{name}/).link(text: "X").click
    loading.wait_while_present
  end

end

class HoldBase < BasePage

  class << self
    def hold_elements
      element(:hold_name) { |b| b.frm.text_field(name: "name") }
      element(:category_name) { |b| b.frm.select(name: "typeKey") }
      element(:phrase) { |b| b.frm.text_field(name: "descr") }
      element(:owning_organization) { |b| b.frm.text_field(name: "id") }
      action(:lookup_owning_org) { |b| b.frm.button(title:"Search Field").click; b.loading.wait_while_present }
    end
  end
end

class OrganizationBase < BasePage

  class << self
    def organization_elements
      element(:short_name) { |b| b.frm.text_field(name: "lookupCriteria[shortName]") }
      element(:long_name) { |b| b.frm.text_field(name: "lookupCriteria[longName]") }
    end
  end

end

class HolidayBase < BasePage

  element(:holiday_type) { |b| b.frm.select(name: "newCollectionLines['holidays'].typeKey") }
  element(:holiday_start_date) { |b| b.frm.text_field(name: "newCollectionLines['holidays'].startDate") }
  element(:holiday_start_time) { |b| b.frm.text_field(name: "newCollectionLines['holidays'].startTime") }
  element(:holiday_start_meridian) { |b| b.frm.select(name: "newCollectionLines['holidays'].startTimeAmPm") }
  element(:holiday_end_date) { |b| b.frm.text_field(name: "newCollectionLines['holidays'].endDate") }
  element(:holiday_end_time) { |b| b.frm.text_field(name: "newCollectionLines['holidays'].endTime") }
  element(:holiday_end_meridian) { |b| b.frm.text_field(name: "newCollectionLines['holidays'].endTimeAmPm") }
  element(:all_day) { |b| b.frm.checkbox(name: "newCollectionLines['holidays'].allDay") }
  element(:date_range) { |b| b.frm.checkbox(name: "newCollectionLines['holidays'].dateRange") }
  element(:instructional) { |b| b.frm.checkbox(name: "newCollectionLines['holidays'].inst") }
  element(:add_button) { |b| b.frm.button(id: /u\d+_add/) }

  element(:make_official_button) { |b| b.frm.button(text: "Make Official") }

  action(:make_official) { |b| b.make_official_button.click; b.loading.wait_while_present }
  action(:save) { |b| b.frm.button(name: "").click; b.loading.wait_while_present }

end

module Holidays

  def add_all_day_holiday(type, date, inst=false)
    holiday_type.set type
    holiday_start_date.set date
    all_day.set unless all_day.set?
    date_range.clear if date_range.set?
    instruct(inst)
  end

  def add_date_range_holiday(type, start_date, end_date, inst=false)
    all_day.set unless all_day.set?
    date_range.set unless date_range.set?
    holiday_type.set type
    holiday_start_date.set start_date
    holiday_end_date.set end_date
    instruct(inst)
  end

  def add_partial_day_holiday(type, start_date, start_time, start_meridian, end_time, end_meridian, inst=false)
    all_day.clear if all_day.set?
    date_range.clear if date_range.set?
    holiday_type.set type
    holiday_start_date.set start_date
    holiday_start_time.set start_time
    holiday_start_meridian.set start_meridian
    holiday_end_time.set end_time
    holiday_end_meridian.set end_meridian
    instruct(inst)
  end

  def add_partial_range_holiday(type, start_date, start_time, start_meridian, end_date, end_time, end_meridian, inst=false)
    all_day.clear if all_day.set?
    date_range.set unless date_range.set?
    holiday_type.set type
    holiday_start_date.set start_date
    holiday_start_time.set start_time
    holiday_start_meridian.set start_meridian
    holiday_end_date.set end_date
    holiday_end_time.set end_time
    holiday_end_meridian.set end_meridian
    instruct(inst)
  end

  def delete_holiday(holiday_type)
    target_row(holiday_type).button(text: "delete").click
    loading.wait_while_present
  end

  def edit_start_date(holiday_type, date)
    target_row(holiday_type).text_field(name: /startDate/).set date
  end

  def edit_start_time(holiday_type, time, meridian)
    target_row(holiday_type).checkbox(name: /allDay/).clear if target_row(holiday_type).checkbox(name: /allDay/).set?
    target_row(holiday_type).text_field(name: /startTime\d/).set time
    target_row(holiday_type).text_field(name: /startTimeAmPm/).set meridian
  end

  def edit_end_time(holiday_type, time, meridian)
    target_row(holiday_type).checkbox(name: /dateRange/).set unless target_row(holiday_type).checkbox(name: /dateRange/).set?
    target_row(holiday_type).text_field(name: /endTime\d/).set time
    target_row(holiday_type).text_field(name: /endTimeAmPm/).set meridian
  end

  def toggle_all_day(holiday_type)
    if target_row(holiday_type).checkbox(name: /allDay/).set?
      target_row(holiday_type).checkbox(name: /allDay/).clear
    else
      target_row(holiday_type).checkbox(name: /allDay/).set
    end
  end

  def toggle_range(holiday_type)
    if target_row(holiday_type).checkbox(name: /dateRange/).set?
      target_row(holiday_type).checkbox(name: /dateRange/).clear
    else
      target_row(holiday_type).checkbox(name: /dateRange/).set
    end
  end

  def toggle_instructional(holiday_type)
    if target_row(holiday_type).checkbox(name: /instructional/).set?
      target_row(holiday_type).checkbox(name: /instructional/).clear
    else
      target_row(holiday_type).checkbox(name: /instructional/).set
    end
  end

  # Returns a random item from the list of holidays
  def select_random_holiday
    holidays = holiday_type.options
    holidays.delete(0)
    holidays[rand(holidays.length)].text
  end

  private

  def target_row(holiday_type)
    holiday_table.row(text: /#{Regexp.escape(holiday_type)}/)
  end

  def instruct(instr)
    if instr
      instructional.set
    else
      instructional.clear
    end
  end

end