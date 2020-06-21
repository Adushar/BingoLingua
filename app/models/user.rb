class User < ActiveRecord::Base
  before_save :set_subscribtion
  validates :first_name, :presence => true
  validates :last_name, :presence => true

  has_many :selected_cards
  has_many :cards, :through => :selected_cards
  has_many :test_results
  has_many :learned_words
  has_many :points
  has_and_belongs_to_many :groups
  has_one :language

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.subscribe_active(id)
    subscribe_ends = User.find(id).subscribe_ends
    return subscribe_ends ? !subscribe_ends.past? : false
  end

  def set_subscribtion
    self.subscribe_ends ||= 1.day.ago
  end

  def selected_cards_by_test(test_id)
    SelectedCard.includes(:card).where(
      cards: {test_id: test_id},
      user_id: id
    )
  end

  def select_card(card_id)
    if has_selected_card? card_id
      SelectedCard.where(user_id: id, card_id: card_id).destroy_all
    else
      SelectedCard.create(user_id: id, card_id: card_id)
    end
  end

  def remove_selected_cards(test_id)
    selected_cards_by_test(test_id).destroy_all
  end

  def has_selected_card?(card_id)
    selected_cards.pluck(:card_id).include? card_id.to_i
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def group_name
    groups.last.name
  end

  def subscribe_left
    days = subscribe_ends ? (Date.today...subscribe_ends).count : 0
    if days > 0 && Date.today > subscribe_ends
      "Subscribe ends in <b>#{days}</b> days"
    else
      "<b>Your subscription has ended</b>"
    end
  end

  def assigned_tests
    groups.includes(:tests).map(&:tests).flatten
  end

  def demo_user?
    email == "demo_user@gmail.com"
  end

  def scores
    points.pluck(:value).sum
  end

  def monthly_score
    points.monthly.pluck(:value).sum
  end

  def self.demo_mode
    demo_user = User.where(email: "demo_user@gmail.com")[0]
    if demo_user
      return demo_user
    else
      new_user = User.new({
        :first_name => "Demo",
        :last_name => "User",
        :email => "demo_user@gmail.com",
        :password => "7uPtpP6J8v9MaQ3u",
        :password_confirmation => "7uPtpP6J8v9MaQ3u",
        confirmed_at: Time.now.utc
      })
      return new_user if new_user.save
    end
  end
end
