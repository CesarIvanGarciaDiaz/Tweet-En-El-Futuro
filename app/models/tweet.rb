class Tweet < ActiveRecord::Base
  #Un Tweet solamente debe de estar relacionado con un TwitterUser.
belongs_to :user
 validates :tweet , uniqueness: true

end
