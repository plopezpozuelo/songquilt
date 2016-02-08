class User < ActiveRecord::Base
  validates :first_name, presence:true
  validates :email, presence:true
end
