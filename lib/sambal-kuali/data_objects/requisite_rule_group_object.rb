class CmRequisiteRuleGroupObject < CmBaseObject

  attr_accessor :logic_operator,
                :left_rule,
                :right_rule
                :current_rule

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        logic_operator: "AND",
        current_rule: [(make CmRequisiteRuleObject)],
    }

    options = defaults.merge(opts)

    set_options(options)
  end

end


class CmRequisiteGroupNodeObject < CmBaseObject
  include Foundry

  attr_accessor :logic_operator,
                :left_rule_group,
                :right_rule_group,
                :current_rule

  def initialize(browser, opts={})
    @browser = browser

    defaults = {

    }

    options = defaults.merge(opts)

    set_options(options)
  end


end