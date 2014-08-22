class RegistrationCartRestCallPage < PageFactory

  def clearCart(term_code)
    page_url = "#{$test_site}/services/CourseRegistrationCartClientService/clearCart?termCode=#{term_code}"
    @browser.goto page_url
    sleep 1
  end

end
