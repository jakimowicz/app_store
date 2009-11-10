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
    
  TitleRegex = /^([0-9]+)\. (.*) \(v(.*)\)$/
  UserNameRegex = /^(.*) on ([a-zA-Z]{3} [0-9]{1,2}, [0-9]{4})$/
    
  # version on which the comment was made
  def on_version
    @on_version ||= title.match(TitleRegex)[3]
  end
  
  # display position of the user review
  def position
    @position ||= title.match(TitleRegex)[1]
  end
  
  # title extracted from title without position and version
  def clean_title
    @clean_title ||= title.match(TitleRegex)[2]
  end
  
  # date of the comment, extracted from user_name
  def date
    @date ||= Time.parse user_name.match(UserNameRegex)[2]
  end
  
  # user_name without date
  def clean_user_name
    @clean_user_name ||= user_name.match(UserNameRegex)[1]
  end
end