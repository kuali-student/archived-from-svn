class ARCourseSectionObject < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :parent, :course_code, :section, :credits, :description,
                :requested_credits, :requested_reg_options, :requested_effective_date

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :parent => nil,
        :navigate_to_page => false,
        :course_code => "ENGL304",
        :section => "1001",
        :credits => nil,
        :description => nil,
        :add_new_line => false,
        :register => false,
        :confirm_registration => false,
        :requested_credits => nil,
        :requested_reg_options => nil,
        :requested_effective_date => nil
    }
    options = defaults.merge(opts)

    set_options(options)
  end

  def create
    @parent.search if @navigate_to_page

    on AdminRegistration do |page|
      if @parent.term_code != nil
        page.course_addline if @add_new_line

        page.course_code_input.when_present.set @course_code
        page.section_code_input.when_present.set @section

        if @register
          page.wait_until { page.course_register_btn.visible? }
          page.course_register

          confirm_registration if @confirm_registration
        end
      end
    end
  end

  def delete opts
    @parent.search if opts[:navigate_to_page]

    on AdminRegistration do |page|
      page.course_delete opts[:index]
      page.deleting.wait_while_present
    end

    @parent.course_section_codes.delete self
  end

  def confirm_registration opts = {}
    defaults = {
        :confirm_registration => true,
        :dismiss_result => true
    }
    options = defaults.merge(opts)

    set_options(options)

    on AdminRegistration do |page|
      page.loading.wait_while_present
      if options[:confirm_course_credits] != nil and page.set_confirm_course_credits(@course_code, @section).exists?
        page.set_confirm_course_credits(@course_code, @section).select options[:confirm_course_credits]
        @requested_credits = options[:confirm_course_credits]
      end

      if options[:confirm_course_reg_options] != nil and page.set_confirm_course_reg_options(@course_code, @section).exists?
        page.set_confirm_course_reg_options(@course_code, @section).select options[:confirm_course_reg_options]
        @requested_reg_options = options[:confirm_course_reg_options]
      end

      if options[:confirm_course_effective_date] != nil
        page.set_confirm_course_effective_date(@course_code, @section).set options[:confirm_course_effective_date]
        @requested_effective_date = options[:confirm_course_effective_date]
      end

      if options[:confirm_registration]
        page.confirm_registration
      else
        page.cancel_registration
      end
      page.loading.wait_while_present

      page.wait_until(60) { page.course_register_btn.visible? }
      page.loading.wait_while_present

      if page.growl_div.exists? and options[:dismiss_result]
        page.growl_div.div(class: "jGrowl-close").click
      end
    end
  end

  def edit_course opts = {}
    defaults = {
      :navigate_to_page => false,
      :save_edit => true,
      :cancel_edit => true
    }
    options = defaults.merge(opts)

    set_options(options)

    @parent.create if options[:navigate_to_page]

    on AdminRegistration do |page|
      page.edit_registered_course @course_code, @section
      page.loading.wait_while_present(60)

      if options[:edit_course_credits] != nil and page.set_edit_course_credits.exists?
        page.set_edit_course_credits.select options[:edit_course_credits]
        @requested_credits = options[:edit_course_credits]
      end

      if options[:edit_course_reg_options] != nil and page.set_edit_course_reg_options.exists?
        page.set_edit_course_reg_options.select options[:edit_course_reg_options]
        @requested_reg_options = options[:edit_course_reg_options]
      end

      if options[:edit_course_effective_date] != nil
        page.set_edit_course_effective_date.set options[:edit_course_effective_date]
        @requested_effective_date = options[:edit_course_effective_date]
      end

      if options[:save_edit]
        page.save_edited_course
      elsif !options[:save_edit] and options[:cancel_edit]
        page.cancel_edited_course
      end
      page.loading.wait_while_present
    end
  end

  def delete_course opts = {}
    defaults = {
        :navigate_to_page => false,
        :confirm_drop => false
    }
    options = defaults.merge(opts)

    set_options(options)

    @parent.create if options[:navigate_to_page]

    on AdminRegistration do |page|
      page.delete_registered_course @course_code, @section
      page.loading.wait_while_present

      if options[:drop_course_effective_date] != nil
        page.drop_registered_effective_date.set options[:drop_course_effective_date]
        @requested_effective_date = options[:drop_course_effective_date]
      end

      if options[:confirm_drop]
        page.confirm_course_drop
      else
        page.cancel_course_drop
      end
      page.loading.wait_while_present
    end
  end

end

class ARCourseSectionCollection < CollectionsFactory

  contains ARCourseSectionObject

end