class CourseSearchResults < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows
  include Comparable

  COURSE_ARRAY = 0
  COURSE_CODE = 0
  COURSE_NAME = 1
attr_accessor :course_code,
                :credit,
                :notes,
                :planned_term,
                :term,
                :term_select,
                :course_desc,
                :course_name,
                :search_text,
                :description,
                :requisite,
                :scheduled_terms,
                :projected_terms,
                :gened_requirements,
                :subject,
                :gened_code,
                :gened_course,
                :course_level,
                :course_offering_description_list,
                :state,
                :message_status,
                :color,
                :notes_update

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :course_code=>"BSCI430",
        :credit=>3,
        :notes=>"#{random_alphanums(20).strip}_pub",
        :planned_term=>"2014Fall",
        :term=> "Spring 2014",
        :term_select=>nil,
        :course_desc =>nil,
        :course_name =>nil,
        :search_text =>nil,
        :description=>"history",
        :requisite=>"None",
        :scheduled_terms=>"SP 14",
        :projected_terms=>"Check",
        :gened_requirements=>"General",
        :subject=>"English",
        :gened_code=>"DSSP",
        :gened_course=>"General Education: Scholarship in Practice",
        :course_level=> '3',
        :course_prefix=> 'ENGL',
        :state=>'Planned',
        :color=>'transparent',
        :message_status=>'Section 1012 has been suspended.',
        :notes_update=>'UPDATED',
         course_offering_description_list:[
            (make CourseOfferingDescriptionObject, :courseofferingdescription_level => 0),
            (make CourseOfferingDescriptionObject, :courseofferingdescription_level => 1)

        ]





    }
    options = defaults.merge(opts)
    set_options(options)
  end

 def select_facet(facet_type)
   on CourseSearch do |page|
     page.gened_checkbox_click(@gened_course)          if facet_type=="gen_ed"
     page.term_checkbox_click(@scheduled_terms)                         if facet_type=="term"
     page.credits_checkbox_click(@credit)                       if facet_type=="credit"
     page.courselevel_checkbox_click(@course_level)                   if facet_type=="course_level"
     page.courseprefix_chekbox_click(@subject,@course_prefix)                 if facet_type=="course_prefix"
    end
 end
  def navigate_course_detail_page
    on CourseSearch  do |page|
       page.course_code_result_link(@course_code).click
    end
  end

  def navigate_course_section_page
    on CourseDetailPage do |page|
      page.section_details.click
    end
  end

  def remove_code_from_term
    # navigate_to_course_planner_home
    on CoursePlannerPage do |page|
      begin
        #page.course_planner_header.wait_until_present
        sleep 5
        page.course_code_term(@planned_term, @course_code) != nil?
        page.course_code_term_click(@planned_term, @course_code)
        page.course_code_delete_click
        page.delete_course.wait_until_present
        page.delete_course_click
        page.refresh
      rescue
        #means that course was NOT found, BUT be careful as the rescue will hide errors if they occur in cleanup steps
      end


    end
  end


  def remove_code_from_planned_backup


    on CoursePlannerPage do |page|

      begin
        #page.course_planner_header.wait_until_present
        page.planner_courses_detail_list.wait_until_present
        # page.course_code_term(@course_search_result.planned_term, @course_search_result.course_code) != nil?
        # puts page.course_code_term(@course_search_result.planned_term, @course_search_result.course_code)
        # page.course_code_term_click(@course_search_result.planned_term, @course_search_result.course_code)
        page.course_code_term(@planned_term, @course_code) != nil?
        puts page.course_code_term(@planned_term, @course_code)
        page.course_code_term_click(@planned_term, @course_code)
        page.course_code_delete_click
        page.delete_course.wait_until_present
        page.delete_course_click
        page.refresh
      rescue
        #means that course was NOT found, BUT be careful as the rescue will hide errors if they occur in cleanup steps
      end


      begin
        #page.course_planner_header.wait_until_present
        page.planner_courses_detail_list.wait_until_present
        # page.course_code_term_backup(@course_search_result.planned_term, @course_search_result.course_code) != nil?
        # puts page.course_code_term_backup(@course_search_result.planned_term, @course_search_result.course_code)
        # page.course_code_term_click_backup(@course_search_result.planned_term, @course_search_result.course_code)
        page.course_code_term_backup(@planned_term, @course_code) != nil?
        puts page.course_code_term_backup(@planned_term, @course_code)
        page.course_code_term_click_backup(@planned_term, @course_code)

      page.course_code_delete_click
        page.delete_course.wait_until_present
        page.delete_course_click
        page.refresh


      rescue
        #   puts "the rescuer"
        #means that course was NOT found, BUT be careful as the rescue will hide errors if they occur in cleanup steps
      end
    end

  end

  def remove_course_from_plan_or_backup
    on CoursePlannerPage do |page|

      begin
        #page.course_planner_header.wait_until_present
        page.planner_courses_detail_list.wait_until_present
        page.course_code_term(@course_search_result.planned_term, @course_search_result.course_code) != nil?
        puts page.course_code_term(@course_search_result.planned_term, @course_search_result.course_code)
        page.course_code_term_click(@course_search_result.planned_term, @course_search_result.course_code)
        page.course_code_delete_click
        page.delete_course.wait_until_present
        page.delete_course_click
        page.refresh
      rescue
        #means that course was NOT found, BUT be careful as the rescue will hide errors if they occur in cleanup steps
      end


      begin
        #page.course_planner_header.wait_until_present
        page.planner_courses_detail_list.wait_until_present
        if   page.course_code_term_backup(@course_search_result.planned_term, @course_search_result.course_code) != nil?
          puts page.course_code_term_backup(@course_search_result.planned_term, @course_search_result.course_code)
          page.course_code_term_click_backup(@course_search_result.planned_term, @course_search_result.course_code)
          page.course_code_delete_click
          page.delete_course.wait_until_present
          page.delete_course_click
          page.refresh
        end

      rescue
        #   puts "the rescuer"
        #means that course was NOT found, BUT be careful as the rescue will hide errors if they occur in cleanup steps
      end
    end


  end
  def course_search_to_planner
    on CourseSearch  do |page|
      page.plan_page_click
    end
    on CoursePlannerPage do |page|
      page.course_planner_header.wait_until_present
      remove_code_from_term
      page.course_page_click
    end
  end

  def verify_saved_course_code_notes
    on CoursePlannerPage do |page|
      page.course_page_click
      page.plan_page_click
      page.course_planner_header.wait_until_present
      page.info_icon(@planned_term, @course_code).exists?.should == true
      page.course_code_term_click(@planned_term, @course_code)
      page.view_course_summary_click
      page.close_popup.wait_until_present
    end
  end

  def add_course_to_term
    navigate_to_maintenance_portal
    navigate_to_course_planner_home
    on CoursePlannerPage do |page|
      remove_code_from_term
      page.add_to_term(@planned_term)
      page.course_code_text.wait_until_present
      page.course_code_text.set @course_code
      page.credit.set @credit
      page.notes.set @notes
      page.add_to_plan
      puts page.growl_text
    end
  end

  def edit_plan_item_verify_notes
    on CoursePlannerPage do |page|
      sleep 2
      page.course_code_term_click(@planned_term, @course_code)
      page.edit_plan_item_click
    end
  end

  def edit_plan_item
    on CoursePlannerPage do|page|
      sleep 2
      page.course_code_term_click(@planned_term, @course_code)
      page.edit_plan_item_click
      page.close_popup.wait_until_present
      page.notes.set @notes
      page.save_click
      sleep 2
      page.course_code_term_click(@planned_term, @course_code)
      page.view_course_summary_click
    end
  end

  def set_search_entry
    on CourseSearch do |page|
      page.search_for_course.set @course_code
      sleep 5
      page.search
    end
  end


  def course_search (text=@course_code, term_select=@term_select)
    navigate_to_maintenance_portal
    navigate_to_course_search_home
    on CourseSearch do |page|
      sleep 5
      page.search_for_course.wait_until_present
      #page.search_for_course.send_keys([:control, 'a'])
      page.search_for_course.set text
      if @term_select != nil
        page.search_term_select.select term_select
      end
      page.search
    end
  end

  def clear_facets
    on CourseSearch do |page|
      page.clear_term_facet.click if page.clear_term_facet.text=="Clear"
      page.clear_gened_facet.click if page.clear_gened_facet.text=="Clear"
      page.clear_credit_facet.click if page.clear_credit_facet.text=="Clear"
      page.clear_level_facet.click if page.clear_level_facet.text=="Clear"
      page.clear_courseprefix_facet.click if page.clear_courseprefix_facet.text=="Clear"
    end
  end



  def select_add_to_plan
    on CourseSearch do |page|
      page.plus_symbol.wait_until_present
      page.plus_symbol_popover
     # page.term.wait_until_present
      sleep 15
      #page.refresh
      #page.term.select @term
      #page.add_to_plan_popover.send_keys :tab
      page.term.select @term
      page.add_to_plan_notes.set @notes
      page.add_to_plan_button
      page.plan_page_click
    end
  end

  def select_add_to_plan_backup
    on CourseSearch do |page|
      page.plus_symbol.wait_until_present
      page.plus_symbol_popover
      # page.term.wait_until_present
      sleep 15
      #page.refresh
      #page.term.select @term
      #page.add_to_plan_popover.send_keys :tab
      page.term.select @term
      page.add_to_plan_notes.set @notes
      page.backup_checkbox.set
      page.add_to_plan_button
      page.plan_page_click
    end
  end


  def select_add_to_plan_CDP
    on CourseDetailPage do |page|

    end
  end

#############################

  def course_search_with_search_text(text=@search_text, term_select=@term_select)
    navigate_to_maintenance_portal
    navigate_to_course_search_home
    on CourseSearch do |page|
      sleep 2
      page.search_for_course.set text
      if @term_select != nil
        page.search_term_select.select term_select
      end
      page.search
    end
  end


  def multi_text_search(expected)
    on CourseSearch do |page|
      # Checking for regular expression which needs to be considered as  white space
      puts " Entering Multi Text Search expected = #{expected}"
      if expected =~ Regexp.union("*",";",",","$","#")
        puts "Search Text contain Special Character"
        return false
      end
      split_name = expected.split(' ')
      puts split_name.length
      # if page.result_pagination.exists?
      if  split_name.length > 1
        for index in 0 ... split_name.size
          puts  "split_name[#{index}] = #{split_name[index].inspect}"
          result = check_all_results_data_for_text("#{split_name[index]}",expected)
          if result == false
            return false
          end
          until page.results_list_previous_disabled.exists? do
            sleep(2)
            page.results_list_previous_enabled.wait_until_present
            page.results_list_previous_enabled.click
          end
        end
      else

        check_all_page_data_for_singletext(expected)      # when its Single Word


      end
    end
  end

  def check_all_page_data_for_singletext(single_text)
    on CourseSearch do |page|
      puts "Search Text = #{single_text}"
      pgno = 1
      if page.results_list_next_enabled.exists?

        until page.results_list_next_disabled.exists?
          puts "------ page no = #{pgno}"
          page.single_text_search_results_validation(single_text)
          page.results_list_next_enabled.wait_until_present
          page.results_list_next_click
          pgno = pgno+1
          page.results_list_next_enabled.wait_until_present
        end
      else
        puts "------ page no = #{pgno}"
        ### - The line executes when its Single Page and also Last page in Multi page
        page.single_text_search_results_validation(single_text)
      end

    end
  end



  def check_all_results_data_for_text(split_text,search_FullText)
    on CourseSearch do |page|
      puts "Search Text = #{split_text}"
      pgno = 1
      if page.results_list_next_enabled.exists?
        until page.results_list_next_disabled.exists?
          puts "------ page no = #{pgno}"
          result = page.results_list_validation(split_text,search_FullText)
          if result == false
            return false
          end
          page.results_list_next_enabled.wait_until_present
          page.results_list_next_click
          pgno = pgno+1
          page.results_list_next_enabled.wait_until_present
        end
      else

        puts "------ page no = #{pgno}"
        ### - The line executes when its Single Page and also Last page in Multi page
        page.results_list_validation(split_text,search_FullText)

      end
    end
  end

  def check_all_results_data_for_level(text)
    on CourseSearch do |page|
      puts "Search Text = #{text}"
      pgno = 1
      puts level_digit = text.slice(0)
      if page.results_list_next_enabled.exists?
        until page.results_list_next_disabled.exists?
          puts "------ page no = #{pgno}"
          page.result_list_level(text)
          page.results_list_next_enabled.wait_until_present
          page.results_list_next_click
          pgno = pgno+1
          page.results_list_next_enabled.wait_until_present
        end
      else

        puts "------ page no = #{pgno}"
        page.result_list_level(text)
      end
    end
  end

  # Check that returned results meet search criteria and required courses are
  def check_all_results_data(expected_courses, expected_text)
    on CourseSearch do |page|
      puts "Search Text = #{expected_text}"
      pgno = 1
      puts level_digit = expected_text.slice(0)
      until page.results_list_next_disabled.exists?
        puts "------ page no = #{pgno}"
        pass = page.validate_result_list(expected_courses,expected_text)
        if pass!= true
          return false
        end
        page.results_list_next_enabled.wait_until_present
        page.results_list_next_click
        pgno = pgno+1
        page.results_list_next_enabled.wait_until_present
      end
      puts "------ page no = #{pgno}"
      pass = page.validate_result_list(expected_courses,expected_text)
      if pass!= true
        return false
      end
      if expected_courses == ""
        # only when all expected courses are found does the test pass
        return true
      end
      puts "Not all expected codes found, missing: #{expected_courses}"
      return false
    end
  end

#------------------------- KSAP- 885 ,KSAP- 771 and  US KSAP- 626-----------------------------------------------------------,

  def check_code_ascending_order_in_all_pages
    on CourseSearch do |page|
      pgno = 1
      if page.results_list_next_enabled.exists?
        until page.results_list_next_disabled.exists?
          puts "------ page no = #{pgno}"
          page.check_results_sort_order(true , 0)
          page.results_list_next_enabled.wait_until_present
          page.results_list_next_click
          pgno = pgno+1
          page.results_list_next_enabled.wait_until_present
        end
      else
        puts "------ page no = #{pgno}"
        page.check_results_sort_order(true , 0)
      end
    end
  end

  def check_code_descending_order_in_all_pages
    on CourseSearch do |page|
      pgno = 1
      if page.results_list_next_enabled.exists?
        until page.results_list_next_disabled.exists?
          puts "------ page no = #{pgno}"
          page.check_results_sort_order(false , 0)
          page.results_list_next_enabled.wait_until_present
          page.results_list_next_click
          pgno = pgno+1
          page.results_list_next_enabled.wait_until_present
        end
      else
        puts "------ page no = #{pgno}"
        page.check_results_sort_order(false , 0)
      end
    end
  end

  def check_title_ascending_order_in_all_pages
    on CourseSearch do |page|
      pgno = 1
      if page.results_list_next_enabled.exists?
        until page.results_list_next_disabled.exists?
          puts "------ page no = #{pgno}"
          page.check_results_sort_order(true , 1)
          page.results_list_next_enabled.wait_until_present
          page.results_list_next_click
          pgno = pgno+1
          page.results_list_next_enabled.wait_until_present
        end
      else
        puts "------ page no = #{pgno}"
        page.check_results_sort_order(true ,1)
      end
    end
  end




  def check_title_descending_order_in_all_pages
    on CourseSearch do |page|
      pgno = 1
      if page.results_list_next_enabled.exists?
        until page.results_list_next_disabled.exists?
          puts "------ page no = #{pgno}"
          page.check_results_sort_order(false , 1)
          page.results_list_next_enabled.wait_until_present
          page.results_list_next_click
          pgno = pgno+1
          page.results_list_next_enabled.wait_until_present
        end
      else
        puts "------ page no = #{pgno}"
        page.check_results_sort_order(false , 1)
      end
    end
  end


# this method will set bookmark if not already set.
  def set_course_bookmark
    on CourseSearch do |page|
      page.star_bookmark_off.wait_until_present
      page.set_star_bookmark
    end

  end

  def clear_course_bookmark
    on CourseSearch do |page|
      page.star_bookmark_on.wait_until_present
      page.clear_star_bookmark
    end
  end

  def initial_bookmark_state_set
    course_search
    on CourseSearch do |page|
      page.set_star_bookmark if page.star_bookmark_off.exists?
    end
  end

  def initial_bookmark_state_clear
#    course_search
    on CourseSearch do |page|
      page.clear_star_bookmark if page.star_bookmark_on.exists?
    end
  end


#KSAP-1000--------------------------------------------------------------------------



  def check_logical_order_display_of_elements_in_allpages(course_code_count,course_code_list,course_number_list,output)
    on CourseSearch do |page|
      no_of_rows = page.results_table.rows.length-1
      cloned_textArray= course_code_list.clone
      cloned_numArray= course_number_list.clone
      numArray_length = course_number_list.size
      cloned_textArray_length = cloned_textArray.size
      cloned_numArray_length = cloned_numArray.size

      # have to implement for other pages
      if course_code_count > 0
        #check for courseCode in Text Array
        for index in 1..no_of_rows do
          puts "Index is #{index}"
          course_code = page.results_table.rows[index].cells[COURSE_CODE].text
          puts course_code
          sleep(1)
          course_name = page.results_table.rows[index].cells[COURSE_NAME].text.downcase
          if course_code.include? "#{course_code_list[0]}"

          else

            if course_code_count > 1
              course_code_list.delete_at(0)
              #text_array_element=text_array_element+1
              if course_code.include? "#{course_code_list[0]}"
              else
                course_code_list.delete_at(0)
                if course_code.include? "#{course_number_list[0]}"
                else
                  if numArray_length > 1
                    course_number_list.delete_at(0)
                    if course_code.include? "#{course_number_list[0]}"

                    else
                    end
                  else
                    course_number_list.delete_at(0)
                    if ((course_name.include? "#{cloned_textArray[0]}".downcase) ||(course_description_text.include? "#{cloned_textArray[0]}".downcase))
                    else
                      if cloned_textArray_length > 1
                        cloned_textArray.delete_at(0)
                        #text_array_element=text_array_element+1
                        if ((course_name. include? "#{cloned_textArray[0]}".downcase )||(course_description_text.include? "#{cloned_textArray[0]}".downcase))
                        else
                        end
                      else
                        cloned_textArray.delete_at(0)
                        if ((course_name. include? "#{cloned_numArray[0]}".downcase )||(course_description_text.include? "#{cloned_textArray[0]}".downcase))

                        else
                          if numArray_length > 1
                            cloned_numArray.delete_at(0)
                            if ((course_name. include? "#{cloned_numArray[0]}" .downcase )||(course_description_text.include? "#{cloned_textArray[0]}".downcase))
                            else
                              return false
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      else
        # check directly in Num Array
        for index in 1..no_of_rows do
          course_code = page.results_table.rows[index].cells[COURSE_CODE].text
          sleep(1)
          course_name = page.results_table.rows[index].cells[COURSE_NAME].text.downcase
          if course_code. include? "#{course_number_list[0]}"
          else
            if course_number_list > 1
              course_number_list.delete_at(0)
              if course_code. include? "#{course_number_list[0]}"
              else
              end
            end
          end
        end
      end
    end
  end


  def check_logical_order_display_of_elements_in_firstpage(course_code_count,numArray_length,course_code_list,course_number_list,output)
    on CourseSearch do |page|
      no_of_rows = page.results_table.rows.length-1
      concat_array_length=  output.size
      for index in 1..no_of_rows do
        sleep(1)
        course_code = page.results_table.rows[index].cells[COURSE_CODE].text
        sleep(1)
        course_name = page.results_table.rows[index].cells[COURSE_NAME].text.downcase
        if index > concat_array_length
          #for k in 0 ..course_code_count
          if course_code.include? "#{course_code_list[0]}"
          else
            if course_code_count > 1
              course_code_list.delete_at(0)
              #text_array_element=text_array_element+1
              if course_code. include? "#{course_code_list[0]}"
              else
              end
            else
              course_code_list.delete_at(0)
              if course_code.include? "#{course_number_list[0]}"
              else
                if numArray_length > 1
                  course_number_list.delete_at(0)
                  if course_code.include? "#{course_number_list[0]}"
                  else
                  end
                end
              end
            end
          end
        else
          puts "else loop  concatArray =  #{concat_array_length}"
          courseCode =  course_code
          puts "index = #{index};  courseCode = #{courseCode};   ConcatArray 1 = #{output[index-1]}"
          if  (courseCode == output[index-1])

          else
            return false
          end
        end
      end # end of for loop
    end
  end

  def logical_order_sort(text)
    output=[]
    search_text_array = text.split( " " )
    course_number_list = Array.new
    numberArray = Array.new
    course_code_list = Array.new
    textstringArray = Array.new
    for index in 0 ... search_text_array.size
      arrValue = "#{search_text_array[index]}"
      if (arrValue.match(/^\d+$/))
        numberArray.push arrValue
      else
        textstringArray.push arrValue
      end
    end
    course_number_list=  numberArray.sort
    course_code_list =  textstringArray.sort
    course_number_count=course_number_list.size
    course_code_count=course_code_list.size
    for j in 0...course_code_count do
      for i in 0...course_number_count do
        output<< course_code_list[j] + course_number_list[i].to_s
      end
    end
    on CourseSearch do |page|

      no_of_rows = page.results_table.rows.length-1

      puts "no of rows = #{no_of_rows}"
      pgno = 1
      if page.results_list_next_enabled.exists?
        until page.results_list_next_disabled.exists?
          puts "------ page no = #{pgno}"
          if pgno == 1
            puts "inside pageno = 1 "
            result = check_logical_order_display_of_elements_in_firstpage(course_code_count,course_number_count,course_code_list,course_number_list,output)
            if result == false
              return false
            end
          else
            puts "<<<<<<<<<<<<<<<<<<<<<<<  page no = #{pgno}   >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
            puts   " text Array Size = #{course_code_list.size}"
            puts   " Num Array Size = #{course_number_list.size}"

            check_logical_order_display_of_elements_in_allpages(course_code_count,course_code_list,course_number_list,output)

          end

          #Need to refactor this in future.As workaround sleep added
          sleep(5)
          page.results_list_next_enabled.wait_until_present(50)
          page.results_list_next_click
          sleep(5)
          pgno = pgno+1
          page.results_list_next_enabled.wait_until_present(50)
          end
      else
        if pgno == 1
          result = check_logical_order_display_of_elements_in_firstpage(course_code_count,course_number_count,course_code_list,course_number_list, output)
          if result == false
            return false
          end
        end
      end
    end
  end


  def quick_add_planned
    on CourseSearch do |page|
      page.course_search_results_facets.wait_until_present
    end
    on CourseSearch do |page|
      page.plan_page_click
    end
    on CoursePlannerPage do |page|
      page.planner_courses_detail_list.wait_until_present
      remove_code_from_planned_backup
      page.quick_add(@state,@planned_term).wait_until_present(120)
      page.quick_add(@state,@planned_term).click
      page.course_code_quick_add.when_present(60).set @course_code
      page.course_code_quick_add.send_keys :tab
      page.add_to_plan_quick.click
    end
  end
  def quick_add_planned_notes
    on CourseSearch do |page|
      page.course_search_results_facets.wait_until_present
    end
    on CourseSearch do |page|
      page.plan_page_click
    end
    on CoursePlannerPage do |page|
      page.planner_courses_detail_list.wait_until_present
      remove_code_from_planned_backup
      page.quick_add(@state,@planned_term).wait_until_present(120)
      page.quick_add(@state,@planned_term).click
      page.course_code_quick_add.when_present(60).set @course_code
      page.course_code_quick_add.send_keys :tab
      page.quick_add_notes.set "TEST"
      page.add_to_plan_quick.click
    end
  end


  def quick_add_backup
    on CourseSearch do |page|
      page.course_search_results_facets.wait_until_present
    end
    on(CourseSearch) do |page|
      page.plan_page_click
    end

    on CoursePlannerPage do |page|
      page.planner_courses_detail_list.wait_until_present(120)
      remove_code_from_planned_backup
      #This would change for backup
      page.quick_add(@state,@planned_term).wait_until_present(120)
      page.quick_add(@state,@planned_term).click
      page.course_code_quick_add.when_present(60).set @course_code
      page.course_code_quick_add.send_keys :tab
      page.add_to_plan_quick.click
    end
  end

  def add_same_course
    on CoursePlannerPage do |page|
      page.refresh
      page.planner_courses_detail_list.wait_until_present(120)
      page.quick_add(@state,@planned_term).click
      page.course_code_quick_add.when_present(60).set @course_code
      page.course_code_quick_add.send_keys :tab
      page.add_to_plan_quick.click
    end

  end

  def add_same_course_backup
    on CoursePlannerPage do |page|
      page.refresh
      page.planner_courses_detail_list.wait_until_present(120)

      #This would change for backup

      page.quick_add(@state,@planned_term).click
      page.course_code_quick_add.when_present(60).set @course_code
      page.course_code_quick_add.send_keys :tab
      page.add_to_plan_quick.click
    end
  end

  def update_notes
    on CoursePlannerPage do |page|
      page.planner_courses_detail_list.wait_until_present(120)
      sleep 7
      page.course_code_term_click(@planned_term,@course_code)
      page.course_code_edit_click
      page.edit_course.wait_until_present
      page.edit_course.click
    end
  end


  def successful_updation
    on CoursePlannerPage do |page|
      page.quick_add_notes.send_keys  [:control, 'a'], :backspace
      page.quick_add_notes.set "UPDATED TEST"
      page.add_to_plan_quick.click
      sleep 5
      page.added_course_note(planned_term,course_code).wait_until_present(120)
      end
  end


  def successful_deletion
    on CoursePlannerPage do |page|
      page.quick_add_notes.send_keys  [:control, 'a']
      for i in 1..4
        page.quick_add_notes.send_keys  :backspace
      end
      page.edit_course.click
      sleep 5
      puts page.added_course_note(@planned_term, @course_code).attribute_value("data-content")
    end
  end


  def enter_note
    on CoursePlannerPage do |page|
      page.refresh
      page.planner_courses_detail_list.wait_until_present(120)
      page.course_code_term(@planned_term, @course_code).should==@course_code
      puts page.added_course_note(planned_term, @course_code).attribute_value("data-content")
    end
  end

  def enter_note_through_cdp
    on CourseSearch do |page|
      page.course_search_results_facets.wait_until_present(60)
    end
    #navigate to planner page
    on CourseSearch do |page|
      page.plan_page_click
    end
    on CoursePlannerPage do |page|
      page.planner_courses_detail_list.wait_until_present(60)
    end
    #delete an existing course
   remove_code_from_planned_backup
    #navigate to course search
    #@course_search_result = make CourseSearchResults,  :planned_term=>"2014Spring", :course_code => "ENGL206", :term=>"Spring 2014"
    navigate_to_course_search_home
    on CourseSearch do |page|
      page.course_search_results_facets.wait_until_present(90)
    end
    #navigate to course details page
    navigate_course_detail_page
    on CourseSectionPage do |page|
      page.course_termlist.wait_until_present(90)
    end
    on CourseDetailPage do |page|
      page.add_to_plan.click
      page.term_cdp.wait_until_present
      page.term_cdp.select @term
      page.add_to_plan_notes_cdp.set @notes
      page.add_to_plan_button_cdp
    end
  end


  def  enter_note_adding_from_plan
    on CourseSearch do |page|
      page.course_search_results_facets.wait_until_present(120)
      on CourseSearch do |page|
        page.plan_page_click
      end
      on CoursePlannerPage do |page|
        page.planner_courses_detail_list.wait_until_present(120)
        remove_code_from_planned_backup
        navigate_to_course_search_home
        select_add_to_plan
      end
    end
  end

  def add_note_to_term
    navigate_to_course_planner_home
    on CoursePlannerPage do |page|
      click_term_note_icon_fall
      add_note
      click_term_note_icon_winter
      add_note
      click_term_note_icon_spring
      add_note
      click_term_note_icon_summer
      add_note
    end
  end

  def saved_text_term
    on CoursePlannerPage do |page|
      click_term_note_icon_spring
      get_text=page.term_note.value
      page.save_term_note.click
      page.term_note_dialog.wait_while_present
      get_text.should == "Test Term Note"
    end
  end

  def edit_note_term
    navigate_to_course_planner_home
    on CoursePlannerPage do |page|
      click_term_note_icon_fall
      edit_note
      click_term_note_icon_winter
      edit_note
      click_term_note_icon_spring
      edit_note
      click_term_note_icon_summer
      edit_note
    end
  end

  def edited_text_term
    on CoursePlannerPage do |page|
      click_term_note_icon_winter
      get_text=page.term_note.value
      page.save_term_note.click
      page.term_note_dialog.wait_while_present
      get_text.should == "Edit Term Note"
    end
  end

  def delete_note_term
    navigate_to_course_planner_home
    on CoursePlannerPage do |page|
      click_term_note_icon_fall
      delete_note
      click_term_note_icon_winter
      delete_note
      click_term_note_icon_spring
      delete_note
      click_term_note_icon_summer
      delete_note
    end
  end

  def deleted_text_term
    on CoursePlannerPage do |page|
      click_term_note_icon_winter
      get_text=page.term_note.value
      page.save_term_note.click
      page.term_note_dialog.wait_while_present
      get_text.should == ""
    end
  end

  def click_term_note_icon_fall
    on CoursePlannerPage do |page|
      page.term_fall.wait_until_present(120)
      page.term_fall.click
      page.term_note_dialog.wait_until_present
    end
  end

  def click_term_note_icon_winter
    on CoursePlannerPage do |page|
      page.term_winter.wait_until_present(120)
      page.term_winter.click
      page.term_note_dialog.wait_until_present
    end
  end

  def click_term_note_icon_spring
    on CoursePlannerPage do |page|
      page.term_spring.wait_until_present(120)
      page.term_spring.click
      page.term_note_dialog.wait_until_present
    end
  end

  def click_term_note_icon_summer
    on CoursePlannerPage do |page|
      page.term_summer.wait_until_present(120)
      page.term_summer.click
      page.term_note_dialog.wait_until_present
    end
  end

  def add_note
    on CoursePlannerPage do |page|
      page.term_note_dialog.wait_until_present
      page.term_note.set "Test Term Note"
      page.save_term_note.click
      page.term_note_dialog.wait_while_present
    end
  end

  def edit_note
    on CoursePlannerPage do |page|
      page.term_note_dialog.wait_until_present
      page.term_note.set "Edit Term Note"
      page.save_term_note.click
      page.term_note_dialog.wait_while_present
    end
  end

  def delete_note
    on CoursePlannerPage do |page|
      page.term_note_dialog.wait_until_present
      page.term_note.set ""
      page.save_term_note.click
      page.term_note_dialog.wait_while_present
    end
  end

end