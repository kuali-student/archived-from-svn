# Helper methods that don't properly belong elsewhere. This is
# a sort of "catch all" Module.
module Workflows

  # Site Navigation helpers...
  def navigate_to_find_course_proposal
    on(CmCurriculumPage).find_a_course_proposal
  end

  def navigate_to_find_course
    on(CmCurriculumPage).find_a_course
  end

  def return_to_cm_home
    on(CmFindACoursePage).cm_home_via_breadcrumb
  end

  def navigate_rice_to_cm_home
    on CmRicePage do |create|
      #puts @assessment_a_f.inspect
      create.curriculum_management
    end
  end

  def navigate_to_lo_categories
    on(CmCurriculumPage).learning_objective_categories
  end

  def navigate_to_create_course_proposal
    on(CmCurriculumPage).create_a_course
  end

  def navigate_to_cm_home
    on(CmCourseInformationPage).cm_home_via_breadcrumb
    on CmCourseInformationPage do |page|
      if (page.alert.exists?)
        page.alert.ok
      end
    end
  end

  def navigate_to_functional_home
    on(CmCourseInformationPage).functional_home_via_breadcrumb
  end

  def determine_save_action
    on CmCourseInformationPage do |create|
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

    visit KSFunctionalHomePage do |page|
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

  def course_number_generator(subject_code)
    given_course_number = "#{(901..999).to_a.sample}"
    course_list = make CmCourseObject, :search_term => "#{subject_code}9", :course_code => "#{subject_code}9"
    course_list.search_for_course
    list_course_code = (on CmFindACoursePage).results_list_course_code
    start_course_code = "#{subject_code}#{given_course_number}"
    while list_course_code.include? start_course_code do
      given_course_number = "#{(901..999).to_a.sample}"
      start_course_code = "#{subject_code}#{given_course_number}"
    end
    navigate_to_functional_home
    given_course_number
  end

end