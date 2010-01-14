TOPDIR = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH.unshift TOPDIR
require 'unittests/setup'

Dir.chdir TOPDIR do
  $all_tests.each {|x| require x }
end
