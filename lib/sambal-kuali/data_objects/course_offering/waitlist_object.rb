# stores test data for creating/editing and validating waitlist data and provides convenience methods for navigation and data entry
#
# Waitlist is contained in ActivityOffering
#
# class attributes are initialized with default data unless values are explicitly provided
#
# Typical usage: (with optional setting of explicit data value in [] )
#
# waitlist = make Waitlist, :=> "user1", :affiliation =>"Instructor"
#
#create generally called from ActivityOffering/CourseOffering class
# Note the use of the ruby options hash pattern re: setting attribute values
class Waitlist < DataFactory
  include Foundry
  include DateFactory
  include StringFactory
  include Workflows

  #generally set using options hash
  attr_accessor :enabled,
                :type, #Confirmation, Automatic, Manual
                :limit_size, #0 means not enabled
                :allow_hold_list,
                :parent_ao

  # provides default data:
  # defaults = {
  #    :enabled => false, #must be enabled for parent_course_offering
  #    :type => "Automatic",
  #    :limit_size => 0
  #    :allow_hold_list => false
  # }
  # initialize is generally called using TestFactory Foundry .make or .create methods
  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :enabled => nil,  #true/false/nil (nil means use default config)
        :type => "Confirmation",  #Automatic, Confirmation, Manual
        :limit_size => 0,
        :allow_hold_list => true
    }

    set_options(defaults.merge(opts))
  end

  # edits waitlist options based on instance vars
  #
  #  @param opts [Hash] key => value for attribute to be updated
  def edit opts={}
    defaults = {
        :defer_save => false,
        :start_edit => true
    }
    options = defaults.merge(opts)

    on(ManageCourseOfferings).edit @parent_ao.code if options[:start_edit]

    if !opts[:enabled].nil?
      on ActivityOfferingMaintenance do |page|
        options[:enabled] ? page.waitlist_checkbox.set : page.waitlist_checkbox.clear
        page.loading.wait_while_present
        @enabled = options[:enabled]
      end
    end

    #return unless @enabled

    if !options[:type].nil?
      on ActivityOfferingMaintenance do |page|
        case options[:type]
          when "Automatic"
            page.waitlist_automatic_radio.set
          when "Confirmation"
            page.waitlist_confirmation_radio.set
          when "Manual"
            page.waitlist_manual_radio.set
          else
            raise "error: '#{options[:type]}' waitlist type not found"
        end
      end
    end

    if !options[:limit_size].nil?
      on ActivityOfferingMaintenance do |page|
        if options[:limit_size] > 0
          page.waitlist_limit_checkbox.set
          page.loading.wait_while_present
          page.waitlist_limit.set options[:limit_size]
        else
          page.waitlist_limit_checkbox.clear
        end
      end
    end

    if !options[:allow_hold_list].nil?
      on ActivityOfferingMaintenance do |page|
        options[:allow_hold_list] ? page.waitlist_allow_hold_checkbox.set : page.waitlist_allow_hold_checkbox.clear
      end
    end

    set_options(options)
    @parent_ao.save unless options[:defer_save]
  end

  def waitlist_limit_str
    if @limit_size == 0
      return "Unlimited"
    else
      return "Limit to #{@limit_size}"
    end
  end
end