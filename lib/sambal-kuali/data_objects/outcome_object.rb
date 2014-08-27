class CmOutcomeObject < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows
  include Utilities

  attr_accessor :outcome_type, :outcome_level, :credit_value, :defer_save




  def initialize(browser, opts={})
    @browser = browser
    defaults = {
      outcome_type: "Fixed",
      outcome_level: 1,
      credit_value: (1..5).to_a.sample,
      defer_save: false
    }
    set_options(defaults.merge(opts))

  end

  def create
    on CmCourseLogistics do |page|
      page.course_logistics unless page.current_page('Course Logistics').exists?
      page.add_outcome unless page.outcome_type(@outcome_level).exists?
      page.outcome_type(@outcome_level).wait_until_present
      page.outcome_type(@outcome_level).pick! @outcome_type
      page.loading_extended_wait
      page.credit_value(@outcome_level).wait_until_present
      page.credit_value(@outcome_level).set @credit_value
    end
  end





  def edit (opts={})
    on CmCourseLogistics do |page|
      page.course_logistics unless page.current_page('Course Logistics').exists?
      page.outcome_type(opts[:outcome_level]).pick! opts[:outcome_type] unless opts[:outcome_type].nil?
      page.credit_value(opts[:outcome_level]).fit opts[:credit_value]
    end
    determine_save_action unless opts[:defer_save]
    set_options(opts)
  end



def delete (opts={})
  on CmCourseLogistics do |page|
    page.course_logistics unless page.current_page('Course Logistics').exists?
    page.delete_outcome(opts[:outcome_level])
    page.loading_wait
  end
  determine_save_action unless opts[:defer_save]
end


end


