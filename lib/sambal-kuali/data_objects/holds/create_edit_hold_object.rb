class CreateEditHoldData < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :parent, :owing_org, :org_contact,
                :contact_address, :first_applied_date,
                :last_applied_date, :term_based, :first_term,
                :last_term,:hold_history,
                :auth_org, :auth_org_name,
                :auth_apply_hold, :auth_expire_hold


  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :parent => nil,
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

  def create
    @parent.search
    @parent.add

    on CreateHold do |page|
      page.loading.wait_while_present
      page.hold_category.select @parent.hold_category
      page.hold_name.set @parent.hold_name
      page.code_input.set @parent.hold_code
      page.hold_descr_input.set @parent.hold_description
      page.hold_own_org_find
      page.loading.wait_while_present
      page.hold_org_popup_search
      page.hold_org_popup_table_select(1)

      page.hold_save
    end
  end

end