class User < ActiveRecord::Base
  after_initialize :default_values
  has_many :selected_cards
  has_many :cards, :through => :selected_cards
  has_many :test_results

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.subscribe_active(id)
    return !User.find(id).subscribe_ends.past?
  end
  private
   def default_values
     self.subscribe_ends ||= Time.now
   end
end
