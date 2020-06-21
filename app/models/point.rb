class Point < ApplicationRecord
  belongs_to :user
  belongs_to :test

  scope :monthly, -> { where('created_at >= :date', date: Time.current.beginning_of_month) }

  def self.top_users
    user_results = Point.all.group_by(&:user)
    user_results = user_results.map { |user, points| { user: user, points: points.pluck(:value).sum } }
    user_results.sort_by { |record| record[:points] }.reverse
  end

  def self.top_monthly_users
    user_results = Point.monthly.group_by(&:user)
    user_results = user_results.map { |user, points| { user: user, points: points.pluck(:value).sum } }
    user_results.sort_by { |record| record[:points] }.reverse
  end
end
