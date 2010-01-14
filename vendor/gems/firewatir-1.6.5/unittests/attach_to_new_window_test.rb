# feature tests for attaching to new Firefox windows
# revision: $Revision: 1.0 $

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..') unless $SETUP_LOADED
require 'unittests/setup'

class TC_NewWindow < Test::Unit::TestCase
    tags :fails_on_ie

    def setup
      goto_page("new_browser.html")
    end

    def test_simply_attach_to_new_window_using_title
        browser.link(:text, 'New Window').click
        begin 
          ff_new = browser.attach(:title, 'Pass Page')
        rescue Watir::Exception::NoMatchingWindowFoundException
          raise $!, "Attach failed, check your Firefox settings: http://wiki.openqa.org/display/WTR/FireWatir+Installation#FireWatirInstallation-ffsettings" 
        end
        assert(ff_new.text.include?('PASS'))
        ff_new.close
        #browser.link(:text, 'New Window').click
    end
    
    def test_simply_attach_to_new_window_using_url
        browser.link(:text, 'New Window').click
        begin
          ff_new = browser.attach(:url, /pass\.html/)
        rescue Watir::Exception::NoMatchingWindowFoundException
          raise $!, "Attach failed, check your Firefox settings: http://wiki.openqa.org/display/WTR/FireWatir+Installation#FireWatirInstallation-ffsettings" 
        end
        assert(ff_new.text.include?('PASS'))
        ff_new.close
        #browser.link(:text, 'New Window').click
    end

    def test_attach_to_new_window_with_same_title_as_parent
        browser.link(:text, 'New Browser Window').click
        ff_new = browser.attach(:title, 'New Browser Launcher')
        assert(ff_new.text.include?('PASS'))
        ff_new.close
    end
     
    def test_new_window_exists
        assert_raises(NoMatchingWindowFoundException , "NoMatchingWindowFoundException was supposed to be thrown" ) {   browser.attach(:title, "missing_title")   }  
        assert_raises(NoMatchingWindowFoundException , "NoMatchingWindowFoundException was supposed to be thrown" ) {   browser.attach(:url, "missing_url")   }  
    end
end
