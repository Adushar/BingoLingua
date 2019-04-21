class User < ActiveRecord::Base
  validates :first_name, :presence => true
  validates :last_name, :presence => true

  has_many :selected_cards
  has_many :cards, :through => :selected_cards
  has_many :test_results
  has_many :learned_words
  has_one :language

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.subscribe_active(id)
    subscribe_ends = User.find(id).subscribe_ends
    return subscribe_ends ? !subscribe_ends.past? : false
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def subscribe_left
    days = subscribe_ends ? (Date.today...subscribe_ends).count : 0
    if days > 0 && Date.today > subscribe_ends
      "Subscribe ends in <b>#{days}</b> days"
    else
      "<b>Your subscription has ended</b>"
    end
  end

  def scores() points end

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
