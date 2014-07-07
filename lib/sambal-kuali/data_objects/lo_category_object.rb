class CmLoCategoryObject < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows
  include Utilities

  attr_reader :category_name,
              :category_type,
              :category_level,
              :advanced_search,
              :on_the_fly,
              :auto_lookup,
              :defer_save,
              :category_selection



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
        :category_name => "text for dataObject",
        #:category_type => CATEGORY_TYPE_SKILL,
        :category_type => '::random::',
        :category_level => 1,
        :auto_lookup => false,
        :on_the_fly => false,
        :advanced_search => false,
        :defer_save => false

    }
    set_options(defaults.merge(opts))

  end

  # def create
  #     navigate_to_lo_categories
  #     on CmLoCategoryPage do |page|
  #       page.select_category(@category_name)
  #       page.add_categories
  #       page.loading_wait
  #     end
  # end

  def create
    on CmLearningObjectives do |page|
      page.learning_objectives unless page.current_page('Learning Objectives').exists?
      auto_lookup_entry if @auto_lookup
      on_the_fly_entry if @on_the_fly
      advanced_search if @advanced_search
    end
    determine_save_action unless @defer_save
  end


  def select_all_types ()
    on CmLOAdvancedSearchPage do |page|
      page.type_select_all_link.click
      page.loading_wait
    end
  end

  def clear_all_types ()
    on CmLOAdvancedSearchPage do |page|
      page.type_clear_all_link.click
      page.loading_wait
    end
  end

  def auto_lookup_entry
    on CmLearningObjectives do |page|
      page.category_detail(1).set @category_name
      page.auto_lookup @category_name
      page.add_category(1)
    end
  end

  def on_the_fly_entry
    on CmLearningObjectives do |page|
      page.category_detail(1).set @category_name
      page.add_category(1)
      page.category_type(1).wait_until_present
      page.category_type(1).pick(@category_type)
      page.add_category(1)
    end
  end

  def advanced_search
    on CmLearningObjectives do |page|
      page.find_categories(1)
        on CmLOAdvancedSearchPage do |advance_search|
          advance_search.category_filter_input.set @category_name
          sleep 2 #to make sure that selection doesn't happen too quick
          advance_search.select_multiple_categories(@category_selection.to_i)
          advance_search.add_categories
        end
      page.learning_objectives unless page.current_page('Learning Objectives').exists?
    end
  end



end


