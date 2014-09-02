class CreateEditHoldData < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :hold_name, :hold_code, :hold_category,
                :hold_description, :owing_org, :org_contact,
                :contact_address, :first_applied_date,
                :last_applied_date, :term_based, :first_term,
                :last_term,:hold_history,
                :auth_org, :auth_org_name,
                :auth_apply_hold, :auth_expire_hold


  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :hold_name => nil,
        :hold_code => nil,
        :hold_category => "",
        :hold_description => nil,
        :owing_org => nil,
        :org_contact => nil,
        :contact_address => nil,
        :first_applied_date => right_now[:date_w_slashes],
        :last_applied_date => nil,
        :term_based => false,
        :first_term => nil,
        :last_term => nil,
        :hold_history => false
    }

    options = defaults.merge(opts)

    set_options(options)
  end

  def search
    go_to_manage_hold_catalog
  end

  def create
     search
     add

    on CreateHold do |page|
      page.loading.wait_while_present
      page.hold_name.set @hold_name
      page.code_input.set @hold_code
      page.hold_category.select @hold_category
      page.hold_descr_input.set @hold_description
      page.hold_own_org_find
      page.loading.wait_while_present
      page.hold_org_popup_search
      page.hold_org_popup_table_select(1)

      #page.create_or_edit_hold_save
    end
  end

  def add
    on ManageHold do |page|
      page.add_hold
    end
  end

end