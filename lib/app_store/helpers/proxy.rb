require 'app_store/helper'

# Proxy class, call class methods on given class (<tt>to</tt>) with <tt>extra</tt> arguments
# for each method called on a proxy instance
class AppStore::Helper::Proxy
  # Instanciate a new proxy object. Acceptable arguments :
  # * <tt>to</tt>: receiver class
  # * <tt>extra</tt>: extra arguments passed to each methods
  def initialize(args = {})
    @to = args[:to]
    @extra = args[:extra]
  end
  
  private
  def method_missing(method, *args)
    raise "method #{method} not found for #{@to}" unless @to.methods.include?(method.to_s)
    # OPTIMIZE: define method instead of sending each time
    hash = args.last.is_a?(Hash) ? args.last : {}
    case @to.method(method).arity
    when -2
      @to.send(method, args.first, @extra.merge(hash))
    when -1
      @to.send(method, @extra.merge(hash))
    else
      raise "method #{method} not supported by proxy"
    end
  end
end