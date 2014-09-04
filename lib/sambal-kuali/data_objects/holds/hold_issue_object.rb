class HoldIssueData < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :name, :code, :category,
                :description, :owing_org, :org_contact,
                :contact_address, :first_applied_date,
                :last_applied_date, :term_based, :first_term,
                :last_term, :hold_history

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :name => "Academic Advising Issue 88",
        :code => "AAI88",
        :category => "Academic Advising Issue",
        :description => random_alphanums(50),
        :owing_org => nil,
        :org_contact => nil,
        :contact_address => nil,
        :first_applied_date => right_now[:date_w_slashes],
        :last_applied_date => nil,
        :term_based => false,
        :first_term => nil,
        :last_term => nil,
        :hold_history => false,
        :defer_save => false
    }

    options = defaults.merge(opts)

    set_options(options)
  end

  def search
    go_to_manage_hold_catalog
  end

  def manage
    search

    on ManageHold do |page|
      page.manage_hold_name_input.set @name
      page.manage_hold_code_input.set @code
      page.manage_hold_category_select.select @category
      page.manage_hold_descr_input.set @description
      page.manage_hold_show
    end
  end

  def create
    search

    on ManageHold do |page|
      page.add_hold
    end

    on CreateHold do |page|
      page.loading.wait_while_present

      page.category_input.select @category
      page.name_input.set @name
      page.code_input.set @code
      page.descr_input.set @description
      page.find_owning_org @owning_org

      page.save if !@defer_save
    end
  end

  def edit
    on ManageHold do |page|
      page.edit_hold @hold_name
    end
  end

end