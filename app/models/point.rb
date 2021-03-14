class Point < ApplicationRecord
  belongs_to :user
  belongs_to :test

  scope :monthly, -> { where('created_at >= :date', date: Time.current.beginning_of_month) }

  def self.top_10_users
    sql = <<-SQL
      SELECT user_id,
      SUM (value) as sum
      FROM points
      GROUP BY user_id
      ORDER BY sum DESC
      LIMIT 10;
    SQL

    top_users = ActiveRecord::Base.connection.execute(sql).to_a
    top_users.map {|hash| {user: User.find(hash['user_id']), points: hash['sum']} }
  end

  def self.top_10_users_monthly
    sql = <<-SQL
      SELECT user_id,
      SUM (value) as sum
      FROM points
      WHERE created_at >= ?
      GROUP BY user_id
      ORDER BY sum DESC
      LIMIT 100;
    SQL

    top_users = ActiveRecord::Base.connection.execute(sql, Time.current.beginning_of_month).to_a
    top_users.map {|hash| {user: User.find(hash['user_id']), points: hash['sum']} }
  end
end
