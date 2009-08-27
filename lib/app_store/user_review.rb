require "app_store/base"

# Each Application can have multiple user reviews.
# Available attributes:
# * <tt>average_user_rating</tt>: rating given by the user for the application.
# * <tt>user_name</tt>: name of the user who made the rating.
# * <tt>title</tt>: title of the rating (probably some internal apple stuff).
# * <tt>text</tt>: comment leaved by the user.
class AppStore::UserReview < AppStore::Base
  plist :accepted_type => 'review',
    :mapping => {
      'average-user-rating' => :average_user_rating,
      'user-name'           => :user_name, # TODO : parse user_name to separate username and comment date
      'title'               => :title,
      'text'                => :text
    }
end