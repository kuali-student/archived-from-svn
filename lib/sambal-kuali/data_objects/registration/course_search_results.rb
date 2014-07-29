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
                :course_level

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :course_code=>"BSCI430",
        :credit=>3,
        :notes=>"#{random_alphanums(20).strip}_pub",
        :planned_term=>"2012Fall",
        :term=> "Fall 2012",
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
        :course_level=> '300',
        :course_prefix=> 'ENGL'
    }
    options = defaults.merge(opts)
    set_options(options)
  end

  def inspect
    "Code: #{@course_code}, Level: #{@course_level}, Prefix: #{@course_prefix}"
  end

 def select_facet(facet_type)
   on CourseSearchPage do |page|
     page.seats_avail_toggle.wait_until_present
     page.toggle_seats_avail if facet_type=="avail_seats"
     page.toggle_credits(@credit) if facet_type=="credit"
     page.toggle_course_level(@course_level) if facet_type=="course_level"
     page.toggle_course_prefix(@course_prefix) if facet_type=="course_prefix"
    end
 end
  def navigate_course_detail_page
    on CourseSearchPage  do |page|
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
        page.course_planner_header.wait_until_present
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

  def course_search_to_planner
    on CourseSearchPage  do |page|
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
    on CourseSearchPage do |page|
      page.search_for_course.set @course_code
      page.search
    end
  end


  def course_search (text=@course_code, term_select=@term_select)
    on CourseSearchPage do |page|
      sleep 2
      page.go_to_results_page text
      # page.search_for_course.set text
      # if @term_select != nil
      #   page.search_term_select.select term_select
      # end
      page.search
    end
  end

  def clear_facets
    on CourseSearchPage do |page|
      page.toggle_seats_avail if page.seats_avail_toggle.class =~ /kscr-SearchFacet-option--Selected/i
      page.toggle_credits(@credit) if page.credits_toggle(@credit).class =~ /kscr-SearchFacet-option--Selected/i
      page.toggle_course_level(@course_level) if page.course_level_toggle(@course_level).class =~ /kscr-SearchFacet-option--Selected/i
      page.toggle_course_prefix(@course_prefix) if page.course_prefix_toggle(@course_prefix).class =~ /kscr-SearchFacet-option--Selected/i
    end
  end



  def select_add_to_plan
    on CourseSearchPage do |page|
      page.plus_symbol.wait_until_present
      page.plus_symbol_popover
      page.term.wait_until_present
      page.term.select @term
      page.add_to_plan_credit.set @credit
      page.add_to_plan_notes.set @notes
      page.add_to_plan_button
      page.plan_page_click
    end
  end




#############################

  def course_search_with_search_text(text=@search_text, term_select=@term_select)
    #navigate_to_maintenance_portal
    #navigate_to_course_search_home
    on CourseSearchPage do |page|
      sleep 2
      page.search_for_course.set text
      if @term_select != nil
        page.search_term_select.select term_select
      end
      page.search
    end
  end


  def multi_text_search(expected)
    on CourseSearchPage do |page|
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
    on CourseSearchPage do |page|
      puts "Search Text = #{single_text}"
      pgno = 1
      if page.next_page_on.exists?

        until page.next_page_off.exists?
          puts "------ page no = #{pgno}"
          page.single_text_search_results_validation(single_text)
          page.next_page_on.wait_until_present
          page.next_page_on.click
          pgno = pgno+1
          page.next_page_on.wait_until_present
        end
      else
        puts "------ page no = #{pgno}"
        ### - The line executes when its Single Page and also Last page in Multi page
        page.single_text_search_results_validation(single_text)
      end

    end
  end



  def check_all_results_data_for_text(split_text,search_FullText)
    on CourseSearchPage do |page|
      puts "Search Text = #{split_text}"
      pgno = 1
      if page.next_page_on.exists?
        until page.next_page_off.exists?
          puts "------ page no = #{pgno}"
          result = page.results_list_validation(split_text,search_FullText)
          if result == false
            return false
          end
          page.next_page_on.wait_until_present
          page.next_page_on.click
          pgno = pgno+1
          page.next_page_on.wait_until_present
        end
      else

        puts "------ page no = #{pgno}"
        ### - The line executes when its Single Page and also Last page in Multi page
        page.results_list_validation(split_text,search_FullText)

      end
    end
  end

  def check_all_results_data_for_level(text)
    on CourseSearchPage do |page|
      puts "Search Text = #{text}"
      pgno = 1
      puts level_digit = text.slice(0)
      if page.next_page_on.exists?
        until page.next_page_off.exists?
          puts "------ page no = #{pgno}"
          page.result_list_level(text)
          page.next_page_on.wait_until_present
          page.next_page_on.click
          pgno = pgno+1
          page.next_page_on.wait_until_present
        end
      else

        puts "------ page no = #{pgno}"
        page.result_list_level(text)
      end
    end
  end

  # Check that returned results meet search criteria and required courses are
  def check_all_results_data(expected_courses, expected_text)
    on CourseSearchPage do |page|
      puts "Search Text = #{expected_text}"
      pgno = 1
      puts level_digit = expected_text.slice(0)
      until page.next_page_off.exists?
        puts "------ page no = #{pgno}"
        pass = page.validate_result_list(expected_courses,expected_text)
        if pass!= true
          return false
        end
        page.next_page_on.wait_until_present
        page.next_page_on.click
        pgno = pgno+1
        page.next_page_on.wait_until_present
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
    on CourseSearchPage do |page|
      pgno = 1
      if page.next_page_on.exists?
        until page.next_page_off.exists?
          puts "------ page no = #{pgno}"
          page.check_results_sort_order(true , 0)
          page.next_page_on.wait_until_present
          page.next_page_on.click
          pgno = pgno+1
          page.next_page_on.wait_until_present
        end
      else
        puts "------ page no = #{pgno}"
        page.check_results_sort_order(true , 0)
      end
    end
  end

  def check_code_descending_order_in_all_pages
    on CourseSearchPage do |page|
      pgno = 1
      if page.next_page_on.exists?
        until page.next_page_off.exists?
          puts "------ page no = #{pgno}"
          page.check_results_sort_order(false , 0)
          page.next_page_on.wait_until_present
          page.next_page_on.click
          pgno = pgno+1
          page.next_page_on.wait_until_present
        end
      else
        puts "------ page no = #{pgno}"
        page.check_results_sort_order(false , 0)
      end
    end
  end

  def check_title_ascending_order_in_all_pages
    on CourseSearchPage do |page|
      pgno = 1
      if page.next_page_on.exists?
        until page.next_page_off.exists?
          puts "------ page no = #{pgno}"
          page.check_results_sort_order(true , 1)
          page.next_page_on.wait_until_present
          page.next_page_on.click
          pgno = pgno+1
          page.next_page_on.wait_until_present
        end
      else
        puts "------ page no = #{pgno}"
        page.check_results_sort_order(true ,1)
      end
    end
  end




  def check_title_descending_order_in_all_pages
    on CourseSearchPage do |page|
      pgno = 1
      if page.next_page_on.exists?
        until page.next_page_off.exists?
          puts "------ page no = #{pgno}"
          page.check_results_sort_order(false , 1)
          page.next_page_on.wait_until_present
          page.next_page_on.click
          pgno = pgno+1
          page.next_page_on.wait_until_present
        end
      else
        puts "------ page no = #{pgno}"
        page.check_results_sort_order(false , 1)
      end
    end
  end


#KSAP-1000--------------------------------------------------------------------------



  def check_logical_order_display_of_elements_in_allpages(course_code_count,course_code_list,course_number_list,output)
    on CourseSearchPage do |page|
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
    on CourseSearchPage do |page|
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
    on CourseSearchPage do |page|

      no_of_rows = page.results_table.rows.length-1

      puts "no of rows = #{no_of_rows}"
      pgno = 1
      if page.next_page_on.exists?
        until page.next_page_off.exists?
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
          page.next_page_on.wait_until_present(50)
          page.next_page_on.click
          sleep(5)
          pgno = pgno+1
          page.next_page_on.wait_until_present(50)
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
end


