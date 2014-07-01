class CmLearningObjectiveObject < DataFactory

include Foundry
include DateFactory
include StringFactory
include Workflows
include Utilities

  attr_reader   :learning_objective_text,
                :category_text,
                :category_type,
                :category_auto_lookup,
                :learning_objective_level,
                :category_level,
                :defer_save




  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        learning_objective_text: random_alphanums(10,'Test Learning Objective '),
        category_text: random_alphanums(10,'on the fly category '),
        category_auto_lookup: false,
        category_type: '::random::',
        learning_objective_level: 1,
        category_level: 1,
        defer_save: false
    }
    set_options(defaults.merge(opts))

  end

  def create
    on CmLearningObjectives do |page|
      page.learning_objectives unless page.current_page('Learning Objectives').exists?
      page.add_learning_objective unless page.objective_detail(@learning_objective_level).exists?
      page.objective_detail(1).set @learning_objective_text
      page.category_detail(@category_level).set @category_text
      if @category_auto_lookup
        page.auto_lookup @category_text
      else
        page.add_category(@category_level)
        page.category_type(@category_level).wait_until_present
        page.category_type(@category_level).pick(@category_type)
      end
      sleep 2
      page.add_category(@category_level)


    end
    determine_save_action unless @defer_save
  end



  def edit (opts={})

    set_options(opts)
  end


end