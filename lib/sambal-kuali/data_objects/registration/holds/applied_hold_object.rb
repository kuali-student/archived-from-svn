class AppliedHold < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :student_id, :student_name, :name, :code,
                :category, :find_code_by_lookup

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :student_id => "ks-2014",
        :student_name => "FAULKNER, EMILY",
        :name => nil,
        :code => nil,
        :category => nil,
        :find_code_by_lookup => false
    }

    options = defaults.merge(opts)

    set_options(options)
  end

  def search
    go_to_manage_applied_hold
  end

  def manage
    search

    on ManageAppliedHold do |page|
      page.student_id_input.set @student_id

      page.show
      page.loading.wait_while_present
    end
  end

  def create
    manage

    on ManageAppliedHold do |page|
      page.apply_new_hold
    end

    on ApplyHold do |page|
      page.loading.wait_while_present

      if @code != nil and !@find_code_by_lookup
        page.hold_code_input.set @code
      elsif @find_code_by_lookup
        page.find_hold_code
        page.dialog_code_input.set @code if @code != nil
        page.dialog_search
        @code = page.results_select_by_code(@code)
      end

    end
  end

end