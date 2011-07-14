#!/usr/bin/env ruby
# 
# == Synopsis
#
# Collection of Rice application functions
#
# Author:: Kyle Campos (mailto:kcampos@rsmart.com)
#

require File.dirname(__FILE__) + "/../app_functions.rb"
require File.dirname(__FILE__) + "/../locators.rb"

class RiceAppFunctions < AppFunctions
    
  def initialize(config)
    super(config)
    @config = config
    @locators = RiceLocators.new
    @selenium = @config.selenium
  end
    
  # Login
  def login(username=@config.user)
    @selenium.type @locators.login_username, username
    @selenium.key_press @locators.login_username, '\13'    

    # Returns TRUE if login was successful
    @selenium.wait_for_text("Logged in User")
    @selenium.is_text_present("Logged in User")
  end
  
  # Create new sample application travel request
  def create_travel_request(description="Test Description", traveler_name="Test User", traveler_origin="Phoenix", 
                            traveler_destination="Los Angeles", travel_request_type="Travel Request Type 1", travel_account="a1",
                            options={})
  
    defaults = {
      :code => "IAT - Income Account Type",
      :notes => {
        :text => nil
      }
    }
    
    options = defaults.merge(options)
    
    @selenium.click @locators.create_travel_request, :wait_for => :element, :element => @locators.travel_request_description
    
    @selenium.type @locators.travel_request_description, description
    @selenium.type @locators.travel_request_name, traveler_name
    @selenium.type @locators.travel_request_origin, traveler_origin
    @selenium.type @locators.travel_request_destination, traveler_destination
    @selenium.select @locators.travel_request_type, travel_request_type
    @selenium.type @locators.travel_request_account, travel_account
    @selenium.click @locators.travel_request_account_add, :wait_for => :page
    
    # Notes
    if(!options[:notes][:text].nil?)
      @selenium.click @locators.travel_request_notes_show
      @selenium.type @locators.travel_request_notes_text, options[:notes][:text]
      @selenium.click @locators.travel_request_notes_add, :wait_for => :page
    end
    
    @selenium.click @locators.travel_request_submit, :wait_for => :page
    
    # Dummy text, don't know what a successfull message is
    @selenium.is_text_present("Created sample travel request")
  end
  
end