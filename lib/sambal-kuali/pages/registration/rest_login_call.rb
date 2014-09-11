class RestLoginPage < PageFactory

  element(:preformatted_text) { |b| b.pre}

  def login_as (userid)
    url = "#{$test_site}/services/DevelopmentLoginClientService/login?userId=#{userid}&password=#{userid}"
    @browser.goto url
  end

end
