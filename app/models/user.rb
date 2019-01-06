class User < ActiveRecord::Base
  include PublicActivity::Model
  tracked only: :create, owner: Proc.new{ |controller, model| controller.current_user }
  validates :first_name, :presence => true
  validates :last_name, :presence => true

  has_many :selected_cards
  has_many :cards, :through => :selected_cards
  has_many :test_results
  has_many :points
  has_many :learned_words

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.subscribe_active(id)
    subscribe_ends = User.find(id).subscribe_ends
    return subscribe_ends ? !subscribe_ends.past? : false
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def subscribe_left
    days = (Date.today...subscribe_ends).count
    if days > 0
      "Subscribe ends in <b>#{days}</b> days"
    else
      "<b>Your subscribe is ended</b>"
    end
  end

  def scores
    points.sum(:points)
  end
end
