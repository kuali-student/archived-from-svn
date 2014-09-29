class BookmarkObject < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows
  include Comparable

  attr_accessor :course_code,
                :planned_term,
                :term

  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        :planned_term=>"2013Summer1",
        :course_code => "ENGL111",
        :term => "Summer I 2013",
        :course_search_result => (make CourseSearchResults)
    }
    options = defaults.merge(opts)
    set_options(options)
  end

  def course_search
    @course_search_result.course_search
  end

  def clear_set_bookmark
    @course_search_result.initial_bookmark_state_clear
    @course_search_result.set_course_bookmark
  end

  def remove_code_planned_backup
    @course_search_result.remove_code_from_planned_backup
  end


  def course_search_results_facets
    on CourseSearch do |page|
      page.course_search_results_facets.wait_until_present
    end
  end

  def plan_page_click
    on CourseSearch do |page|
      page.plan_page_click
    end
  end

  def add_course_bookmark_gutter_to_plan
    course_search
    course_search_results_facets
    clear_set_bookmark
    plan_page_click
    remove_code_planned_backup
    add_course_from_bookmark_gutter
    click_add_button
  end

  def add_course_bookmark_gutter_to_backup
    course_search
    course_search_results_facets
    clear_set_bookmark
    plan_page_click
    remove_code_planned_backup
    add_course_from_bookmark_gutter
    enable_backup_checkbox
    click_add_button
  end

  def add_course_bookmark_page_to_plan
    course_search
    course_search_results_facets
    clear_set_bookmark
    plan_page_click
    remove_code_planned_backup
    add_course_from_bookmark_page
    click_add
    plan_click
    on CoursePlannerPage do |page|
      page.print.wait_until_present(120)
    end
  end

  def add_course_bookmark_page_to_backup
    course_search
    course_search_results_facets
    clear_set_bookmark
    plan_page_click
    remove_code_planned_backup
    add_course_from_bookmark_page
    backup_checkbox
    click_add
    plan_click
    on CoursePlannerPage do |page|
      page.print.wait_until_present(120)
    end
  end

  def add_course_from_bookmark_gutter
    on CoursePlannerPage do |page|
      page.print.wait_until_present(120)
      parent_id=page.gutter_course_parent_div_id(@course_search_result.course_code)
      page.add_course_bookmark_gutter_click(parent_id)
      page.add_to_plan_dialog.wait_until_present
      page.select_term_year.select @course_search_result.term
      page.text_note.set "Test"
    end
  end

  def add_course_from_bookmark_page
    on CoursePlannerPage do |page|
      page.print.wait_until_present(120)
      page.bookmarks.click
      sleep 5
    end
    on BookmarkPage do |page|
      parent_id=page.course_parent_div_id(@course_search_result.course_code)
      page.add_course_bookmark_header_click(parent_id)
      page.add_to_plan_dialog.wait_until_present
      page.select_term_year.select @course_search_result.term
    end
  end

  def backup_checkbox
    on BookmarkPage do |page|
      page.mark_as_backup_checkbox.click
    end
  end

  def enable_backup_checkbox
    on CoursePlannerPage do |page|
      page.mark_as_backup_checkbox.click
    end
  end

  def click_add
    on BookmarkPage do |page|
      page.add_to_plan
      page.add_to_plan_dialog.wait_while_present
      page.plan.click
    end
  end

  def click_add_button
    on CoursePlannerPage do |page|
      page.add_to_plan
      page.add_to_plan_dialog.wait_while_present
    end
  end

  def plan_click
    on CoursePlannerPage do |page|
      page.plan.click
      page.print.wait_until_present(120)
    end
  end

  def verify_added_course_planned
    on CoursePlannerPage do |page|
      page.print.wait_until_present(120)
      page.added_course_planned(@course_search_result.planned_term,@course_search_result.course_code).exists?.should==true
    end
  end

  def verify_added_course_backup
    on CoursePlannerPage do |page|
      page.print.wait_until_present(120)
      page.added_course_backup(@course_search_result.planned_term,@course_search_result.course_code).exists?.should==true
    end
  end

  def add_duplicate_course
    course_search
    course_search_results_facets
    clear_set_bookmark
    plan_page_click
    on CoursePlannerPage do |page|
      page.print.wait_until_present(120)
      parent_id=page.gutter_course_parent_div_id(@course_search_result.course_code)
      page.add_course_bookmark_gutter_click(parent_id)
      page.add_to_plan_dialog.wait_until_present
      count=page.select_term_year.options.count
      for i in 0..count-1
        @value=page.select_term_year.option(index: i).text
        if @value.include?("#{@course_search_result.term}")
          break
        end
      end
    end
  end

  def verify_duplicate_course_planned
    on CoursePlannerPage do |page|
      @value.should == "#{@course_search_result.term} (planned)"
    end
  end

end