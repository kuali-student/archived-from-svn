class CmCourseObject < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows
  include Utilities

  attr_accessor :course_code,
                :search_term




  def initialize(browser, opts={})
    @browser = browser
    defaults = {

    }
    set_options(defaults.merge(opts))

  end


  def search_for_course
    navigate_rice_to_cm_home
    navigate_to_find_course
    on CmFindACoursePage do |search|
      search.course_code.set search_term
      search.find_courses
    end
  end

end


