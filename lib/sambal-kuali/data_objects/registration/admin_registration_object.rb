class AdminRegistrationData < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :student_id, :term_code, :term_description, :course_section_codes

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :student_id => "ks-2094",
        :term_code => "201401",
        :term_description => "Spring 2014",
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
      page.student_id_input.set @student_id
      page.term_code_input.set @term_code
      page.student_term_go
    end
  end

  def add_course_section opts
    opts[:course_section_obj].parent = self
    opts[:course_section_obj].create
    @course_section_codes << opts[:course_section_obj]
  end

end