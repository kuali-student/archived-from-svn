class CmCourseProposalObject < CmBaseObject


  # Course Information, Governance, Course Logistics, Active Dates completed
  attr_accessor :proposal_title, :course_title,  :subject_code,
                :optional_fields, :approve_fields, :submit_fields,
        :cross_listed_course_list,
        :jointly_offered_course_list,
        :version_code_list,
        :description_rationale, :proposal_rationale,
        #
        :outcome_list,
        :format_list,

        #Learning Objectives
        :learning_objective_list,
        #Course Requisites
        :course_requisite_list,

        :author_list,
        :supporting_doc_list,

        #Save
        :create_new_proposal,
        :save_proposal,
        :defer_save,
        :blank_proposal,
        :create_basic_proposal,
        :create_optional_fields,
        :curriculum_review_process,
        :copy_from_course,
        :course_to_be_copied,
        :proposal_to_be_copied,
        :use_view_course,
        :copy_from_proposal,
        :approval_confirmation_text


  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        #COURSE INFORMATION
        proposal_title:             random_alphanums(10,'test proposal title '),
        course_title:               random_alphanums(10, 'test course title '),
        curriculum_review_process:  nil,
        create_new_proposal:        true,
        blank_proposal:             false,
        create_basic_proposal:      false,
        create_optional_fields:     false,
        copy_from_course:           false,
        copy_from_proposal:         false,
        course_to_be_copied:        nil,
        proposal_to_be_copied:      nil,
        use_view_course:            false,
        save_proposal:              true,
        defer_save:                 false
    }
    set_options(defaults.merge(opts))

    # random_checkbox and random_radio is used to select a random checkbox/radio on a page.
    # That will then be set the instance variable to :set, so that it can be used in the fill_out method for later tests

  end


  def create
    if (@use_view_course)
      create_proposal_through_view_course
    else
      navigate_rice_to_cm_home
      navigate_to_create_course_proposal
      set_curriculum_review

      if @create_optional_fields
        create_course_continue
        create_proposal_optional
      elsif @create_new_proposal
        create_course_continue
        create_course_proposal_required unless @blank_proposal
        determine_save_action unless @defer_save
      elsif @copy_from_course
        create_proposal_by_copy_course unless @course_to_be_copied.nil?
        on CmCourseInformationPage do |page|
          page.course_information unless page.current_page('Course Information').exists?
          fill_out page, :proposal_title, :course_title
          page.course_number.fit @approve_fields[0].course_number
        end

        determine_save_action  unless @defer_save
      elsif @copy_from_proposal
        create_proposal_by_copy_proposal unless @proposal_to_be_copied.nil?
        on CmCourseInformationPage do |page|
          page.course_information unless page.current_page('Course Information').exists?
          fill_out page, :proposal_title, :course_title
        end
        determine_save_action  unless @defer_save
      end
    end
  end


  def edit (opts={})
    if opts[:cs_with_cr]
      on CmReviewProposalPage do |page|
        page.edit_course_information
        page.loading_wait
      end
    elsif opts[:cs_without_cr]

    else
        determine_edit_action
    end

    on CmCourseInformationPage do |page|
      page.course_information unless page.current_page('Course Information').exists?
      page.proposal_title.fit opts[:proposal_title]
      page.course_title.fit opts[:course_title]
    end

    if opts[:cs_without_cr]
      on CmCourseInformationPage do |page|
        page.save_modification
      end
    else
      determine_save_action unless opts[:defer_save]
    end

    set_options(opts)
  end

  def create_basic_proposal
    on CmCourseInformationPage do |page|
      page.course_information unless page.current_page('Course Information').exists?
      fill_out page, :proposal_title, :course_title
    end

    determine_save_action unless @defer_save

  end

  def create_proposal_optional
    create_basic_proposal

    @optional_fields.each do |optional|
     optional.create
    end

  end

  def create_proposal_through_view_course
    on CmReviewProposalPage do |review|
      review.copy_proposal
      review.loading_wait
    end
    on CmCourseInformationPage do |page|
      page.course_information unless page.current_page('Course Information').exists?
      fill_out page, :proposal_title, :course_title
      page.course_number.fit @approve_fields[0].course_number
    end

    determine_save_action
  end

  def create_proposal_by_copy_course
    on CmCreateCourseStartPage do |create|
      create.copy_approved_course.click
      create.cm_proposal_copy_course_code_field.set @course_to_be_copied.course_code
      create.auto_lookup @course_to_be_copied.course_code
      create.loading_wait
      create.continue
    end
  end

  def create_proposal_by_copy_proposal
    on CmCreateCourseStartPage do |create|
      create.copy_proposed_course.click
      create.cm_proposal_copy_proposal_title_field.set @proposal_to_be_copied.proposal_title
      create.auto_lookup @proposal_to_be_copied.proposal_title
      create.loading_wait
      create.continue
    end
  end

  def delete_requisite (opts={})
    on CmCourseRequisitesPage do |page|
      page.course_requisites unless page.current_page('Course Requisites').exists?
      section = opts[:requisite_type]
      case section
        when "Student Eligibility & Prerequisite"
          #STUDENT ELIGIBILITY #A,G,M,S,Y
          begin
            page.delete_rule_student_eligibility
          rescue Exception => e
            page.delete_rule('AE')
          end
        when "Corequisite"
          page.delete_rule_corequisite
        when "Recommended Preparation"
          page.delete_rule_recommended_prep
        when "Antirequisite"
          page.delete_rule_antirequisite
        when "Repeatable for Credit"
          page.delete_rule_repeatable_for_credit
        when "Course that Restricts Credits"
          page.delete_rule_restricts_credits
        else
          raise "No requisite rule type defined!"
      end
    end
  end

  def create_course_proposal_required
    on CmCourseInformationPage do |page|
      page.course_information unless page.current_page('Course Information').exists?
      fill_out page, :proposal_title, :course_title
    end
    determine_save_action


      unless @cross_listed_course_list.nil?
        @cross_listed_course_list.each do |cross_listed_course|
          cross_listed_course.create
        end
      end

      unless @jointly_offered_course_list.nil?
        @jointly_offered_course_list.each do |jointly_offered_course|
          jointly_offered_course.create
        end
      end

      unless @version_code_list.nil?
        @version_code_list.each do |version_code|
          version_code.create
        end
      end

      unless @submit_fields.nil?
        @submit_fields.each do |submit_fields|
          submit_fields.create
        end
      end

      unless @approve_fields.nil?
        @approve_fields.each do |approve_fields|
          approve_fields.create
        end
      end

      unless @learning_objective_list.nil?
          @learning_objective_list.each do |learning_objective|
          learning_objective.create
          end
      end

      unless @course_requisite_list.nil?
        @course_requisite_list.each do |course_requisite|
          course_requisite.create
        end
      end


      unless @author_list.nil?
        @author_list.each do |authors|
          authors.create
        end
      end

      unless @supporting_doc_list.nil?
        @supporting_doc_list.each do |supporting_doc|
          supporting_doc.create
        end
      end

      unless @optional_fields.nil?
        @optional_fields.each do |optional|
          optional.create
        end
      end

    determine_save_action unless @defer_save

  end # required proposal

  #Used for Advanced Search to "Return Value" of the result that matches
  #Defaults to 4th Column to match instructor display name but can be altered for different advacned search results by passing in a number of the column
  def cancel_create_course
    on CmCreateCourseStartPage do |page|
      page.cancel
    end
  end

  def cancel_course_proposal
     on CmCourseInformationPage do |page|
       page.cancel_action
     end
  end

  def cancel_proposal_document
    on CmCourseInformationPage do |page|
      page.cancel_proposal
      page.confirm_cancel_proposal
    end
  end

  def set_curriculum_review
  on CmCreateCourseStartPage do |create|
    create.curriculum_review_process.fit checkbox_trans[@curriculum_review_process] unless @curriculum_review_process.nil?
  end
  end

  def create_course_continue
    on CmCreateCourseStartPage do |create|
      create.continue
    end
  end

  def search
    navigate_to_find_course_proposal
       on FindProposalPage do |page|
          page.name.wait_until_present
          page.name.set @proposal_title
          page.find_a_proposal
       end

  end

  def partial_search(search_text)
    navigate_to_find_course_proposal
    on FindProposalPage do |page|
      page.name.wait_until_present
      page.name.set search_text
      page.find_a_proposal
    end
  end

  def load_comments_action
    on CmCourseInformationPage do |page|
      page.comments_link.wait_until_present(90)
      page.load_comments
    end
  end


  def load_comments_on_review_page
    on CmReviewProposalPage do |page|
      page.load_comments
    end
  end

  def load_decisions_action
    on CmCourseInformationPage do |page|
      page.load_decisions
    end
  end


  def review_proposal_action
    on FindProposalPage do |page|
      page.review_proposal_action_link(@proposal_title)
      page.loading_wait
    end
  end

  def edit_proposal_action
    on FindProposalPage do |page|
      page.edit_proposal_action(@proposal_title)
      page.loading_wait
    end
  end

  def edit_course_information
    on CmReviewProposalPage do |page|
      page.edit_course_information
      page.loading_wait
    end
  end

  def determine_edit_action
    #if current page is find a proposal click the pencil icon


    on CmReviewProposalPage do |page|
      if page.proposal_title_element.exists?
        edit_course_information
      end
    end

    #if current page is review proposal click the course information edit icon

    on FindProposalPage do |page|
      if page.name.exist?
        edit_proposal_action
      end

    end

  end

  def add_outcome (opts)
    defaults = {
        :outcome_type => "Fixed"
    }
    options = defaults.merge(opts)
    options[:outcome].create
    @outcome_list << options[:outcome]
    determine_save_action
  end



  def add_author (opts)
    defaults = {

    }
    options = defaults.merge(opts)
    options[:author].create
    @author_list << options[:author]
  end

  def add_learning_objective (opts)
    defaults = {

    }
    options = defaults.merge(opts)
    options[:learn_obj].create
    @learning_objective_list << options[:learn_obj]
    determine_save_action
  end

  def add_supporting_doc (opts)
    defaults = {

    }
    options = defaults.merge(opts)
    options[:supporting_doc].create
    @supporting_doc_list << options[:supporting_doc]
    determine_save_action unless opts[:defer_save]
  end

  def submit_proposal
    on(CmCourseInformationPage).review_proposal
    sleep 1
    on(CmReviewProposalPage).submit_proposal
    sleep 1
    on(CmReviewProposalPage).submit_confirmation
    sleep 2
  end

  def submit_incomplete_proposal
    on(CmCourseInformationPage).review_proposal
    on(CmReviewProposalPage).submit_proposal
  end

  def submit_button_disabled
    on(CmCourseInformationPage).review_proposal
    begin
      on(CmReviewProposalPage).submit_proposal
    rescue Exception => e
      #element should be disabled
      (e.message.include? "object is disabled").should == true
    end
  end

  def approve_proposal
    navigate_to_review
    approve
  end

  def approve
    on CmReviewProposalPage do |approve|
      approve.review_approval
      approve.decision_rationale.wait_until_present
      approve.decision_rationale.set random_alphanums(10,'test decision rationale ')
      approve.confirmation_approval
    end
  end


  def approve_activate_proposal
    on CmCourseInformationPage do |activate|
      activate.approve_and_activate
      sleep 30 # to avoid workflow exceptions
    end
  end

  def blanket_approve
    on CmReviewProposalPage do |proposal|
      proposal.blanket_approve
      sleep 30 # to avoid workflow exceptions
    end
  end

  def blanket_approve_with_rationale
    navigate_to_review
    on CmReviewProposalPage do |proposal|
      proposal.blanket_approve
      proposal.blanket_approve_rationale.set random_alphanums(10,'test blanket approve rationale ')
      proposal.confirmation_approval
    end
  end

  def direct_blanket_approve_with_rationale
    on(CmCourseInformationPage).review_proposal
    on CmReviewProposalPage do |proposal|
      proposal.blanket_approve
      proposal.blanket_approve_rationale.set random_alphanums(10,'test blanket approve rationale ')
      proposal.confirmation_approval
      sleep 30 # to avoid workflow exceptions
    end
  end

  def return_proposal(return_level)
    on CmReviewProposalPage do |proposal|
      proposal.review_return
      proposal.return_to_node_list.select(return_level)
      proposal.return_rationale.wait_until_present
      proposal.return_rationale.set random_alphanums(10,'test return rationale ')
      proposal.confirm_return
    end
  end

  def resubmit_proposal
    on CmReviewProposalPage do |proposal|
      proposal.resubmit
      proposal.decision_rationale.set random_alphanums(10,'test resubmit rationale ')
      proposal.confirmation_approval
    end
  end

 def fyi_navigate_review
   navigate_to_review
   fyi_review
 end

 def fyi_review
   on CmReviewProposalPage do |proposal|
     proposal.fyi_review
   end
 end

 def acknowledge
   navigate_to_review
   on CmReviewProposalPage do |proposal|
     proposal.acknowledge
     proposal.acknowledge_rationale.set random_alphanums(10,'test acknowledge rationale ')
     proposal.confirmation_acknowledge
   end
 end

 def reject_with_rationale
   navigate_to_review
   on CmReviewProposalPage do |proposal|
     proposal.reject
     proposal.reject_rationale.set random_alphanums(10,'test reject rationale ')
     proposal.confirmation_reject
   end
 end

 def navigate_to_review
   navigate_rice_to_cm_home
   search
   review_proposal_action
 end
  
  
  def withdraw_proposal
    navigate_to_functional_home
    navigate_to_review
    on CmReviewProposalPage do |proposal|
      proposal.withdraw
      proposal.withdraw_rationale.set random_alphanums(10,'test withdraw rationale ')
      proposal.confirmation_withdraw
    end
  end


  def export_proposal
     on CmCourseInformationPage do |page|
       page.export_action
     end
  end

  #-----
  private
  #-----

  def checkbox_trans
     { "Yes" => :set, "No" => :clear }
  end

  #COURSE INFORMATION
  def add_joint_offering
    on CmCourseInformationPage do |page|
      if @joint_offering_adding_data == 'auto_lookup'
        page.add_another_course
        page.joint_offering_number.fit @joint_offering_number
        page.auto_lookup @joint_offering_number unless @joint_offering_number.nil?
      end

      if @joint_offering_adding_data == 'adv_given_name' or @joint_offering_adding_data == 'adv_course_code' or @joint_offering_adding_data == 'adv_plain_text'
        page.add_another_course
        page.joint_offering_advanced_search
        page.adv_given_name.wait_until_present
        page.adv_course_code.fit @joint_offering_course_code if @joint_offering_adding_data == 'adv_course_code'
        page.adv_given_name.fit @joint_offering_name if @joint_offering_adding_data == 'adv_given_name'
        page.adv_plain_text_description.fit @joint_offering_description if @joint_offering_adding_data == 'adv_plain_text'
        page.adv_search
        page.adv_return_value @joint_offering_course_code
      end
    end
  end

  def add_instructor
    on CmCourseInformationPage do |page|
      if instructor_adding_method == 'advanced' or instructor_adding_method == 'adv_name' or instructor_adding_method == 'adv_username'
        page.instructor_advanced_search
        page.adv_name.fit @instructor_last_name if instructor_adding_method == 'adv_name' or instructor_adding_method == 'advanced'
        page.adv_username.fit @instructor_username if instructor_adding_method == 'adv_username' or instructor_adding_method == 'advanced'
        page.adv_search
        page.adv_return_value_instructor @instructor_display_name
      end

      if instructor_adding_method == 'auto_lookup'
        page.instructor_name.fit @instructor_last_name
        page.auto_lookup @instructor_display_name unless @instructor_display_name.nil?

      end

      # DUE TO RICE ISSUE CODE NEEDS TO WAIT FOR FIELD TO DISPLAY THE RETURN RESULTS FOR ADV SEARCH
      # So we wait until the name field = returned value
      page.instructor_name.text == @instructor_display_name

      page.instructor_add unless @instructor_last_name.nil?
    end
  end


end #class




