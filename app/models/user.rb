class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, :presence => true
  validates :username, :uniqueness => true
  validates :username, :format => { :with => /^[a-zA-Z0-9_]{3,18}$/, 
    :message => "must be combination of numbers and/or letters between 3 to 18 characters long" }

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :remember_me, :username

  acts_as_voter
end
