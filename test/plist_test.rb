require "test_helper"

class PlistTest < Test::Unit::TestCase
  should "define a reader accessor for each attribute in mapping" do
    AppStore::Dummy.plist :mapping => { "plist_attribute" => :class_attribute_from_plist_attribute }
    assert ::AppStore::Dummy.instance_methods.include? "class_attribute_from_plist_attribute"
  end
  
  should "set variable defined through mapping at initialization" do
    AppStore::Dummy.plist :mapping => { "plist_attribute" => :dummy_attribute }
    dummy = ::AppStore::Dummy.new :plist => {"plist_attribute" => 42}
    assert_equal 42, dummy.dummy_attribute
  end
  
  should "raise an exception if type is set through :accepted_type and given type does not match" do
    AppStore::Dummy.plist :accepted_type => "bleh"
    assert_raise(AppStore::ParseError) { AppStore::Dummy.new :plist => {"type" => 'toto'} }
  end

  should "not raise an exception if type is set through :accepted_type and given type does match" do
    AppStore::Dummy.plist :accepted_type => "bleh"
    assert_nothing_raised(AppStore::ParseError) { AppStore::Dummy.new :plist => {"type" => 'bleh'} }
  end
end