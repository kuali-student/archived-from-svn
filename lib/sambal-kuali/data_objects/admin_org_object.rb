class CmAdminOrgObject < CmBaseObject

  attr_reader :admin_org_name,
              :admin_org_level,
              :defer_save




  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        admin_org_name: ["ARHU-Communication","AGNR-AES-CMREC-Forage Research Facility","AGNR-AES-CMREC-Turfgrass Research Facility"].sample,
        admin_org_level: 1,
        defer_save: false
    }
    set_options(defaults.merge(opts))

  end

  def create
    on CmGovernancePage do |page|
      page.governance unless page.current_page('Governance').exists?
      page.organization_add unless page.admin_org_name(@admin_org_level).exists?
      page.admin_org_name(@admin_org_level).set @admin_org_name
    end
  end





  def edit (opts={})
    on CmGovernancePage do |page|
      page.governance unless page.current_page('Governance').exists?
      page.organization_add unless page.admin_org_name(opts[:admin_org_level]).exists?
      page.admin_org_name(opts[:admin_org_level]).fit opts[:admin_org_name]
      page.auto_lookup opts[:admin_org_name] unless opts[:admin_org_name].nil?
      @admin_org_name = page.admin_org_name(opts[:admin_org_level]).value
    end
    determine_save_action unless opts[:defer_save]
    set_options(opts)
  end



  def delete (opts={})
    on CmGovernancePage do |page|
      page.governance unless page.current_page('Governance').exists?
      page.delete_admin_org(opts[:admin_org_level])
    end
    determine_save_action unless opts[:defer_save]
  end


end


