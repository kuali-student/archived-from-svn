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
                :lo_selection,
                :search_by_all,
                :search_by_course,
                :search_by_program,
                :search_type,
                :organize_action,
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
    view
    on CmLearningObjectives do |page|
      page.add_learning_objective
      if @advanced_search
        advanced_find
      else
        page.objective_detail(1).set @learning_objective_text
      end

      unless @category_list.nil?
        @category_list.each do |category|
          category.create
        end
      end

    end
    determine_save_action unless @defer_save
  end

def edit (opts={})
  view
  on CmLearningObjectives do |page|
    page.objective_detail(opts[:learning_objective_level]).set opts[:learning_objective_text] unless opts[:learning_objective_text].nil?
  end
  set_options(opts)

  determine_save_action unless opts[:defer_save]

end


def delete (opts={})
  on CmLearningObjectives do |page|
    page.delete_learning_objective(opts[:objective_level])
    page.loading_wait
  end
end

def advanced_find
     on(CmLearningObjectives).find_learning_objective
     on CmFindLearningObjectivesPage do |advanced_lo_search|
       fill_out advanced_lo_search, :search_by_all, :search_by_course, :search_by_program
       advanced_lo_search.search_type.pick @search_type unless @search_type.nil?
       advanced_lo_search.loading_wait
       sleep 2 # wait for the text box to appear
       advanced_lo_search.learning_objective_text.set @learning_objective_text
       advanced_lo_search.show_learning_objectives
       sleep 2 #to make sure that selection doesn't happen too quick
       advanced_lo_search.select_multiple_learning_objectives(@lo_selection)
       advanced_lo_search.add_learning_objectives
    end
end

def organize_learning_objective (opts={})

  case opts[:organize_action]

      when "Indent"
        on CmLearningObjectives do |learn_obj|
          learn_obj.indent_lo(opts[:learning_objective_level])
        end
      when "Outdent"
        on CmLearningObjectives do |learn_obj|
          learn_obj.outdent_lo(opts[:learning_objective_level])
        end
      when "Move Up"
        on CmLearningObjectives do |learn_obj|
          learn_obj.move_up_lo(opts[:learning_objective_level])
        end
      when "Move Down"
        on CmLearningObjectives do |learn_obj|
          learn_obj.move_down_lo(opts[:learning_objective_level])
        end
  end
  determine_save_action unless opts[:defer_save]
end

def add_category (opts)
  defaults = {
      :category_name => random_alphanums(10, 'text for dataObject'),
      :category_type => '::random::',
      :category_level => 1,
      :auto_lookup => false,
      :on_the_fly => false,
  }
  options = defaults.merge(opts)
  options[:category].create
  @category_list << options[:category]
end

   def view
      on CmLearningObjectives do |page|
        page.learning_objectives unless page.current_page('Learning Objectives').exists?
      end
   end



end