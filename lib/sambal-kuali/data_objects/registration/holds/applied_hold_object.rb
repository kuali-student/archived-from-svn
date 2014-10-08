class AppliedHold < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :student_id, :student_name, :name, :code,
                :category, :find_code_by_lookup, :state,
                :effective_date, :effective_term, :term_based,
                :hold_issue, :expiration_date, :expiration_term

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :hold_issue => nil,
        :student_id => "ks-2014",
        :student_name => "FAULKNER, EMILY",
        :state => "Active",
        :find_code_by_lookup => false,
        :effective_date => right_now[:date_w_slashes],
        :effective_term => nil,
        :expiration_date => right_now[:date_w_slashes],
        :expiration_term => nil
    }

    options = defaults.merge(opts)

    set_options(options)

    @effective_term = @hold_issue.first_term
    @expiration_term = @hold_issue.last_term
  end

  def search
    go_to_manage_applied_hold
  end

  def create
    search

    on ManageAppliedHold do |page|
      page.student_id_input.set @student_id

      page.show
      page.loading.wait_while_present
    end
  end

  def exists?
    if on(ManageAppliedHold).get_applied_hold_by_code( @hold_issue.code).nil?
      return false
    end

    return true
  end

  def apply_hold opts = {}
    defaults = {
        :exp_success => true
    }
    options = defaults.merge(opts)

    if exists?
      on ManageAppliedHold do |page|
        @effective_term = page.get_applied_hold_effective_term( @hold_issue.code)
        @effective_date = page.get_applied_hold_effective_date( @hold_issue.code)
      end
    else
      on ManageAppliedHold do |page|
        page.apply_new_hold
      end

      on ApplyHold do |page|
        page.loading.wait_while_present

        if !@find_code_by_lookup
          page.hold_code_input.set @hold_issue.code

          page.send_keys :tab
          page.loading.wait_while_present

          #Sometimes the tab out does not load the term and date input fields, which causes a timeout error since those fields aren't visible
          #so adding this to make sure those fields did load properly
          if !page.effective_date.visible?
            page.apply_hold_btn.focus
          end
        else
          page.find_hold_code

          wait_until { page.frm_popup.exists? }
          page.dialog_code_input.set @hold_issue.code
          page.dialog_search

          page.loading.wait_while_present
          page.results_select_by_code(@hold_issue.code)
        end

        if @hold_issue.term_based or options[:term_based]
          if options[:effective_term] != nil
            page.effective_term.when_present.set options[:effective_term]
            @effective_term = options[:effective_term]
          else
            page.effective_term.set @effective_term
          end
        end

        if options[:effective_date] != nil
          page.effective_date.set options[:effective_date]
          @effective_date = options[:effective_date]
        else
          page.effective_date.set @effective_date
        end

        page.apply_hold if options[:exp_success]
      end
    end

  end

  def expire_hold opts = {}
    defaults = {
        :exp_success => true
    }
    options = defaults.merge(opts)

    on ManageAppliedHold do |page|
      page.select_hold( @hold_issue.code)
      page.expire_hold
    end

    on ExpireAppliedHold do |page|
      if options[:expiration_date] != nil
        page.expiration_date.set options[:expiration_date]
        @expiration_date = options[:expiration_date]
      end

      if options[:expiration_term] != nil
        page.expiration_term.set options[:expiration_term]
        @expiration_term = options[:expiration_term]
      end

      page.expire_hold
    end

    @state = "Expired" if options[:exp_success]
  end

  def delete_hold
    on ManageAppliedHold do |page|
      page.select_hold( @hold_issue.code)
      page.delete_hold
    end

    on(DeleteAppliedHold).confirm_delete_hold
  end

end