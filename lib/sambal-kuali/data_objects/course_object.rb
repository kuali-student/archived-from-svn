class CmCourseObject < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows
  include Utilities

  attr_accessor :course_code,
                :search_term,
                # COURSE INFORMATION
                :subject_code,
                :course_number,
                :course_title,
                :transcript_course_title,
                :description,
                # GOVERNANCE
                :campus_location,
                :curriculum_oversight,
                # COURSE LOGISTICS
                :assessment_scale,
                :audit,
                :pass_fail_transcript_grade,
                :final_exam_status,
                :outcome_list,
                :format_list,
                #Learning Objectives
                :learning_objective_list,
                #Course Requisites
                :course_requisite_list,
                # ACTIVE DATES
                :start_term,
                :pilot_course,
                :course_state






  def initialize(browser, opts={})
    @browser = browser
    defaults = {

    }
    set_options(defaults.merge(opts))

  end


  def search_for_course
    navigate_rice_to_cm_home
    navigate_to_find_course
    on CmFindACoursePage do |search|
      search.course_code.set search_term
      search.find_courses
    end
  end


  def view_course
    search_for_course
    on CmFindACoursePage do |view|
      view.view_course(@course_code)
    end
  end


  def export_course
    on CmReviewProposalPage do |page|
      page.export_action
    end
  end

  def get_course_version_info(opts={})
    index = opts[:version_index]
    on(CmReviewProposalPage).lookup_version_history
    on CmCourseVersionHistoryPage do |page|
      version = page.version_history_version(index).text
      status = page.version_history_courseStatus(index).text
      start_term = page.version_history_startTerm(index).text
      end_term = page.version_history_endTerm(index).text
      return version, status, start_term, end_term
    end
  end

  def close_version_history_dialog
    on CmCourseVersionHistoryPage do |page|
      page.close_history_view
      page.alert.ok if page.alert.exists?
    end
  end
end


