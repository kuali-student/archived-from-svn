class HoldIssueAuthorisingOrg < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :parent, :auth_org, :auth_apply, :auth_expire

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :parent => nil,
        :auth_org => nil,
        :auth_apply => true,
        :auth_expire => true
    }

    options = defaults.merge(opts)

    set_options(options)
  end

  def create

    on HoldIssueCreateEdit do |page|
      page.add_auth_org

      index = page.get_index_for_empty_row
      page.find_auth_org_to_add( @auth_org, index)
      page.auth_apply(index) if @auth_apply
      page.auth_expire(index) if @auth_expire
    end
  end

end

class HoldIssueAuthorisingOrgCollection < CollectionsFactory

  contains HoldIssueAuthorisingOrg

end