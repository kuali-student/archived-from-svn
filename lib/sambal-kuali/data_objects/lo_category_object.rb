class CmLoCategoryObject < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows
  include Utilities

  attr_accessor :category_name,
                :category_type,
                :lo_level,
                :category_level,
                :advanced_search,
                :on_the_fly,
                :auto_lookup,
                :defer_save,
                :category_selection

  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        :category_name => random_alphanums(10, 'text for category '),
        :category_type => '::random::',
        :category_level => 1,
        :lo_level => 1,
        :auto_lookup => false,
        :on_the_fly => false,
        :advanced_search => false,
        :defer_save => false

    }
    set_options(defaults.merge(opts))

  end

  def create
    view
      auto_lookup_entry if @auto_lookup
      on_the_fly_entry if @on_the_fly
      advanced_search if @advanced_search
    determine_save_action unless @defer_save
  end

  def delete (opts={})
    view
    on CmLearningObjectivesPage do |category|
      begin
        category.delete_category(opts[:lo_level], opts[:category_level])
      rescue
        puts "no category exists."
      end
    end
    determine_save_action unless opts[:defer_save]
  end

  def add (opts={})
    view
    on_fly_entry if opts[:@on_the_fly]
    set_options(opts)
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
    on CmLearningObjectivesPage do |page|
      page.category_detail(@lo_level,@category_level).set @category_name
      page.auto_lookup @category_name
      page.add_category(@lo_level, @category_level)
    end
  end

  def on_the_fly_entry
    on CmLearningObjectivesPage do |page|
      page.category_detail(@lo_level, @category_level).set @category_name
      page.add_category(@lo_level, @category_level)
      page.category_type(@lo_level, @category_level).wait_until_present
      page.category_type(@lo_level, @category_level).pick(@category_type)
      page.add_category(@lo_level, @category_level)
    end
  end

  def advanced_search
    on CmLearningObjectivesPage do |page|
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

  def view
    on CmLearningObjectivesPage do |page|
      page.learning_objectives unless page.current_page('Learning Objectives').exists?
    end
  end

end


