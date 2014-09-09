class AppliedHoldData < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :student_id

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :student_id => "ks-2014",
    }

    options = defaults.merge(opts)

    set_options(options)
  end

  def search
    go_to_manage_applied_hold
  end

  def create
    search
    on ManageAppliedHold do |page|
      page.manage_applied_hold_studentid_input.set @student_id
      page.manage_applied_hold_show
    end
  end


end