# Helper methods that don't properly belong elsewhere. This is
# a sort of "catch all" Module.
module Workflows

  # Site Navigation helpers...
  def navigate_to_find_course_proposal
    on(CmCurriculum).find_a_course_proposal
  end

  def navigate_to_find_course
    on(CmCurriculum).find_a_course
  end

  def return_to_cm_home
    on(CmFindACoursePage).cm_home_via_breadcrumb
  end

  def navigate_rice_to_cm_home
    on CmRice do |create|
      #puts @assessment_a_f.inspect
      create.curriculum_management
    end
  end

  def navigate_to_lo_categories
    on(CmCurriculum).learning_objective_categories
  end

  def navigate_to_create_course_proposal
    on(CmCurriculum).create_a_course
  end

  def navigate_to_cm_home
    on(CmCourseInformation).cm_home_via_breadcrumb
    on CmCourseInformation do |page|
      if (page.alert.exists?)
        page.alert.ok
      end
    end
  end

  def navigate_to_functional_home
    on(CmCourseInformation).functional_home_via_breadcrumb
  end

  def determine_save_action
    on CmCourseInformation do |create|
      create.save_progress if create.logged_in_user.downcase == "alice"
      create.save_progress if create.logged_in_user.downcase == "martha"
      create.save_progress if create.logged_in_user.downcase == "carol"
      create.save_progress if create.logged_in_user.downcase == "earl"
      create.save_progress if create.logged_in_user.downcase == "erin"
      create.save_and_continue if create.logged_in_user.downcase == "fred"
    end
  end

  def determine_edit_action
    #if current page is find a proposal click the pencil icon
    on CmReviewProposal do |page|
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

  def determine_reviewer(subject_code)
    case subject_code
      when "ENGL"
        #log_in 'carol','carol'
        log_in 'martha','martha'
      when "CHEM"
        #log_in 'carl','carl'
        log_in 'martha','martha'
     end
  end

  def log_in(user, pwd)
    current_user = ""

    visit KSFunctionalHome do |page|
      current_user = page.current_logged_in_user_id
      if current_user == :no_user
        page.login_with user, pwd
      elsif current_user != user
        page.logout
        visit Login do |page|
          page.login_with user, pwd
        end
      end
    end
  end

end