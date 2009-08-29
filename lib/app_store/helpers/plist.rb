require "app_store/helper"

module AppStore::Helper::Plist
  def plist(params = {})
    mapping = params[:mapping].collect do |plist_key, attr_name|
      # First, make attribute readable outside the instance
      class_eval "attr_reader :#{attr_name}"
      
      # Then, build the content of init_from_plist function
      "@#{attr_name} = plist['#{plist_key}']"
    end rescue []
    
    class_eval <<-EOV, __FILE__, __LINE__
      protected
      def init_from_plist(plist)
        #{"raise AppStore::ParseError unless plist['type'] == '#{params[:accepted_type]}'" if params[:accepted_type]}
        super
        #{mapping.join("\n")}
      end
    EOV
  end
end