require 'app_store/base'

class AppStore::Image < AppStore::Base
  plist :mapping => {
      'box-height'  => :height,
      'box-width'   => :width,
      'need-shine'  => :need_shine,
      'url'         => :url,
    }
end