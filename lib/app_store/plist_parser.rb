require 'mechanize'

class PlistParser < Mechanize::File
  extend Forwardable
  
  attr_accessor :mech, :plist
  
  def initialize(uri=nil, response=nil, body=nil, code=nil, mech=nil)
    raise 'no' if mech and not Mechanize === mech
    @mech = mech
    
    super uri, response, body, code

    @plist = @body ? Plist::parse_xml(@body) : nil
  end
  
  def_delegator :plist, :[], :[]
  def_delegator :plist, :search, :search
end
  