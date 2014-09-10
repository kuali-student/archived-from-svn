class CmRetireCourseProposal < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows
  include Utilities

  attr_accessor :course,
                :admin_proposal,
                :curriculum_review_process,
                :retire_proposal_title,
                :retirement_rationale,
                :start_term,
                :end_term,
                :last_term_offered,
                :last_catalog_pub_year,
                :other_comments,
                :author_list,
                :supporting_doc_list,
                :defer_save


  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        :admin_proposal => false,
        :curriculum_review_process => nil,
        :retire_proposal_title => random_alphanums(10,'test retirement proposal title '),
        :retirement_rationale => random_alphanums(20, 'test retirement rationale '),
        :end_term => '::random::',
        :last_term_offered => '::random::',
        :last_catalog_pub_year => '::random::',
        :other_comments => random_alphanums(10,'test retirement comment '),
        :defer_save => false
    }
    set_options(defaults.merge(opts))

  end

  def create
      select_course
      select_curr_review if @admin_proposal
      populate_retirement_info
      create_author
      create_supporting_docs
  end


  def edit (opts={})
    return_to_cm_home
    navigate_to_find_course
    search
    edit_retire_proposal
      on CmRetirementInformation do |page|
        page.retirement_information unless page.current_page('Retirement Information').exists?
        page.retiremenet_rationale.set opts[:retirement_rationale]
      end
    set_options(opts)
  end

  def select_course
    on CmReviewProposal do |course|
      @course.view_course
      course.retire_proposal
    end
  end

  def select_curr_review
    on CmReviewProposal do |retire|
      fill_out retire, :curriculum_review_process
      retire.retire_continue
    end
  end

  def populate_retirement_info
    on CmRetirementInformation do |page|
      page.retirement_information unless page.current_page('Retirement Information').exists?
      fill_out page, :retire_proposal_title, :retirement_rationale, :other_comments
      @start_term = page.start_term
      page.end_term.pick! @end_term
      page.last_term_offered.pick! @last_term_offered
      page.last_catalog_pub_year.pick! @last_catalog_pub_year
      determine_save_action unless @defer_save
    end
  end


  def create_author
    unless @author_list.nil?
      @author_list.each do |authors|
        authors.create
      end
    end
  end

  def create_supporting_docs
    unless @supporting_doc_list.nil?
      @supporting_doc_list.each do |supporting_doc|
        supporting_doc.create
      end
    end
  end

  def navigate_to_retire_review
    on CmRetirementInformation do |retire|
        retire.supporting_documents unless retire.current_page('Supporting Documents').exists?
        retire.review_retire_proposal
    end
  end

  def navigate_search_retire_proposal
    navigate_rice_to_cm_home
    navigate_to_find_course
    search
    review_retire_proposal
  end

  def search
    on FindProposalPage do |page|
      page.name.wait_until_present
      page.name.set @retire_proposal_title
      page.find_a_proposal
    end
  end

  def review_retire_proposal
    on FindProposalPage do |page|
      page.review_proposal_action_link(@retire_proposal_title)
    end
  end
  
  def edit_retire_proposal
    on FindProposalPage do |page|
      page.edit_proposal_action(@retire_proposal_title)
    end
  end

  def approve
    navigate_search_retire_proposal
    on CmRetireProposalReviewPage do |approve|
      approve.decision_rationale.wait_until_present
      approve.decision_rationale.set random_alphanums(10,'test decision rationale ')
      approve.confirmation_approval
    end
  end

  def submit_retire_proposal
    on CmRetireProposalReviewPage do |page|
        page.submit_proposal
        page.submit_confirmation
    end
  end

  def blanket_approve_retire_proposal
    navigate_search_retire_proposal
    on CmRetireProposalReviewPage do |blanket_approve|
      blanket_approve.blanket_approve
      blanket_approve.blanket_approve_rationale.set random_alphanums(10,'test blanket approve rationale ')
      blanket_approve.confirmation_approval
    end
  end



end


