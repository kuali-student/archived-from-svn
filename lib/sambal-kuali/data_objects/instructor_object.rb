class CmInstructorObject < CmBaseObject

  attr_reader :instructor_name,
              :instructor_level,
              :defer_save,
              :defer_set




  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        instructor_name: "TYSON",
        instructor_level: 1,
        defer_save: false,
        defer_set: false
    }
    set_options(defaults.merge(opts))

  end

  def create
    on CmCourseInformationPage do |page|
      page.course_information unless page.current_page('Course Information').exists?
      page.add_instructor unless page.instructor_name(@instructor_level).exists?
      if @defer_set
        instructor_select
      else
       auto_lookup_select
      end
    end
  end





  def edit (opts={})
    on CmCourseInformationPage do |page|
      page.course_information unless page.current_page('Course Information').exists?
      page.add_instructor unless page.instructor_name(opts[:instructor_level]).exists?
      page.instructor_name(opts[:instructor_level]).fit opts[:instructor_name]
      page.auto_lookup opts[:instructor_name] unless opts[:instructor_name].nil?
    end
    determine_save_action unless opts[:defer_save]
    set_options(opts)
  end



  def delete (opts={})
    on CmCourseInformationPage do |page|
      page.delete_instructor(opts[:instructor_level])
    end
    determine_save_action unless opts[:defer_save]
  end


  def auto_lookup_select
    on CmCourseInformationPage do |page|
      boundary = 3 # to trigger auto suggest query
      head = @instructor_name.slice(0, boundary)
      page.instructor_name(@instructor_level).set head
      page.instructor_name(@instructor_level).click
      page.auto_lookup @instructor_name
    end
  end


  def instructor_select
    on CmCourseInformationPage do |page|

      for letter in 0..((@instructor_name.length)-1) do
        page.instructor_name(@instructor_level).send_keys @instructor_name[letter]
        sleep 1
      end
      page.auto_lookup @instructor_name

    end

  end

end


