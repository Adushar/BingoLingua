class User < ActiveRecord::Base
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
end
