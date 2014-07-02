class CmLoCategoryObject < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows
  include Utilities

  attr_reader :category,
              :type


  CATEGORY_TO_TEACH_ENGLISH = "Certificate to Teach English"
  CATEGORY_COMMUNICATION = "Communication"
  CATEGORY_WRITING = "Writing"
  CATEGORY_SCIENTIFIC_METHOD = "Scientific method"
  CATEGORY_MATHEMATICAL_REASONING = "Mathematical reasoning"
  CATEGORY_SCIENTIFIC_REASONING = "Scientific reasoning"

  CATEGORY_TYPE_SKILL = "Skill"
  CATEGORY_TYPE_SUBJECT = "Subject"
  CATEGORY_TYPE_ACCREDITATION = "Accreditation"

=begin
  Because the app validates the categories we need to use the predefined categories and types
=end
  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        :category_name => CATEGORY_MATHEMATICAL_REASONING,
        :category_type => CATEGORY_TYPE_SKILL
    }
    set_options(defaults.merge(opts))

  end

  def create
      navigate_to_lo_categories
      on CmLoCategoryPage do |page|
        page.select_category(@category_name)
        page.add_categories
        page.loading_wait
      end
  end


  def select_all_types ()
    on CmLoCategoryPage do |page|
      page.type_select_all_link.click
      page.loading_wait
    end
  end

  def clear_all_types ()
    on CmLoCategoryPage do |page|
      page.type_clear_all_link.click
      page.loading_wait
    end
  end


end


