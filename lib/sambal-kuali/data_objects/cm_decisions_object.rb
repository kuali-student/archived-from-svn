class CmDecisionsObject < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows
  include Utilities

  attr_accessor  :decisionText,
                 :Decision,
                 :Date,
                 :Actor,
                 :Rationale



  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        decisionText: random_alphanums(10,'test proposal decision '),
    }
    set_options(defaults.merge(opts))
  end

  def show_decision (row)
    on CmDecisions do |page|
      decisionText = page.row_by_index(row)
      contents = decisionText.split(' ',5)
      @Decision = contents[0]
      @Date = contents[1]
      @Actor = contents[2]
      @Rationale = contents[4]
    end
  end

  def close_decision_dialog()
    on CmDecisions do |page|
      page.close_dialog
      page.loading_wait
    end
    sleep 1
  end
end