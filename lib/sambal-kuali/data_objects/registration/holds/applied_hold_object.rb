class AppliedHold < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :student_id, :student_name, :name, :code,
                :category, :find_code_by_lookup, :apply_hold,
                :state, :exp_success

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :student_id => "ks-2014",
        :student_name => "FAULKNER, EMILY",
        :name => "Academically Ineligible",
        :code => "ACAD02",
        :category => "Academic Progress Issue",
        :find_code_by_lookup => false,
        :apply_hold => false,
        :state => "Active"
    }

    options = defaults.merge(opts)

    set_options(options)
  end

  def search
    go_to_manage_applied_hold
  end

  def expire opts = {}
    defaults = {
        :exp_success=> true,
    }
    options = defaults.merge(opts)

    on ManageAppliedHold do |page|
      page.expire_hold(@code)
    end
    on ExpireAppliedHold do |page|
      page.confirm_expire_hold(right_now[:date_w_slashes])
    end

    @state = "Expired" if options[:exp_success]
  end

  def delete
    on ManageAppliedHold do |page|
      page.delete_hold(@code)
    end
    on DeleteAppliedHold do |page|
      page.confirm_delete_hold
    end
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

      if !@find_code_by_lookup
        page.hold_code_input.set @code
      else
        page.find_hold_code

        wait_until { page.frm_popup.exists? }
        page.dialog_code_input.set @code
        page.dialog_search
        page.results_select_by_code(@code)
      end

      if @apply_hold != false
        page.code_details_show
        page.loading.wait_while_present
        page.apply_hold
      end
    end
  end

end