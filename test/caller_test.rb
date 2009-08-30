require "test_helper"

class CallerTest < Test::Unit::TestCase
  def setup
    AppStore::Caller.send(:public, *AppStore::Caller.protected_instance_methods) 
  end
  
  should "returns a mechanize agent on call to agent" do
    assert_kind_of WWW::Mechanize, AppStore::Caller.agent
  end

  should "set mechanize user agent to iTunes-iPhone/3.0 (2)" do
    assert_equal 'iTunes-iPhone/3.0 (2)', AppStore::Caller.agent.user_agent
  end
end