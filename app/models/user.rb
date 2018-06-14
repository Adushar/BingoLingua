class User < ActiveRecord::Base
  after_initialize :default_values

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  private
   def default_values
     self.subscribe_ends ||= Time.now
   end
end
