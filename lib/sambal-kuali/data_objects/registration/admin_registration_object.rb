class AdminRegistrationData < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :student_id, :term_code, :course_section_codes,
                :term_description
  # , :confirm_term_selection

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :student_id => "ks-2094",
        :term_code => nil,
        :term_description => nil,
        :course_section_codes => collection('ARCourseSection')
    }

    options = defaults.merge(opts)

    set_options(options)
  end

  def search
    go_to_admin_registration
  end

  def create
    search

    on AdminRegistration do |page|
      page.student_info_input.set @student_id
      page.student_info_go

      if @term_code != nil
        page.change_term_input.set @term_code
        page.change_term_go
      end
    end
  end

  def add_course_section opts
    opts[:course_section_obj].parent = self
    opts[:course_section_obj].create
    @course_section_codes << opts[:course_section_obj]
  end

end