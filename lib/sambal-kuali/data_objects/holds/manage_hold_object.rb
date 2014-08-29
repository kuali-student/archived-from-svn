class ManageHoldData < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :hold_name, :hold_code, :hold_category,
                :hold_description

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :hold_name => nil,
        :hold_code => nil,
        :hold_category => "",
        :hold_description => nil
    }

    options = defaults.merge(opts)

    set_options(options)
  end

  def search
    go_to_manage_hold_catalog
  end

  def create
    search

    on ManageHold do |page|
      page.manage_hold_name_input.set @hold_name
      page.manage_hold_code_input.set @hold_code
      page.manage_hold_category_select.select @hold_category
      page.manage_hold_descr_input.set @hold_description
      page.manage_hold_show
    end
  end

  def edit
    on ManageHold do |page|
      page.edit_hold @hold_name
    end
  end

end