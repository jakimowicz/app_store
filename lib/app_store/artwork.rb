require "app_store/base"
require "app_store/image"

class AppStore::Artwork < AppStore::Base
  attr_reader :default, :thumbnail
  
  plist :mapping => { 'image-type'  => :image_type }
    
  def is_icon?
    image_type == 'software-icon'
  end

  protected
  def custom_init_from_plist(plist)
    @default = AppStore::Image.new(:plist => plist['default']) if plist['default']
    @thumbnail = AppStore::Image.new(:plist => plist['thumbnail']) if plist['thumbnail']
  end

end