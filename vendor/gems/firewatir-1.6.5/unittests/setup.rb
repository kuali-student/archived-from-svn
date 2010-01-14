$SETUP_LOADED = true

$myDir = File.expand_path(File.dirname(__FILE__))

topdir = File.join(File.dirname(__FILE__), '..')
$firewatir_dev_lib = File.join(topdir, 'lib')
$watir_dev_lib = File.join(topdir, '..', 'watir', 'lib')
libs = []
libs << File.join(topdir, '..', 'commonwatir', 'lib')
libs << File.join(topdir, '..', 'commonwatir') # for the unit tests
libs.each { |lib| $LOAD_PATH.unshift File.expand_path(lib) }

require 'watir'
Watir::Browser.default = 'firefox'
require 'unittests/setup/lib'
module Watir::UnitTest
  alias :uses_page :goto_page
end

require 'unittests/setup/testUnitAddons'

commondir = File.join(topdir, '..', 'commonwatir')
$all_tests = []
Dir.chdir topdir do
  $all_tests += Dir["unittests/*_test.rb"]
end
Dir.chdir commondir do
  $all_tests += Dir["unittests/*_test.rb"]
end
