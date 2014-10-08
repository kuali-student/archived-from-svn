class RegistrationRestCallPage < PageFactory

  def clearSchedule(term_code)
    page_url = "#{$test_site}/services/CourseRegistrationClientService/clearSchedule?termCode=#{term_code}"
    @browser.goto page_url
    sleep 5
  end

end
