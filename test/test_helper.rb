require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'app_store'

class Test::Unit::TestCase
end

# Dummy class used for tests
class AppStore::Dummy < AppStore::Base
end