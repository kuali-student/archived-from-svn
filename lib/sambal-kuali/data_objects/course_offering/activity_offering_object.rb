# stores test data for creating/editing and validating activity offerings and provides convenience methods for navigation and data entry
#
# ActivityOffering objects contain the following objects: SeatPool, DeliveryLogistic (requested and actual) and PersonnelObject (Affiliated PersonnelObjectObject)
#
# ActivityOffering is a child of a CourseOffering
#
# class attributes are initialized with default data unless values are explicitly provided
#
# Typical usage: (with optional setting of explicit data value in [] )
#  @activity_offering = make ActivityOfferingObject, [:seat_pool_list => {},...]
#  @activity_offering.create
# OR alternatively 2 steps together as
#  @activity_offering = create ActivityOfferingObject, [:seat_pool_list => {},...]
# Note the use of the ruby options hash pattern re: setting attribute values
class ActivityOfferingObject < DataFactory
  include Foundry
  include DateFactory
  include StringFactory
  include Workflows
  include Comparable

  #type: string generally set using options hash
  attr_accessor :code,
                :status,
                :format,
                :activity_type,
                :max_enrollment,
                :seat_remaining_percent,
                :course_url,
                :subterm
  #type: collection
  attr_accessor :actual_scheduling_information_list,
                :requested_scheduling_information_list,
                :seat_pool_list,
                :admin_comments_list
  #array - generally set using options hash
  attr_accessor :personnel_list,
                :colocate_ao_list
  #boolean - generally set using options hash
  attr_accessor :requires_evaluation,
                :honors_course,
                :colocated,
                :colocate_shared_enrollment,
                :allow_non_std_timeslots
  #type ActivityOfferingClusterObject - generally set using options hash
  attr_accessor :parent_cluster
  #type Waitlist object - generally set using options hash
  attr_accessor :waitlist_config

  # [String]
  OFFERED_STATUS = "Offered"
  # [String]
  DRAFT_STATUS = "Draft"
  # [String]
  APPROVED_STATUS = "Approved"
  # [String]
  CANCELED_STATUS = "Canceled"

  # initialize is generally called using TestFactory Foundry .make or .create methods
  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :status => DRAFT_STATUS,
        :format => nil, #nil means use default
        :activity_type => "Lecture",
        :max_enrollment => 0,
        :actual_scheduling_information_list => collection('SchedulingInformation'),
        :requested_scheduling_information_list => collection('SchedulingInformation'),
        :allow_non_std_timeslots => false,
        :personnel_list => collection('Personnel'),
        :seat_pool_list => collection('SeatPool'),
        :course_url => "",
        :requires_evaluation => false,
        :honors_course => false,
        :colocated => false,
        :colocate_ao_list => [],
        :colocate_shared_enrollment => false,
        :subterm => nil,
        :waitlist_config => (make Waitlist, :parent_ao => self),
        :admin_comments_list => collection('AdminComment')
    }

    options = defaults.merge(opts)
    set_options(options)

    @seat_pool_list.each do |sp|
      sp.parent_ao = self
    end
    @personnel_list.each do |person|
      person.parent_obj = self
    end
  end

  def <=>(other)
    @code <=> other.code
  end

  #create one or many simple aos without details
  #
  #   @example
  #   @activity_offering.create_simple :number_aos_to_create => 3 (defaults is 1)
  #
  #
  #   @param opts [Hash] :number_aos_to_create => integer (1 or more)
  #   @returns list of AO codes created
  def create_simple  opts={}

    defaults = {
        :number_aos_to_create => 1,
        :navigate_to_page => true
    }
    options = defaults.merge(opts)

    manage_parent_co if options[:navigate_to_page]

    on ManageCourseOfferings do |page|
      begin
        pre_add_ao_list = page.codes_list
      rescue
        pre_add_ao_list = nil
      end

      post_add_ao_list = []
      #if page.codes_list.length == 0
      sleep 2
      page.add_activity
      page.format.select @format unless @format.nil?
      page.loading.wait_while_present
      sleep 2
      page.activity_type.select @activity_type #unless @activity_type.nil?
      page.cluster.select @parent_cluster.private_name unless @parent_cluster.private_name == :default_cluster
      page.quantity.set options[:number_aos_to_create]
      page.complete_add_activity
      post_add_ao_list = page.codes_list
      #end
      if(pre_add_ao_list != nil )
        new_code_list =  post_add_ao_list - pre_add_ao_list
      else
        new_code_list =  post_add_ao_list
      end

      new_ao_list = []
      new_code_list.each do |code|
        new_ao_list << (make ActivityOfferingObject,
                             :code=>code,
                             :format=>@format,
                             :activity_type=>@activity_type,
                             :parent_cluster=> @parent_cluster)
      end
      return new_ao_list
    end
  end

  #navigates to activity offering edit page and sets up activity offering based on class attributes
  def create
    on ManageCourseOfferings do |page|
      pre_add_ao_list = page.codes_list
      post_add_ao_list = []
      #if page.codes_list.length == 0
      #sleep 2
      page.add_activity
      #ordering of compound format type (eg Lecture/Discussion) is flexible
      #if the selectlist doesn't include the option, then try reordering
      if @format.nil? #nil format means use default format
        @format = page.format.selected_options[0].text
        @activity_type =  page.activity_type.selected_options[0].text
      else
        if !@format.index('/').nil?
          if !page.format.include?(@format)
            formats = @format.split('/')
            @format = "#{formats[1]}/#{formats[0]}"
          end
        end
        page.format.select @format
        page.loading.wait_while_present
      end
      page.activity_type.wait_until_present
      page.activity_type.select @activity_type unless @format.nil?
      page.quantity.set "1"
      page.complete_add_activity
      sleep 1
      post_add_ao_list = page.codes_list
      #end
      new_code =  post_add_ao_list - pre_add_ao_list
      @code = new_code[0]
    end
  end

  def get_actual_values_from_page
    ao_table_row = on(ManageCourseOfferings).target_row(@code)
    initialize_with_actual_values(ao_table_row, @parent_cluster)
  end

  def initialize_with_actual_values(ao_table_row, parent_cluster)
    @code =  ao_table_row.cells[ManageCourseOfferings::AO_CODE].text
    @status = ao_table_row.cells[ManageCourseOfferings::AO_STATUS].text
    @activity_type = ao_table_row.cells[ManageCourseOfferings::AO_TYPE].text
    @max_enrollment = ao_table_row.cells[ManageCourseOfferings::AO_MAX_ENR].text
    delivery_days = ao_table_row.cells[ManageCourseOfferings::AO_DAYS].text
    if delivery_days != "" then
      #there are scheduling information
      si_list = get_existing_scheduling_information (ao_table_row)
      si_list.each do |si_object|
        si_object.parent_ao = self
        if si_object.isRSI then
          @requested_scheduling_information_list << si_object
        else
          @actual_scheduling_information_list << si_object
        end
      end
    end
    @parent_cluster = parent_cluster
  end

  def get_existing_scheduling_information(ao_table_row)
    si_list = []
    is_rsi = ao_table_row.cells[ManageCourseOfferings::AO_DAYS].span(index: 0).present? and ao_table_row.cells[ManageCourseOfferings::AO_DAYS].span(index: 0).attribute_value("class") == "uif-scheduled-dl"
    si_days = ao_table_row.cells[ManageCourseOfferings::AO_DAYS].text.split("\n")
    st_times = ao_table_row.cells[ManageCourseOfferings::AO_ST_TIME].text.split("\n")
    end_times = ao_table_row.cells[ManageCourseOfferings::AO_END_TIME].text.split("\n")
    fac_names_text = ao_table_row.cells[ManageCourseOfferings::AO_BLDG].text
    fac_long_names = []
    fac_names = []
    if fac_names_text != ''
      fac_names = fac_names_text.split("\n")
      #get facility long name from tool tip
      div_id = ao_table_row.cells[ManageCourseOfferings::AO_BLDG].div.id
      ao_table_row.cells[ManageCourseOfferings::AO_BLDG].div.fire_event 'mouseover'
      popup_text = on(ManageCourseOfferings).div(id: /jquerybubblepopup/, data_for: "#{div_id}").table.text
      if !popup_text.nil? && popup_text != ''
        fac_long_names = popup_text.split("\n")
      end
    end
    rooms = ao_table_row.cells[ManageCourseOfferings::AO_ROOM].text.split("\n")

    i=0
    si_days.each do |day|
      st, st_ampm = st_times[i].split unless st_times[i].nil?
      et, et_ampm = end_times[i].split unless end_times[i].nil?
      fac_name = fac_names[i].nil? ? '' : fac_names[i]
      fac_long_name = fac_long_names[i].nil? ? ''  :fac_long_names[i]
      room = rooms[i].nil? ? '' : rooms[i]
      si = make SchedulingInformationObject,
                :isRSI => is_rsi,
                :days => si_days[i],
                :start_time => st,
                :start_time_ampm => st_ampm,
                :end_time => et,
                :end_time_ampm => et_ampm,
                :facility => fac_name,
                :facility_long_name => fac_long_name ,
                :room => room
      si_list << si
      i += 1
    end

    si_list
  end

  def manage_parent_co
    parent_course_offering.manage
  end

  def parent_course_offering
    @parent_cluster.parent_course_offering
  end

  #navigates activity offering edit page and updates activity offering based on class attributes
  # @example - must always call save
  #  @activity_offering.edit :honors_course=> true
  #  @activity_offering.save
  #
  # NB: 'save' is a separate step from edit as it allows validation steps to occur during the edit process
  #
  # @param opts [Hash] key => value for attribute to be updated -
  #   additional opts :edit_already_started (bool), :send_to_scheduler (bool), :defer_save (bool)
  def edit opts={}

    defaults = {
        :defer_save => false,
        :start_edit => true,
        :send_to_scheduler => false
    }
    options = defaults.merge(opts)

    on(ManageCourseOfferings).edit @code if options[:start_edit]

    edit_code options
    edit_subterm options
    edit_colocation options
    edit_max_enrollment_no_colocation options
    edit_non_std_timeslots options
    edit_course_url options
    edit_evaluation options
    edit_honors_course options

    on(ActivityOfferingMaintenance).send_to_scheduler if options[:send_to_scheduler]
    self.save unless options[:defer_save]

  end #END: edit

  # PRIVATE helper methods for edit()

  def edit_code opts
    if opts[:code].nil?
      return nil
    end
    on(ActivityOfferingMaintenance).activity_code.set opts[:code]
    @code = opts[:code]
  end #END: edit_code

  def edit_subterm opts

    if opts[:subterm] != nil
      sleep 1
      on ActivityOfferingMaintenance do |page|
        page.change_subterm opts[:subterm]
        @subterm = opts[:subterm]
      end
    end
  end

  def edit_colocation opts={}
    if on(ActivityOfferingMaintenance).colocated_checkbox.exists?
      is_colo_set = on(ActivityOfferingMaintenance).colocated_checkbox.set?


      if !opts[:colocated].nil?
        if opts[:colocated] == false
          edit_break_colocation if is_colo_set
          return
        else
          on(ActivityOfferingMaintenance).select_colocated_checkbox unless is_colo_set
          @colocated = true
          is_colo_set = true
        end
      end
      return unless is_colo_set

      # else perform normal colo-EDIT
      on ActivityOfferingMaintenance do |page|
        # add the colo-COs to this CO
        if !opts[:colocate_ao_list].nil?
          opts[:colocate_ao_list].each do |ao_to_colo|
            page.colocated_co_input_field.value = ao_to_colo.parent_cluster.parent_course_offering.course
            page.colocated_ao_input_field.value = ao_to_colo.code
            page.add_colocated
#            page.add_colocate_ao_confirmation_add
            @colocate_ao_list << ao_to_colo
          end
        end

        if !opts[:colocate_shared_enrollment].nil?
          if opts[:colocate_shared_enrollment]
            page.select_separately_manage_enrollment_radio #toggling to this and back is required or an error generates on submit
            page.select_jointly_share_enrollment_radio
            page.colocated_shared_max_enrollment_input_field.set opts[:max_enrollment]
            @max_enrollment = opts[:max_enrollment]
          else # ie: 'separately manage'
            page.select_separately_manage_enrollment_radio
            page.edit_separate_max_enr(@parent_cluster.parent_course_offering.course, @code, opts[:max_enrollment])
            @max_enrollment = opts[:max_enrollment]
          end
        end

      end
    end

  end #END: edit_colocation
  private :edit_colocation

  def edit_break_colocation
    on ActivityOfferingMaintenance do |page|
      page.select_colocated_checkbox if page.colocated_checkbox.set?
      page.break_colocation
    end

    @colocated = false
  end #END: edit_break_colocation
  private :edit_break_colocation

  def edit_max_enrollment_no_colocation opts={}
    if on(ActivityOfferingMaintenance).colocated_checkbox.exists?
      return if on(ActivityOfferingMaintenance).colocated_checkbox.set?
    end

    if opts[:max_enrollment] != nil
      on ActivityOfferingMaintenance do |page|
        page.total_maximum_enrollment.set opts[:max_enrollment]
        page.total_maximum_enrollment.fire_event "onchange"
        @max_enrollment = opts[:max_enrollment]
      end
    end
  end #END: edit_max_enrollment_no_colocation
  private :edit_max_enrollment_no_colocation

  def edit_non_std_timeslots opts={}
    if opts[:allow_non_std_timeslots].nil?
      return nil
    end
    on ActivityOfferingMaintenance do |page|
      page.view_requested_scheduling_information
      if opts[:allow_non_std_timeslots]
        page.approve_non_std_ts
      else
        page.disallow_non_std_ts
      end
    end
  end
  private :edit_non_std_timeslots

  def edit_course_url opts={}

    if opts[:course_url].nil?
      return nil
    end

    on(ActivityOfferingMaintenance).course_url.set opts[:course_url]
    @course_url = opts[:course_url]

  end #END: edit_course_url
  private :edit_course_url

  def edit_evaluation opts={}

    if opts[:requires_evaluation].nil?
      return nil
    end

    on ActivityOfferingMaintenance do |page|
      if opts[:requires_evaluation]
        page.requires_evaluation.set
      else
        page.requires_evaluation.clear
      end
    end

    @requires_evaluation =  opts[:requires_evaluation]

  end #END: edit_evaluation
  private :edit_evaluation

  def edit_honors_course opts={}

    if opts[:honors_course].nil?
      return nil
    end

    on ActivityOfferingMaintenance do |page|
      if opts[:honors_course]
        page.honors_flag.set
      else
        page.honors_flag.clear
      end
    end

    @honors_course = opts[:honors_course]

  end #END: edit_honors_course
  private :edit_honors_course

  def delete opts={}
    defaults = {
        :navigate_to_page => true,
        :confirm_delete => true
    }
    options = defaults.merge(opts)

    manage_parent_co if options[:navigate_to_page]

    on ManageCourseOfferings do |page|
      page.select_aos([@code], @parent_cluster.private_name)
      page.delete_aos
    end

    on ActivityOfferingConfirmDelete do |page|
      confirmation_message = page.delete_confirm_message
      if options[:confirm_delete]
        page.delete_activity_offering
        @parent_cluster.ao_list.delete(self)
      else
        page.cancel
      end
    end
  end

  def add_req_sched_info opts={}

    defaults = {
        :defer_save => false,
        :start_edit => true
    }
    options = defaults.merge(opts)
    edit :defer_save => true if options[:start_edit]

    rsi_obj = options[:rsi_obj]
    rsi_obj.parent_ao = self
    rsi_obj.create
    @requested_scheduling_information_list << rsi_obj
    save unless options[:defer_save]
  end

  def add_admin_comment opts={}
    defaults = {
        :defer_save => false,
        :do_navigation => true
    }
    options = defaults.merge(opts)

    if options[:do_navigation]
      manage_comments
    end

    options[:comment_obj].create
    options[:comment_obj].parent_obj = self
    @admin_comments_list << options[:comment_obj]
  end


  def manage_comments
    parent_course_offering.manage
    on(ManageCourseOfferings).ao_comments @code, @parent_cluster.private_name
  end

  def add_personnel person
    #edit
    person.parent_obj = self
    person.create
    @personnel_list << person
  end

  def delete_personnel person
    on ActivityOfferingMaintenance do |page|
      #page.update_person_name(person.id,'blah, blah')
      page.delete_personnel(person.id)
    end
  end

  def add_seat_pool opts={}

    defaults = {
        :defer_save => false,
        :start_edit => true
    }
    options = defaults.merge(opts)

    edit :defer_save => true if options[:start_edit]

    options[:seat_pool_obj].parent_ao = self
    options[:seat_pool_obj].create seatpool_populations_used
    on(ActivityOfferingMaintenance).save unless options[:defer_save]
    @seat_pool_list << options[:seat_pool_obj] if options[:seat_pool_obj].exp_add_succeed
  end

  def add_seat_pool_list opts={}

    defaults = {
        :defer_save => false,
        :start_edit => true
    }
    options = defaults.merge(opts)

    edit if options[:start_edit]

    options[:seat_pool_list].each do |seatpool|
      add_seat_pool :seat_pool_obj => seatpool, :defer_save => true, :start_edit => false
    end

    on(ActivityOfferingMaintenance).save unless options[:defer_save]

  end

  #completes activity offering edit operation
  #this is a separate step from edit as it allows validation steps to occur during the edit process
  def save
    on ActivityOfferingMaintenance do |page|
      page.submit
    end
  end

  def save_and_remain_on_page()
    on ActivityOfferingMaintenance do |page|
      page.save
    end
  end

  #calculates the expected number of seats remaining
  #
  #@return [int] expected number of seats remaining
  def expected_seats_remaining
    seats_used = 0
    @seat_pool_list.each do |seat_pool|
      seats_used += seat_pool.seats.to_i
    end
    [@max_enrollment - seats_used , 0].max
  end

  #removes seatpool from activity offering
  #
  #@param [string] seat_pool_list hash key
  def remove_seatpool(seatpool_obj)
    on ActivityOfferingMaintenance do |page|
      page.remove_seatpool(seatpool_obj.population_name)
    end
    @seat_pool_list.delete(seatpool_obj)
  end

  # updates the value in @seatpool.priority with @seatpool.priority_after_reseq for each seatpool
  #
  # e.g. after removing the seatpool with priory 1, the seatpool with priority 2 becomes priority 1
  def resequence_expected_seatpool_priorities()
    @seat_pool_list.each do |seatpool|
      seatpool.priority = seatpool.priority_after_reseq unless seatpool.priority_after_reseq == ""
    end
  end

  #returns a list of populations used in the AO seatpool
  #
  # @returns [Array] list of population names
  def seatpool_populations_used
    populations_used = []
    @seat_pool_list.each do |seatpool|
      populations_used << seatpool.population_name
    end
    populations_used
  end

  # suspends the activity offering
  def suspend opts={}
    defaults = {
        :navigate_to_page => true
    }
    options = defaults.merge(opts)

    manage_parent_co if options[:navigate_to_page]

    on ManageCourseOfferings do |page|
      page.select_ao(self.code)
      page.suspend_ao
      on(SuspendActivityOffering).suspend_activity
    end
  end

  # cancels the activity offering
  def cancel opts={}

    defaults = {
        :navigate_to_page => true
    }
    options = defaults.merge(opts)

    manage_parent_co if options[:navigate_to_page]

    on ManageCourseOfferings do |page|
      page.select_ao(self.code)
      page.cancel_ao
      on(CancelActivityOffering).cancel_activity
    end
  end

  # cancels the activity offering
  def reinstate opts={}

    defaults = {
        :navigate_to_page => true
    }
    options = defaults.merge(opts)

    manage_parent_co if options[:navigate_to_page]

    on ManageCourseOfferings do |page|
      page.select_ao(self.code)
      page.reinstate_ao
    end
    on(ReinstateActivityOffering).reinstate_activity
  end


  # approves the activity offering
  def approve opts={}

    defaults = {
        :navigate_to_page => true,
        :send_to_scheduler => false
    }
    options = defaults.merge(opts)

    manage_parent_co if options[:navigate_to_page]

    on ManageCourseOfferings do |page|
      page.select_ao(self.code)
      if page.approve_activity_button.enabled?
        page.approve_activity
        if options[:send_to_scheduler]
          page.deselect_ao(self.code)
          edit :send_to_scheduler => true
        end
      else
        raise "error: approve_activity_button is disabled"
      end
    end
  end

  # offers the activity offering (in published SOC, at least)
  def offer
    manage_parent_co
    on(ManageCourseOfferings).edit(self.code)
    on ActivityOfferingMaintenance do |page|
      page.send_revised_scheduling_information
      page.submit
    end
  end


end

class ActivityOfferingCollection < CollectionsFactory

  contains ActivityOfferingObject

  def by_code(ao_code)
    self.find {|ao| ao.code == ao_code }
  end
end
