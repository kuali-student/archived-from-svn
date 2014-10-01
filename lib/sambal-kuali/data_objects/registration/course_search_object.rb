class CourseSearch < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows
  include Comparable

  attr_reader :search_string,
              :course_code,
              :course_prefix,
              :course_level,
              :selected_section,
              :term_code,
              :term_descr

  MOBILE_BROWSER_WIDTH = 640
  # For some unknown reason, the dimensions in some browser objects are 2x what
  # we set them to.  We set mobile width = 320, so check for <= 640

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :search_string => nil,
        :course_code => nil,
        :course_prefix => nil,
        :course_level => nil,
        :selected_section => nil,
        :term_code => "201208",
        :term_descr => "Fall 2012"
    }
    options = defaults.merge(opts)
    set_options(options)
  end

  def inspect
    "Search string: #{@search_string}, course_code: #{@course_code}, course_level: #{@course_level}, course_prefix: #{@course_prefix}, selected_section: #{@selected_section}, term: #{@term_code} (#{@term_descr})"
  end
  
  def search opts={}
    defaults = {
        :search_string => @search_string,
        :term_code => @term_code,
        :navigate=>false
    }
    options = defaults.merge(opts)

    return nil if (options[:search_string].nil? || options[:term_code].nil?)

    # Check to see whether we're in mobile or large format, and branch accordingly
    browser_size = @browser.window.size
    page_class = (browser_size.width <= MOBILE_BROWSER_WIDTH) ? CourseSearchMobilePage : CourseSearchPage
    if options[:navigate]
      visit page_class
    end

    on page_class do |page|
      sleep 2
      page.go_to_results_page options[:search_string],options[:term_code]
    end

    set_options(options)
  end

  def select_ao opts={}
    return nil if opts[:ao_type].nil? || opts[:ao_code].nil?

    page_class = (@browser.window.size.width <= MOBILE_BROWSER_WIDTH) ? CourseDetailsMobilePage : CourseDetailsPage
    on page_class do |page|
      page.select_box(opts[:ao_code]).wait_until_present
      page.toggle_ao_select(opts[:ao_code])
      wait_until { page.details_heading(opts[:ao_type]).text =~ /Selected/i }
    end
  end

  def select_tab opts={}
    return nil if opts[:ao_type].nil? || opts[:tab].nil? || (@browser.window.size.width > MOBILE_BROWSER_WIDTH)
    on CourseDetailsMobilePage do |page|
      page.details_heading(opts[:ao_type]).wait_until_present
      page.select_tab opts[:ao_type],opts[:tab]
    end
  end

  def select_course
    on CourseSearchPage do |page|
      page.course_code_result_row(@course_code).wait_until_present
      page.select_course(@course_code)
    end
  end
  def edit opts={}
    edit_course_level opts
    edit_course_code opts
    edit_course_prefix opts
    edit_selected_section opts
    edit_term_code opts
    edit_term_descr opts
  end

  def edit_course_level opts={}
     return nil if opts[:course_level].nil?
     set_options(opts)
  end
  private :edit_course_level

  def edit_course_code opts={}
     return nil if opts[:course_code].nil?
     set_options(opts)
  end
  private :edit_course_code

  def edit_course_prefix opts={}
     return nil if opts[:course_prefix].nil?
     set_options(opts)
  end
  private :edit_course_prefix

  def edit_selected_section opts={}
    return nil if opts[:selected_section].nil?
    set_options(opts)
  end
  private :edit_selected_section

  def edit_term_code opts={}
    return nil if opts[:term_code].nil?
    set_options(opts)
  end
  private :edit_term_code

  def edit_term_descr opts={}
    return nil if opts[:term_descr].nil?
    set_options(opts)
  end
  private :edit_term_descr

  def check_sort_order_in_all_pages opts={}
    defaults = {
        :sort_key=> "course_code",
        :sort_order=> "A"
    }
    options = defaults.merge(opts)
    sort_key = options[:sort_key]
    sort_column = case sort_key
                    when "course_code" then CourseSearchPage::COURSE_CODE
                    when "course_title" then CourseSearchPage::COURSE_DESC
                    when "credits" then CourseSearchPage::COURSE_CRED
                  end
    complete_list = []
    on CourseSearchPage do |page|
      complete_list = page.results_all_pages sort_column
    end
    complete_list_sorted_copy = complete_list.sort
    complete_list_sorted_copy.reverse! if options[:sort_order]=="D"
    return (complete_list == complete_list_sorted_copy)
  end
end