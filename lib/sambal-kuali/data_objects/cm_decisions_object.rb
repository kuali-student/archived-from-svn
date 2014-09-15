class CmDecisionsObject < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows
  include Utilities

  attr_accessor  :decision_text,
                 :decision,
                 :date,
                 :actor,
                 :rationale



  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        decision_text: random_alphanums(10,'test proposal decision '),
    }
    set_options(defaults.merge(opts))
  end

  def show_decision (row)
    on CmDecisionsPage do |page|
      decision_row_text = page.row_by_index(row)
      contents = decision_row_text.split(' ',5)
      @decision = contents[0]
      @date = contents[1]
      @actor = contents[2]
      @rationale = contents[4]
    end
  end

  def close_decision_dialog()
    on CmDecisionsPage do |page|
      page.close_dialog
      page.loading_wait
    end
    sleep 1
  end
end