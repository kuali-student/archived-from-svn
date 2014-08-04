class CmDecisionsObject < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows
  include Utilities

  attr_accessor  :decisionText, :index




  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        index: 0,
        decisionText: random_alphanums(10,'test proposal decision '),
    }
    set_options(defaults.merge(opts))
  end

  def create
    on CmDecisions do |page|
      page.decision_text_input.set @decisionText
      page.add_decision
      page.loading_wait
    end
  end

  def edit (opts={})
    on CmDecisions do |page|
      page.edit_decision(opts[:index])
      if(page.alert.exists?)
        page.alert.ok
      end
      page.edit_decision_text_field(opts[:index]).set opts[:decisionText]
      page.save_edited_decision(opts[:index])
      sleep 1
    end
    set_options(opts)
  end



  def delete (opts={})
    on CmDecisions do |page|
      page.delete_decision(opts[:index])
      if(page.alert.exists?)
        page.alert.ok
      end
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