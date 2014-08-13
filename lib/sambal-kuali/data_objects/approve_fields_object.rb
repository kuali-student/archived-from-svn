class CmApproveFieldsObject < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows
  include Utilities

  attr_accessor :transcript_course_title,
                :course_number,
                :campus_location,
                :location_north,
                :location_south,
                :location_extended,
                :location_all,
                :format_list,
                :defer_save


  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        transcript_course_title:    random_alphanums(5,'test transcript'),
        course_number:              "#{(100..899).to_a.sample}",
        #GOVERNANCE
        campus_location: [:location_all, :location_extended, :location_north, :location_south],
        #COURSE LOGISTICS
        format_list: [(make CmFormatsObject)],
        defer_save: false
    }
    set_options(defaults.merge(opts))
    random_campus(@campus_location)
  end

  def create
    on CmCourseInformation do |page|
      page.course_information unless page.current_page('Course Information').exists?
      fill_out page, :transcript_course_title, :course_number
      determine_save_action unless @defer_save
    end

    on CmGovernance do |page|
      page.governance unless page.current_page('Governance').exists?
      fill_out page, :location_all, :location_extended, :location_north, :location_south
      determine_save_action unless @defer_save
    end

    on CmCourseLogistics do |page|
      page.course_logistics unless page.current_page('Course Logistics').exists?

      if @format_list != nil
        @format_list.each do |format|
          format.create
        end
      end

      determine_save_action unless @defer_save
    end
  end






  def edit (opts={})
    determine_edit_action

    on CmCourseInformation do |page|
      page.course_information unless page.current_page('Course Information').exists?
      page.transcript_course_title.fit opts[:transcript_course_title]
      page.course_number.fit opts[:course_number]
    end

    on CmGovernance do |page|
      page.governance unless page.current_page('Governance').exists?
      if opts[:campus_location] != nil
        reset_campus(@campus_location) unless opts[:campus_location].nil?
        fill_out page, :location_all, :location_extended, :location_north, :location_south unless opts[:campus_location].nil?
      end
    end
    determine_save_action unless opts[:defer_save]

    set_options(opts)
  end

  def add_campus
    on CmGovernance do |page|
      page.governance unless page.current_page('Governance').exists?
      page.location_all.set
    end
    determine_save_action
  end


  def random_campus(pass_in_an_array)
    @sample_campus = pass_in_an_array.sample unless pass_in_an_array.nil?
    set(@sample_campus, :set)  unless pass_in_an_array.nil?
  end

  def reset_campus(pass_in_an_array)
    set(@sample_campus, :clear) unless pass_in_an_array.nil?
    pass_in_an_array.delete(@sample_campus)
    @new_sample_campus = pass_in_an_array.sample
    set(@new_sample_campus, :set) unless pass_in_an_array.nil?
  end

  def add_format (opts)
    defaults = {
        format_level: 1,
        activity_level: 1,
        type: '::random::',
        contacted_hours: (1..9).to_a.sample,
        contact_frequency: '::random::',
        duration_count: (1..9).to_a.sample,
        duration_type: '::random::',
        class_size: (1..9).to_a.sample,
        defer_save: false
    }
    options = defaults.merge(opts)
    options[:format].create
    @format_list << options[:format]
    determine_save_action
  end

end
