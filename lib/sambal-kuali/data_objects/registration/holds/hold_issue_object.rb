class HoldIssue < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :name, :code, :category, :auth_org, :suffix,
                :description, :owning_org_abbr, :org_contact,
                :contact_address, :first_applied_date,
                :last_applied_date, :term_based, :first_term,
                :last_term, :hold_history, :authorising_orgs

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :name => nil,
        :code => nil,
        :suffix => nil,
        :category => nil,
        :description => nil,
        :owning_org_abbr => "UME-Wicomico",
        :org_contact => nil,
        :contact_address => nil,
        :first_applied_date => right_now[:date_w_slashes],
        :last_applied_date => nil,
        :term_based => false,
        :first_term => nil,
        :last_term => nil,
        :authorising_orgs =>  collection('HoldIssueAuthorisingOrg'),
        :hold_history => false,
        :defer_save => false
    }

    options = defaults.merge(opts)

    set_options(options)

    @suffix = rand(999) if @suffix == nil
  end

  def search
    go_to_manage_hold_catalog
  end

  def manage
    search

    on ManageHoldIssue do |page|
      page.manage_hold_name_input.fit @name
      page.manage_hold_code_input.fit @code
      page.manage_hold_category_select.fit @category
      page.manage_hold_descr_input.fit @description

      page.manage_hold_search
    end
  end

  def create

    search

    on ManageHoldIssue do |page|
      page.add_hold
    end

    on HoldIssueCreateEdit do |page|
      page.loading.wait_while_present

      @category = "Academic Advising Issue" if @category == nil
      page.category_input.select @category

      @name = "Academic Advising Issue #{@suffix}" if @name == nil
      page.name_input.set @name

      @code = "AAI#{@suffix}" if @code == nil
      page.code_input.set @code

      @description = ("AFT created Description " + random_alphanums(40)) if @description == nil
      page.descr_input.set @description

      page.find_owning_org @owning_org_abbr
      page.last_applied_date_input.fit @last_applied_date

      if @term_based
        page.set_term_based
        page.first_term_input.when_present.set @first_term
        page.last_term_input.when_present.set @last_term
      end

      page.set_history if @hold_history

      @authorising_orgs.each do |auth_org|
        auth_org.parent = self
        auth_org.create
      end

      page.save if !@defer_save
    end
  end

  def edit opts = {}
    defaults = {
        :navigate_to_page => false,
        :save_edit => true
    }
    options = defaults.merge(opts)

    set_options(options)

    manage if options[:navigate_to_page]

    on ManageHoldIssue do |page|
      page.edit_hold @name
    end

    on HoldIssueCreateEdit do |page|
      page.loading.wait_while_present

      if options[:category] != nil
        page.category_input.select options[:category]
        @category = options[:category]
      end

      if options[:name] != nil
        page.name_input.set options[:name]
        @name = options[:name]
      end

      if options[:code] != nil
        page.code_input.set options[:code]
        @code = options[:code]
      end

      if options[:description] != nil
        page.descr_input.set options[:description]
        @description = options[:description]
      end

      if options[:owning_org_abbr] != nil
        page.find_owning_org options[:owning_org_abbr]
        @owning_org_abbr = options[:owning_org_abbr]
      end

      if options[:authorising_orgs] != nil
        options[:authorising_orgs].each do |auth_org|
          auth_org.parent = self
          auth_org.create
          @authorising_orgs << auth_org
        end
      end

      if options[:hold_history] != nil
          page.history.set(options[:hold_history])
          @hold_history = options[:hold_history]
      end

      page.save unless options[:defer_save]
    end
  end

  def add_authorising_org opts
    opts[:auth_org_obj].parent = self
    opts[:auth_org_obj].create
    @authorising_orgs << opts[:auth_org_obj]
  end

end