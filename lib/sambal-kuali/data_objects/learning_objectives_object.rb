class CmLearningObjectiveObject < DataFactory

include Foundry
include DateFactory
include StringFactory
include Workflows
include Utilities

  attr_reader   :learning_objective_text,
                :learning_objective_level,
                :category_list,
                :advanced_search,
                :defer_save




  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        learning_objective_text: random_alphanums(10,'Test Learning Objective '),
        learning_objective_level: 1,
        category_list: [(make CmLoCategoryObject)],
        advanced_search: false,
        defer_save: false
    }
    set_options(defaults.merge(opts))

  end

  def create
    on CmLearningObjectives do |page|
      page.learning_objectives unless page.current_page('Learning Objectives').exists?
      page.add_learning_objective unless page.objective_detail(@learning_objective_level).exists?
      page.objective_detail(1).set @learning_objective_text

      unless @category_list.nil?
        @category_list.each do |category|
          category.create
        end
      end

    end
    determine_save_action unless @defer_save
  end


  def show_find_lo_lightbox
    on CmLearningObjectives do |page|
      page.find_learning_objective
    end
  end


def show_select_category_lightbox(opts={})
  on CmLearningObjectives do |page|
    page.find_categories(opts[:category_level])
  end
end


def edit (opts={})

    set_options(opts)
end

def advanced_find
     on CmFindLearningObjectivesPage do |page|
       page.show_learning_objectives
       sleep 2 #to make sure that selection doesn't happen too quick
       page.select_multiple_learning_objectives(3)
       page.add_learning_objectives
    end
end

end