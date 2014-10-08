# Request by or on behalf of a student to register for a course offering by registration group
#
#
# Note the use of the ruby options hash pattern re: setting attribute values
class RegistrationRequest < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows

  #string - generally set using options hash
  attr_accessor :student_id,
                :term_code,
                :term_descr,              #TODO - get term descr from term_code so they are always in sync
                :course_code,
                :reg_group_code,
                :context
  #array - generally set using options hash
  attr_reader   :course_options
  #boolean - - generally set using options hash true/false
  attr_reader   :course_has_options
  attr_reader   :modify_course_options

  CONTEXT_NEW_ITEM = "newItem"
  CONTEXT_CART = "cart"
  STATUS_SCHEDULE = "schedule"
  STATUS_WAITLIST = "waitlist"

  # provides default data:
  #  defaults = {
  #    :student_id=>"student",
  #    :term_code=>"201201",
  #    :term_descr=>"Spring 2012",
  #    :course_code=>"CHEM231",
  #    :reg_group_code=>"1001",
  #    :course_has_options=> true,
  #    :modify_course_options=> false,   This refers only to modifying during add to cart operation
  #    :context=>""
  #  }
  # initialize is generally called using TestFactory Foundry .make or .create methods
  
  def initialize(browser, opts={})
    @browser = browser

    defaults = {
      :student_id=>"student",
      :term_code=>"201201",
      :term_descr=>"Spring 2012",
      :course_code=>"CHEM231",
      :reg_group_code=>"1001",
      :course_options=> (make CourseOptions),
      :course_has_options=> true,
      :modify_course_options=> false,
      :context=> ""
    }
    options = defaults.merge(opts)
    update_options(options)
  end

  def create
    page_class = (@browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH) ? RegistrationCart : CourseSearchPage
    visit page_class do |page|
      if page_class == RegistrationCart
        # wait in case list has not loaded yet
        page.menu_button.wait_until_present
        page.menu
      end
      page.wait_until {page.term_select.include? @term_descr }
      page.select_term @term_descr
      page.menu
      #Need to ensure term has actually changed
      page.wait_until {page.header_term_name.text.include? @term_descr}
      sleep 1
      page.show_add_dialog
      page.course_code_input.wait_until_present
      page.course_code_input.set @course_code
      page.reg_group_code_input.wait_until_present
      page.reg_group_code_input.set @reg_group_code
      page.submit_button.wait_until_present
      page.add_to_cart
      if @course_has_options
        if @modify_course_options
          page.edit_save_button(@course_code,@reg_group_code,CONTEXT_NEW_ITEM).wait_until_present
          edit_course_options :credit_option=>@course_options.credit_option,
                              :grading_option=>@course_options.grading_option,
                              :context => CONTEXT_NEW_ITEM
        else
          page.edit_save_button(@course_code,@reg_group_code,CONTEXT_NEW_ITEM).wait_until_present
          page.save_edits @course_code,@reg_group_code,CONTEXT_NEW_ITEM
        end
      end
    end
  end

  def inspect
    "Registration Request\nID: #{@student_id}, Term: #{@term_descr}, Course: #{@course_code}, Reg group: #{@reg_group_code}, Credits: #{@course_options.credit_option}, Grading: #{@course_options.grading_option}"
  end
  def edit opts={}
    edit_student_id opts
    edit_term_code opts
    edit_term_descr opts
    edit_course_code opts
    edit_reg_group opts
  end

  def edit_student_id opts={}
    if opts[:student_id].nil?
      return nil
    end
    update_options opts
  end
  private :edit_student_id

  def edit_term_code opts={}
    if opts[:term_code].nil?
      return nil
    end
    update_options opts
  end
  private :edit_term_code

  def edit_term_descr opts={}
    if opts[:term_descr].nil?
      return nil
    end
    update_options opts
  end
  private :edit_term_descr

  def edit_course_code opts={}
    if opts[:course_code].nil?
      return nil
    end
    update_options opts
  end
  private :edit_course_code

  def edit_reg_group opts={}
    if opts[:reg_group_code].nil?
      return nil
    end
    update_options opts
  end
  private :edit_reg_group

  def remove_from_cart opts={}
    defaults = {
        :navigate_to_page=>false
    }
    options = defaults.merge(opts)
    visit RegistrationCart if options[:navigate_to_page]
    on RegistrationCart do |page|
      page.course_code(@course_code,@reg_group_code).wait_until_present
      page.show_course_details @course_code,@reg_group_code
      page.remove_course_button(@course_code,@reg_group_code).wait_until_present
      page.remove_course_from_cart @course_code,@reg_group_code
    end
  end

  def remove_from_cart_on_search
    on CourseSearchPage do |page|
      page.course_code(@course_code,@reg_group_code,STATUS_SCHEDULE).wait_until_present
      page.show_course_details @course_code,@reg_group_code,STATUS_SCHEDULE
      page.remove_course_button(@course_code,@reg_group_code).wait_until_present
      page.remove_course_from_cart @course_code,@reg_group_code
    end
  end

  def edit_course_options opts = {}
    defaults = {
    }
    options = defaults.merge(opts)

    return nil if options.empty?

    if options[:context]==CONTEXT_NEW_ITEM || options[:context]==CONTEXT_CART then
      on RegistrationCart do |page|

        if options[:context]==CONTEXT_CART then
          page.course_code(@course_code,@reg_group_code).wait_until_present
          page.show_course_details @course_code, @reg_group_code
          page.edit_course_options_button(@course_code,@reg_group_code).wait_until_present
          page.edit_course_options @course_code, @reg_group_code

          page.firefox_14_workaround @course_code, @reg_group_code

        end

        page.credits_selection_div(@course_code, @reg_group_code, options[:context]).wait_until_present unless options[:credit_option].nil?
        page.select_credits @course_code, @reg_group_code, options[:credit_option], options[:context] unless options[:credit_option].nil?
        page.select_grading @course_code, @reg_group_code, options[:grading_option], options[:context] unless options[:grading_option].nil?
        page.save_edits @course_code, @reg_group_code, options[:context]
      end
    elsif options[:context]==STATUS_SCHEDULE || options[:context]==STATUS_WAITLIST then
      page_class = (@browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH) ? StudentSchedule : CourseSearchPage
      on page_class do |page|
        page.course_code(@course_code,@reg_group_code,options[:context]).wait_until_present
        sleep 1
        page.show_course_details(@course_code,@reg_group_code,options[:context])
        page.edit_course_options_button(@course_code,@reg_group_code,options[:context]).wait_until_present
        page.edit_course_options @course_code,@reg_group_code,options[:context]
        sleep 1
        page.select_credits @course_code,@reg_group_code,options[:credit_option],options[:context] unless options[:credit_option].nil?
        page.select_grading @course_code,@reg_group_code,options[:grading_option],options[:context] unless options[:grading_option].nil?
        page.save_edits @course_code, @reg_group_code, options[:context]
      end
    end

    @course_options.credit_option = options[:credit_option]
    @course_options.grading_option = options[:grading_option]
  end


  def undo_remove_from_cart
    on RegistrationCart do |page|
      page.undo_remove
    end
  end

  def register opts={}
    defaults = {
        :do_navigation=>false
    }
    options = defaults.merge(opts)

    visit RegistrationCart if options[:do_navigation]
    page_class = (@browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH) ? RegistrationCart : CourseSearchPage
    on page_class do |page|
      page.wait_until { page.register_button.enabled? }
      page.register
      page.register_confirm_button.wait_until_present
      page.confirm_registration
    end
  end

  def remove_course(status=STATUS_SCHEDULE,do_navigation=false)
    expected_user_message = case status
                              when STATUS_SCHEDULE then "dropped successfully"
                              when STATUS_WAITLIST then "Removed from waitlist for"
                            end
    visit StudentSchedule if do_navigation
    on StudentSchedule do |page|
      page.course_code(@course_code,@reg_group_code,status).wait_until_present
      page.show_course_details @course_code,@reg_group_code,status
      page.remove_course @course_code,@reg_group_code,status
      # wait for confirmation message
      #page.user_message_div(status).wait_until_present
      #page.user_message_success(@course_code, @reg_group_code).wait_until_present
    end
  end

  def attempt_remove_course(do_navigation=false)
    #try to remove course from schedule, with expectation that action will fail
    status = STATUS_SCHEDULE
    visit CourseSearchPage if do_navigation
    on CourseSearchPage do |page|
      page.course_code(@course_code,@reg_group_code,status).wait_until_present
      page.show_course_details @course_code,@reg_group_code,status
      page.remove_course_from_schedule @course_code,@reg_group_code
    end
  end

  def remove_from_schedule_and_cancel
    on StudentSchedule do |page|
      page.course_code(@course_code,@reg_group_code,STATUS_SCHEDULE).wait_until_present
      page.show_course_details @course_code,@reg_group_code,STATUS_SCHEDULE
      page.cancel_drop_course @course_code,@reg_group_code
    end
  end

  def change_term_and_return(current_term, to_term)
    visit StudentSchedule do |page|
      page.menu_button.wait_until_present
      page.menu
      page.wait_until {page.term_select.include? to_term }
      page.select_term to_term
      page.menu
      sleep 5
      page.menu_button.wait_until_present
      page.menu
      page.wait_until {page.term_select.include? current_term }
      page.select_term current_term
      page.menu
    end
  end

  def add_to_cart_from_search_details
    page_class = (@browser.window.size.width <= CourseSearch::MOBILE_BROWSER_WIDTH) ? CourseDetailsMobilePage : CourseDetailsPage
    on page_class do |page|
      page.add_to_cart
      if @course_has_options
        if @modify_course_options
          page.edit_save_button(@course_code,@reg_group_code,CONTEXT_NEW_ITEM).wait_until_present
          edit_course_options :credit_option=>@course_options.credit_option,
                              :grading_option=>@course_options.grading_option,
                              :context => CONTEXT_NEW_ITEM
        else
          page.edit_save_button(@course_code,@reg_group_code,CONTEXT_NEW_ITEM).wait_until_present
          page.save_edits @course_code,@reg_group_code,CONTEXT_NEW_ITEM
        end
      end
    end
  end

end

class CourseOptions < DataFactory

    include Foundry
    include DateFactory
    include StringFactory
    include Workflows

    attr_accessor :credit_option,     #TODO - change to attr_reader and implement edit method
                  :grading_option

    def initialize(browser, opts={})
      @browser = browser

      defaults = {
          :credit_option => "3.0",
          :grading_option => "Letter"
      }
      options = defaults.merge(opts)
      set_options(options)
    end

  end

class WaitlistEntry < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows

  #string - generally set using options hash
  attr_reader   :student_id,
                :term_code,
                :course_code,
                :reg_group_code
  #number
  attr_reader   :waitlist_position,
                :ao_waitlist_position

  #  defaults = {
  #    :student_id=>"student",
  #    :term_code=>"201208",
  #    :course_code=>"HIST266",
  #    :reg_group_code=>"1001",
  #    :waitlist_position=>0,
  #    :ao_waitlist_position=>0
  #  }

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
       :student_id=>"student",
       :term_code=>"201208",
       :course_code=>"HIST266",
       :reg_group_code=>"1001",
       :waitlist_position=>0,
       :ao_waitlist_position=>0
    }
    options = defaults.merge(opts)
    update_options(options)

  end

  def inspect
    "\nWaitlistEntry -- id: #{@student_id}, \twaitlist position: #{@waitlist_position}, \tAO waitlist position: #{@ao_waitlist_position}\n"
  end

end

class WaitlistRoster < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows

  #string - generally set using options hash
  attr_reader   :term_code,
                :course_code,
                :reg_group_code
  #hash of :student_id=>WaitlistEntry
  attr_reader   :waitlist_entries

  #  defaults = {
  #    :term_code=>"201208"
  #    :course_code=>"HIST266",
  #    :reg_group_code=>"1001",
  #    :waitlist_entries=>{}
  #  }

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :term_code=>"201208",
        :course_code=>"HIST266",
        :reg_group_code=>"1001",
        :waitlist_entries=>{}
    }
    options = defaults.merge(opts)
    update_options(options)
    get_waitlist_entries
  end

  def get_waitlist_entries
    on WaitlistRestCallPage do |page|
      waitlist_roster = page.get_waitlist_roster @term_code,@course_code,@reg_group_code
      waitlist_roster.each do |roster_item|
        waitlist_entry = make WaitlistEntry,
                              :student_id => roster_item["personId"],
                              :term_code => @term_code,
                              :course_code => @course_code,
                              :reg_group_code => @reg_group_code,
                              :waitlist_position => roster_item["position"],
                              :ao_waitlist_position => roster_item["aoWaitlistOrder"][0]["position"]
        @waitlist_entries[waitlist_entry.student_id] = waitlist_entry
      end
    end
  end

  def inspect
    "\nWaitlist Roster -- term: #{@term_code}, course: #{@course_code}, reg group: #{@reg_group_code}\nentries: #{@waitlist_entries}"
  end

end
class RegRestUtility < DataFactory
  def initialize(browser, opts={})
    @browser = browser
  end


  def clear_cart_and_schedule (term_code)
    on RegistrationRestCallPage do |page|
      page.clearSchedule term_code
    end
    on RegistrationCartRestCallPage do |page|
      page.clearCart term_code
    end
  end

end
