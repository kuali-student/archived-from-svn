class CmLearningObjectiveObject < CmBaseObject

  attr_accessor :learning_objective_text,
                :learning_objective_level,
                :category_list,
                :advanced_search,
                :lo_selection,
                :search_by_all,
                :search_by_course,
                :search_by_program,
                :search_type,
                :organize_action,
                :display_level
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
    on CmLearningObjectivesPage do |page|
      page.loading_extended_wait
      page.add_learning_objective unless @advanced_search
      if @advanced_search
        advanced_find
        @learning_objective_text = page.objective_detail(1).text
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
  on CmLearningObjectivesPage do |page|
    page.objective_detail(opts[:learning_objective_level]).set opts[:learning_objective_text] unless opts[:learning_objective_text].nil?
  end
  set_options(opts)

  determine_save_action unless opts[:defer_save]

end


def delete (opts={})
  view
  on CmLearningObjectivesPage do |page|
    page.delete_learning_objective(opts[:learning_objective_level])
   determine_save_action unless opts[:defer_save]
  end
end

def advanced_find
     on(CmLearningObjectivesPage).find_learning_objective
     on CmFindLearningObjectivesPage do |advanced_lo_search|
       fill_out advanced_lo_search, :search_by_all, :search_by_course, :search_by_program
       advanced_lo_search.search_type.pick @search_type unless @search_type.nil?
       advanced_lo_search.loading_wait
       sleep 1 # wait for the text box to appear
       advanced_lo_search.learning_objective_text.set @learning_objective_text
       advanced_lo_search.show_learning_objectives
       sleep 1 #to make sure that selection doesn't happen too quick
       advanced_lo_search.select_multiple_learning_objectives(@lo_selection)
       advanced_lo_search.add_learning_objectives
    end
end

def organize_learning_objective (opts={})

  case opts[:organize_action]

      when "Indent"
        on CmLearningObjectivesPage do |learn_obj|
          learn_obj.indent_lo(opts[:learning_objective_level])
        end
      when "Outdent"
        on CmLearningObjectivesPage do |learn_obj|
          learn_obj.outdent_lo(opts[:learning_objective_level])
        end
      when "Up"
        on CmLearningObjectivesPage do |learn_obj|
          learn_obj.move_up_lo(opts[:learning_objective_level])
        end
      when "Down"
        on CmLearningObjectivesPage do |learn_obj|
          learn_obj.move_down_lo(opts[:learning_objective_level])
        end
  end
  determine_save_action unless opts[:defer_save]
  set_options(opts)
end

def add_category (opts)
  defaults = {
      # :category_name => random_alphanums(10, 'text for dataObject'),
      # :category_type => '::random::',
      # :category_level => 1,
      # :auto_lookup => false,
      # :on_the_fly => false
  }
  options = defaults.merge(opts)
  options[:category].create
  @category_list << options[:category]
  sleep 2 #remove!
end

   def view
      on CmLearningObjectivesPage do |page|
        page.learning_objectives unless page.current_page('Learning Objectives').exists?
      end
   end



end