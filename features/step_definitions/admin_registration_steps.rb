When /^I attempt to load a student by valid student Id and term code$/ do
  @admin_reg = create AdminRegistrationData
end

Then /^the student information and term description is displayed$/ do
  on AdminRegistration do |page|
    page.get_student_info.should match /BOWEN, EILEEN \(#{@admin_reg.student_id.upcase}\)/
    page.get_term_info.should match /#{@admin_reg.term_description}/
  end
end

Then /^I am able to enter a course code for registration$/ do
  on AdminRegistration do |page|
    page.course_code_input.nil?.should be_false

    page.student_term_go
  end
end

When /^I attempt to load a student by invalid student Id$/ do
  @admin_reg = create AdminRegistrationData, :student_id=> "student1"
end

Then /^a validation error message is displayed stating "([^"]+)"$/ do |exp_msg|
  on AdminRegistration do |page|
    page.get_student_term_error_msg( "student").should match /#{exp_msg}/

    page.student_term_go
  end
end

When /^I attempt to load a Term by valid term Id for student with no registered courses$/ do
  @admin_reg = create AdminRegistrationData, :student_id => "KS-10296", :term_code => "201208"
end

When /^I attempt to load a Term by valid term Id$/ do
  @admin_reg = create AdminRegistrationData, :term_code => "201208", :term_description => "Fall 2012"
end

Then /^term description is displayed$/ do
  on(AdminRegistration).get_change_term_info_message.should == @admin_reg.term_description
end

When /^I attempt to load a Term by invalid term Id$/ do
  @admin_reg = create AdminRegistrationData, :term_code=> "558899"
end

Then /^an error message is displayed stating "(.*?)"$/ do |exp_msg|
  on AdminRegistration do |page|
    page.get_student_term_error_msg( "term").should match /#{exp_msg} #{@admin_reg.term_code}/

    #Needed to get the page out of a dirty state
    page.term_code_input.set "201401"
    page.student_term_go
  end
end

When /^I attempt to load a Term without entering a term Id$/  do
  @admin_reg = create AdminRegistrationData, :term_code => " "
end

Then /^a required error message is displayed stating "(.*?)"$/ do |exp_msg|
  on AdminRegistration do |page|
    page.get_student_term_error_msg( "term").should match /#{exp_msg}/

    #Needed to get the page out of a dirty state
    page.term_code_input.set "201401"
    page.student_term_go
  end
end

And /^the registered courses are populated$/ do
  on(AdminRegistration).registered_courses_rows.empty?.should be_false
end

And /^the total number of credits for registered courses are displayed$/ do
  on AdminRegistration do |page|
    credits = 0
    page.registered_courses_rows.each do |row|
      credits += page.get_registered_course_credits(row).to_i
    end
    page.registered_courses_header.should match /#{credits.to_s}/

    page.student_term_go
  end
end

Then /^the registered courses are not populated$/ do
  on(AdminRegistration).registered_courses_rows.empty?.should be_true
end

Then /^the default sort order for registered courses should be on course code$/ do
  on(AdminRegistration).get_registered_course_code_sort.should match /Course Code \(Section\)/
end

And /^I attempt to load a Term by valid term Id for student with waitlisted courses$/ do
  @admin_reg = create AdminRegistrationData, :student_id=> "KS-7185", :term_code=> "201208"
end

And /^the waitlisted courses are populated$/ do
  on(AdminRegistration).waitlisted_courses_rows.empty?.should be_false
end

And /^the total number of credits for waitlisted courses are displayed$/ do
  on AdminRegistration do |page|
    credits = 0
    page.waitlisted_courses_rows.each do |row|
      credits += page.get_waitlisted_course_credits(row).to_i
    end
    page.waitlisted_courses_header.should match /#{credits.to_s}/
  end
end

Then /^the waitlisted courses are not populated$/ do
  on(AdminRegistration).waitlisted_courses_rows.empty?.should be_true
end

Then /^the default sort order for waitlisted courses should be on course code$/ do
  on(AdminRegistration).get_waitlisted_course_code_sort.should match /Course Code \(Section\)/
end

When /^I enter a valid course code for term$/ do
  @admin_reg = create AdminRegistrationData, :term_code=> "201201"
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code => "ENGL201",
                                                             :description => "Inventing Western Literature: Ancient and Medieval Traditions")
end

When /^I enter a valid section for course code$/ do
  @admin_reg = create AdminRegistrationData, :term_code=> "201201"
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject)
end

Then /^the course description is displayed$/ do
  on AdminRegistration do |page|
    page.course_addline_btn.focus
    page.loading.wait_while_present
    page.get_course_description_message(1).should == @admin_reg.course_section_codes[0].description

    page.student_term_go
  end
end

When /^I enter an invalid course code for term$/ do
  @admin_reg = create AdminRegistrationData
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL299")
end

Then /^the error message for course code is displayed stating "([^"]*)"$/ do |exp_msg|
  on AdminRegistration do |page|
    page.course_register
    page.loading.wait_while_present
    page.reg_for_error_message.text.should match /#{exp_msg}/

    page.student_term_go
  end
end

When /^I enter an invalid course code$/ do
  @admin_reg = create AdminRegistrationData
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENG299L")
end

When /^I enter an invalid section$/ do
  @admin_reg = create AdminRegistrationData
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :section=> "100d")
end

Then /^the section code should appear on the confirm registration dialog$/ do
  on AdminRegistration do |page|
    page.course_register
    page.loading.wait_while_present
    page.get_confirm_registration_row("#{@admin_reg.course_section_codes[0].course_code} (#{@admin_reg.course_section_codes[0].section})").nil?.should be_false
    page.cancel_registration

    page.student_term_go
  end
end

When /^I select the course that a student will be registered for$/ do
  @admin_reg = create AdminRegistrationData
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code => "ENGL201")
end

Then /^I should be able to select additional courses for the student$/ do
  on AdminRegistration do |page|
    @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "CHEM241",
                                                               :section=> "1002", :add_new_line => true)
    page.get_last_course_code_value.should match /#{@admin_reg.course_section_codes[1].course_code}/i
    page.get_last_section_value.should match /#{@admin_reg.course_section_codes[1].section}/i

    @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL312",
                                                               :section=> "1003", :add_new_line => true)
    page.get_last_course_code_value.should match /#{@admin_reg.course_section_codes[2].course_code}/i
    page.get_last_section_value.should match /#{@admin_reg.course_section_codes[2].section}/i

    @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "PHYS739",
                                                               :section=> "1004", :add_new_line => true)
    page.get_last_course_code_value.should match /#{@admin_reg.course_section_codes[3].course_code}/i
    page.get_last_section_value.should match /#{@admin_reg.course_section_codes[3].section}/i

    page.student_term_go
  end
end

When /^I select additional courses to be registered for$/ do
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "CHEM241",
                                                             :section=> "1002", :add_new_line => true,
                                                             :description => "Organic Chemistry II")
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL312",
                                                             :section=> "1003", :add_new_line => true,
                                                             :description => "Romantic to Modern British Literature")
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "PHYS739",
                                                             :section=> "1004", :add_new_line => true,
                                                             :description => "Seminar in Theoretical Solid State Physics")
end

Then /^I should be able to remove all the additional courses$/ do
  on AdminRegistration do |page|
    page.course_delete_btn(0).visible?.should be_true

    course_descr = @admin_reg.course_section_codes[1].description
    @admin_reg.course_section_codes[1].delete :index => "1", :navigate_to_page => false
    page.get_course_code_value(course_descr).nil?.should be_true
    page.get_section_value(course_descr).nil?.should be_true

    course_descr = @admin_reg.course_section_codes[2].description
    @admin_reg.course_section_codes[2].delete :index => "2", :navigate_to_page => false
    page.get_course_code_value(course_descr).nil?.should be_true
    page.get_section_value(course_descr).nil?.should be_true

    course_descr = @admin_reg.course_section_codes[1].description
    @admin_reg.course_section_codes[1].delete :index => "1", :navigate_to_page => false
    page.get_course_code_value(course_descr).nil?.should be_true
    page.get_section_value(course_descr).nil?.should be_true

    page.course_delete_btn(0).exist?.should be_false

    page.student_term_go
  end
end

When /^I attempt to register a student for a course with default values for Credit and Registration Options$/ do
  @admin_reg = create AdminRegistrationData
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL101",
                                                             :section=> "1002", :requested_credits => "3.0",
                                                             :requested_reg_options => "Letter", :register =>true)
end

Then /^the default values are displayed when confirming registration$/ do
  on AdminRegistration do |page|
    page.get_confirm_course_credits(@admin_reg.course_section_codes[0].course_code).should match /#{@admin_reg.course_section_codes[0].requested_credits}/
    page.get_confirm_course_reg_options(@admin_reg.course_section_codes[0].course_code).should match /#{@admin_reg.course_section_codes[0].requested_reg_options}/
    page.cancel_registration

    page.student_term_go
  end
end

When /^I attempt to register a student for a course$/ do
  @admin_reg = create AdminRegistrationData
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "CHEM241",
                                                             :section=> "1002", :register => true, :requested_effective_date => right_now[:date_w_slashes])
end

Then /^the effective date should default to system date$/ do
  on AdminRegistration do |page|
    page.get_confirm_course_effective_date(@admin_reg.course_section_codes[0].course_code).should match /#{@admin_reg.course_section_codes[0].requested_effective_date}/
    page.cancel_registration

    page.student_term_go
  end
end

When /^I attempt to register a student for a cancelled course section$/ do
  @admin_reg = create AdminRegistrationData, :term_code=> "201201"
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL101",
                                                             :section=> "1003", :register => true)
end

When /^an error message appears indicating that the section was cancelled for the selected term$/ do
  section = @admin_reg.course_section_codes[0].section
  course = @admin_reg.course_section_codes[0].course_code
  on AdminRegistration do |page|
    page.get_cancelled_section_error_message.should match /Section #{section}.*for #{course}.*was cancelled for the selected term./

    page.student_term_go
  end
end

When /^I change the effective date of a course before confirming registration$/ do
  @admin_reg = create AdminRegistrationData, :student_id => "KS-2016"
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL101",
                                                             :section=> "1003", :register => true)

  @admin_reg.course_section_codes[0].confirm_registration :confirm_course_effective_date => tomorrow[:date_w_slashes]
end

Then /^the registration date is displayed as a float\-over message$/ do
  on AdminRegistration do |page|
    page.get_transaction_date_float(right_now[:date_w_slashes]).nil?.should be_false

    page.student_term_go
  end
end

When /^I register a student for a course that passed eligibility$/ do
  @admin_reg = create AdminRegistrationData
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "CHEM241",
                                                             :section=> "1001", :register => true,
                                                             :confirm_registration => true)
end

Then /^a message indicating the course has been successfully registered appears$/ do
  on AdminRegistration do |page|
    page.get_registration_results_success.should match /Course was successfully registered./
  end
end

Then /^the student is registered for the course$/ do
  on AdminRegistration do |page|
    page.get_registered_course("#{ @admin_reg.course_section_codes[0].course_code} (#{ @admin_reg.course_section_codes[0].section})").nil?.should be_false

    page.student_term_go
  end
end

When /^I attempt to register a student for a course that failed eligibility$/ do
  @admin_reg = create AdminRegistrationData, :student_id => "ks-2040"
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL101",
                                                             :section=> "1002")

  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL101",
                                                             :section=> "1003", :add_new_line => true, :register => true)
  @admin_reg.course_section_codes[1].confirm_registration :confirm_registration => true, :allow_registration => false,
                                                          :deny_registration => false
end

Then /^a message indicating failed eligibility for course registration appears$/ do
  on AdminRegistration do |page|
    result_warning = page.get_registration_results_warning
    result_warning.should match /Day and Time schedule conflict/

    if result_warning =~ /([A-Z]{4}[0-9]{3}[A-Z]*\s\([0-9]{4}\))/
      @course_and_section = $1
    end
  end
end

When /^I register a student for a course$/ do
  @admin_reg = create AdminRegistrationData, :student_id => "ks-2039"
  on AdminRegistration do |page|
    @total_credits = 0
    page.registered_courses_rows.each do |row|
      @total_credits += page.get_registered_course_credits(row).to_i
    end
  end
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL201",
                                                             :section=> "1001", :register => true,
                                                             :confirm_registration => true)
end

Then /^the student's registered courses credit total for the term should be updated$/ do
  on AdminRegistration do |page|
    @updated_credits = 0
    page.registered_courses_rows.each do |row|
      @updated_credits += page.get_registered_course_credits(row).to_i
    end
    @updated_credits.equal?(@total_credits).should be_false

    page.student_term_go
  end
end

When /^I open the term for registration in the Academic Calendar$/ do
  @calendar = make AcademicCalendar, :year => "2014", :name => "2014-2015 Academic Calendar"

  term = make AcademicTermObject, :parent_calendar => @calendar, :term => "Summer I", :term_type => "Summer 1"
  @calendar.terms << term

  @calendar.terms[0].edit :defer_save => true

  keydategroup = make KeyDateGroupObject, :key_date_group_type=> "Registration"
  keydates = []
  keydates << (make KeyDateObject, :key_date_type => "Registration Open", :start_date => "04/05/#{@calendar.year}",
                    :end_date => "")


  keydategroup.key_dates = keydates

  @calendar.terms[0].add_key_date_group keydategroup
end

And /^I attempt to load a Term by valid Term Id for a student with no Registered or Wait-listed courses$/ do
  @admin_reg = create AdminRegistrationData, :student_id => "KS-10296", :term_code => "201405"
end

Then /^no failed term eligibility warning message is displayed$/ do
  on AdminRegistration do |page|
    page.loading.wait_while_present
    page.term_warning_message.exists?.should be_false

    page.student_term_go
  end
end

When /^I decide to continue with the selected term$/ do
  on AdminRegistration do |page|
    page.change_term_input.set "201200"
    page.change_term_go
    page.loading.wait_while_present
    page.confirm_term_popup_section.visible?.should == true
    page.confirm_term_continue
  end
end

When /^I attempt to load a Term by valid Term Id for student with Registered or Wait-listed courses$/ do
  @admin_reg = create AdminRegistrationData
end

Then /^a warning message along with the Registered and Wait-listed courses are displayed$/ do
  on AdminRegistration do |page|
    page.get_term_warning_message.should match /Registration for #{@admin_reg.term_description} is not currently open/
    page.reg_for_section.visible?.should == true

    page.student_term_go
  end
end

When /^I register a student for courses with more credits than the allowed maximum$/ do
  @admin_reg = create AdminRegistrationData, :student_id => "KS-2042"
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL101",
                                                             :section=> "1002", :register => true,
                                                             :confirm_registration => true)
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL101",
                                                             :section=> "1003", :register => true,
                                                             :confirm_registration => true)
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL101",
                                                             :section=> "1004", :register => true,
                                                             :confirm_registration => true)
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL101",
                                                             :section=> "1005", :register => true,
                                                             :confirm_registration => true)
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL101",
                                                             :section=> "1006", :register => true,
                                                             :confirm_registration => true)
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL101",
                                                             :section=> "1020", :register => true,
                                                             :confirm_registration => true)
end

And /^I register the student for a course with a time conflict$/ do
  @admin_reg.create

  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL101",
                                                             :section=> "1021")

  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "CHEM272",
                                                             :section=> "1001", :add_new_line => true, :register => true)
  @admin_reg.course_section_codes[7].confirm_registration :confirm_registration => true, :allow_registration => false,
                                                          :deny_registration => false
end

When /^I attempt to register the student for a course with a time conflict$/ do
  @admin_reg = create AdminRegistrationData, :student_id => "KS-2037"

  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL101",
                                                             :section=> "1002")

  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL101",
                                                             :section=> "1003", :add_new_line => true, :register => true)
  @admin_reg.course_section_codes[1].confirm_registration :confirm_registration => true, :allow_registration => false,
                                                          :deny_registration => false
end

When /^I want to register a student for a course with a time conflict$/ do
  @admin_reg = create AdminRegistrationData, :student_id => "KS-2043"

  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL101",
                                                             :section=> "1002")

  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL101",
                                                             :section=> "1003", :add_new_line => true, :register => true)
  @admin_reg.course_section_codes[1].confirm_registration :confirm_registration => true, :allow_registration => false,
                                                          :deny_registration => false
end

Then /^multiple failed eligibility messages appear$/ do
  on AdminRegistration do |page|
    result_warning = page.get_registration_results_warning
    result_warning.should match /Day and Time schedule conflict/
    result_warning.should match /Reached maximum credit limit/

    page.deny_registration_issue

    page.student_term_go
  end
end

Then /^the student is not registered for the course$/ do
  on AdminRegistration do |page|
    page.get_registered_course(@course_and_section).nil?.should be_true

    page.student_term_go
  end
end

When /^I deny the course for registration$/ do
  on AdminRegistration do |page|
    page.loading.wait_while_present
    page.deny_registration_issue
  end
end

When /^I allow the course for registration$/ do
  on AdminRegistration do |page|
    page.confirm_registration_issue
    page.loading.wait_while_present
    page.dismiss_registration_result
  end
end

When /^I attempt to edit a course with default values for Credit and Registration Options$/ do
  @admin_reg = create AdminRegistrationData, :student_id => "KS-11898", :term_code => "201208"
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL101",
                                                             :section=> "1002", :course_default_credits => "3.0",
                                                             :course_default_reg_options => "Letter", :register => true,
                                                             :confirm_registration => true)

  @admin_reg.course_section_codes[0].edit_course :save_edit => false, :cancel_edit => false
end

Then /^the default values are displayed on edit course dialog$/ do
  on AdminRegistration do |page|
    page.get_edit_course_credits.should match /#{@admin_reg.course_section_codes[0].requested_credits}/
    page.get_edit_course_reg_options.should match /#{@admin_reg.course_section_codes[0].requested_reg_options}/
    page.cancel_edited_course

    page.student_term_go
  end
end

When /^I attempt to edit a registered course$/ do
  @admin_reg = create AdminRegistrationData, :student_id => "KS-2050", :term_code=> "201208"
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL304",
                                                             :section=> "1001", :register => true,
                                                             :confirm_registration => true)
  on(AdminRegistration).dismiss_registration_result
end

Then /^I save the edited course with no effective date$/ do
  @admin_reg.course_section_codes[0].edit_course :edit_course_effective_date => " "
end

Then /^a message appears indicating that the effective date is required$/ do
  on AdminRegistration do |page|
    page.loading.wait_while_present
    page.edit_course_dialog_error_msg.should match /Effective date is required/
    page.cancel_edited_course

    page.student_term_go
  end
end

Then /^I save the changes made to Registration Options and Effective Date$/ do
  @admin_reg.course_section_codes[0].edit_course :edit_course_effective_date => in_a_week[:date_w_slashes],
                                                 :edit_course_reg_options => "Audit"
end

Then /^a message appears indicating that the course has been updated successfully$/ do
  on AdminRegistration do |page|
    page.loading.wait_while_present
    page.confirm_registration_issue
    page.loading.wait_while_present
    page.get_registration_results_success.should match /Course was successfully updated/

    page.student_term_go
  end
end

Given(/^I have registered a student for a course that needed to be allowed in the term$/) do
  @admin_reg = create AdminRegistrationData, :student_id => "KS-7196", :term_code=> "201208"
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL304",
                                                             :section=> "1001", :register => true,
                                                             :confirm_registration => true)
  on AdminRegistration do |page|
    sleep 5
    if page.confirm_registration_issue_btn.exists?
      puts "needed to click again"
      page.confirm_registration_issue
    end
  end
end

When(/^I attempt to drop the registered course$/) do
  @admin_reg.course_section_codes[0].delete_course :confirm_drop => true
end

Then(/^a message appears indicating that I need to allow or deny the drop of the course$/) do
  on AdminRegistration do |page|
    page.loading.wait_while_present
    page.get_registration_results_warning.should match /Registration is not currently open/
    page.deny_registration_issue

    page.student_term_go
  end
end

When /^I attempt to drop a registered course$/ do
  @admin_reg = create AdminRegistrationData, :student_id => "KS-2020"
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL201",
                                                             :section=> "1001", :register => true,
                                                             :confirm_registration => true ,
                                                             :course_default_effective_date => tomorrow[:date_w_slashes])
  on AdminRegistration do |page|
    # page.confirm_registration_issue
    page.loading.wait_while_present
    page.dismiss_registration_result
  end

  @admin_reg.course_section_codes[0].delete_course :confirm_drop => true, :effective_date => tomorrow[:date_w_slashes]
end

Then /^the student is no longer registered for the course$/ do
  on(AdminRegistration).get_registered_course("#{ @admin_reg.course_section_codes[0].course_code} (#{ @admin_reg.course_section_codes[0].section})").nil?.should be_true
end

Then /^a message appears indicating that the course has been successfully dropped$/ do
  on AdminRegistration do |page|
    page.get_registration_results_success.should match /Course was successfully dropped/
    page.dismiss_registration_result

    page.student_term_go
  end
end

When /^I register multiple students for the same course$/ do
  course_section_obj = make ARCourseSectionObject, :course_code=> "ENGL202",
                            :section=> "1003", :register => true,
                            :confirm_registration => true ,
                            :course_default_effective_date => tomorrow[:date_w_slashes]

  @admin_reg_student1 = create AdminRegistrationData, :student_id => "KS-2035"
  @admin_reg_student1.add_course_section :course_section_obj => course_section_obj
  on(AdminRegistration).loading.wait_while_present

  @admin_reg_student2 = create AdminRegistrationData, :student_id => "KS-2036"
  @admin_reg_student2.add_course_section :course_section_obj => course_section_obj
  on(AdminRegistration).loading.wait_while_present
end

Then /^the first student is registered for the course$/ do
  @admin_reg_student1.create

  on(AdminRegistration).get_registered_course("#{ @admin_reg_student1.course_section_codes[0].course_code} (#{ @admin_reg_student1.course_section_codes[0].section})").nil?.should be_false
end

Then /^the second student is waitlisted for the course$/ do
  @admin_reg_student2.create

  on(AdminRegistration).get_waitlisted_course("#{ @admin_reg_student2.course_section_codes[0].course_code} (#{ @admin_reg_student2.course_section_codes[0].section})").nil?.should be_false
end

When /^I drop the course for the first student$/ do
  @admin_reg_student1.course_section_codes[0].delete_course :parent => @admin_reg_student1, :navigate_to_page => true,
                                                            :confirm_drop => true, :effective_date => tomorrow[:date_w_slashes]
end

Then /^that student is no longer registered for the course$/ do
  on(AdminRegistration).get_registered_course("#{ @admin_reg_student1.course_section_codes[0].course_code} (#{ @admin_reg_student1.course_section_codes[0].section})").nil?.should be_true
end

Then /^the second student's course has moved from waitlisted to registered$/ do
  @admin_reg_student2.create

  on AdminRegistration do |page|
    page.get_registered_course("#{ @admin_reg_student2.course_section_codes[0].course_code} (#{ @admin_reg_student2.course_section_codes[0].section})").nil?.should be_false
    page.get_waitlisted_course("#{ @admin_reg_student2.course_section_codes[0].course_code} (#{ @admin_reg_student2.course_section_codes[0].section})").nil?.should be_true

    page.student_term_go
  end
end

When /^I edit a registered course by changing the Registration Options$/ do
  @admin_reg = create AdminRegistrationData, :student_id => "KS-2078", :term_code=> "201201"
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL302",
                                                             :section=> "1001", :register => true,
                                                             :confirm_registration => true)

  on AdminRegistration do |page|
    page.loading.wait_while_present
    page.dismiss_registration_result
  end
end

And /^I save the changes made to Registration Options$/ do
  @admin_reg.course_section_codes[0].edit_course :edit_course_reg_options => "Pass/Fail"
end

Then /^the registered course is updated with the new Registration Options$/ do
  on AdminRegistration do |page|
    page.loading.wait_while_present
    page.get_registration_results_success.should match /Course was successfully updated/

    row = page.get_registered_course("#{ @admin_reg.course_section_codes[0].course_code} (#{ @admin_reg.course_section_codes[0].section})")
    page.get_registered_course_reg_options(row).should match /#{@admin_reg.course_section_codes[0].requested_reg_options}/

    page.student_term_go
  end
end

When /^I edit a registered course by assigning more credits than the allowed maximum$/ do
  @admin_reg = create AdminRegistrationData, :student_id => "KS-2034", :term_code=> "201201"
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL468C",
                                                             :section=> "1001", :register => true, :requested_credits => "3.0")
  @admin_reg.course_section_codes[0].confirm_registration :confirm_registration => true,
                                                          :confirm_course_credits => @admin_reg.course_section_codes[0].requested_credits

  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "PHYS499A",
                                                             :section=> "1001", :register => true, :requested_credits => "16.0")
  @admin_reg.course_section_codes[1].confirm_registration :confirm_registration => true,
                                                          :confirm_course_credits => @admin_reg.course_section_codes[1].requested_credits
end

And /^I save the changes made to course credits$/ do
  @admin_reg.course_section_codes[0].edit_course :edit_course_credits => "6.0"
end

And /^I save the changed credits to be more than the allowed maximum$/ do
  @admin_reg.course_section_codes[0].edit_course :edit_course_credits => "6.0"
end

Then /^the registered course is not updated with the new Course Credits$/ do
  on AdminRegistration do |page|
    row = page.get_registered_course("#{ @admin_reg.course_section_codes[0].course_code} (#{ @admin_reg.course_section_codes[0].section})")
    page.get_registered_course_credits(row).should_not match /#{@admin_reg.course_section_codes[0].requested_credits}/
  end
end

And /^a message appears indicating that the updated course failed eligibility$/ do
  on AdminRegistration do |page|
    page.loading.wait_while_present
    page.get_registration_results_warning.should match /Reached maximum credit limit/

    page.student_term_go
  end
end

When /^I register a student for a course with a time conflict$/ do
  @admin_reg = create AdminRegistrationData, :student_id => "KS-2045", :term_code=> "201201"
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL468C",
                                                             :section=> "1001", :register => true, :requested_credits => "3.0")
  @admin_reg.course_section_codes[0].confirm_registration :confirm_registration => true,
                                                          :confirm_course_credits => @admin_reg.course_section_codes[0].requested_credits
end

And /^I add registered courses by selecting more credits than the allowed maximum$/ do
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL468C",
                                                             :section=> "1001", :register => true, :requested_credits => "4.0")
  @admin_reg.course_section_codes[1].confirm_registration :confirm_registration => true,
                                                          :confirm_course_credits => @admin_reg.course_section_codes[1].requested_credits

  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "PHYS499A",
                                                             :section=> "1001", :register => true, :requested_credits => "16.0")
  @admin_reg.course_section_codes[2].confirm_registration :confirm_registration => true,
                                                          :confirm_course_credits => @admin_reg.course_section_codes[2].requested_credits
end

When /^I attempt to edit a registered course by adding more credits than the allowed maximum$/ do
  @admin_reg = create AdminRegistrationData, :student_id => "KS-2044"
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL468C",
                                                             :section=> "1001", :register => true, :requested_credits => "4.0")
  @admin_reg.course_section_codes[0].confirm_registration :confirm_registration => true,
                                                          :confirm_course_credits => @admin_reg.course_section_codes[0].requested_credits

  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "PHYS499A",
                                                             :section=> "1001", :register => true, :requested_credits => "16.0")
  @admin_reg.course_section_codes[1].confirm_registration :confirm_registration => true,
                                                          :confirm_course_credits => @admin_reg.course_section_codes[1].requested_credits
end

When /^I deny the edited course to be updated$/ do
  on AdminRegistration do |page|
    page.loading.wait_while_present
    page.deny_registration_issue
  end
end

When /^I attempt to edit a registered course by assigning more credits than the allowed maximum$/ do
  @admin_reg = create AdminRegistrationData, :student_id => "KS-2046"
  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "ENGL468C",
                                                             :section=> "1001", :register => true, :requested_credits => "4.0")
  @admin_reg.course_section_codes[0].confirm_registration :confirm_registration => true,
                                                          :confirm_course_credits => @admin_reg.course_section_codes[0].requested_credits

  @admin_reg.add_course_section :course_section_obj => (make ARCourseSectionObject, :course_code=> "PHYS499A",
                                                             :section=> "1001", :register => true, :requested_credits => "16.0")
  @admin_reg.course_section_codes[0].confirm_registration :confirm_registration => true,
                                                          :confirm_course_credits => @admin_reg.course_section_codes[0].requested_credits
end

When /^I allow the edited course to be updated$/ do
  on AdminRegistration do |page|
    page.confirm_registration_issue
    page.loading.wait_while_present
  end
end