class TestResult < ApplicationRecord
  # Relationships
  belongs_to :user, optional: true
  belongs_to :test, optional: true
  # Here validations go


  validates_uniqueness_of :user_id, :scope => [:test_id]
  validates :score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100,  only_float: true }
  def self.add_result(hash)
    # Add tests and write changings of other fields
    if new(hash).valid?
      hash[:attempts] = 1
      create(hash)
    elsif hash.has_key?(:score)
      u = find_by(hash.extract! :test_id, :user_id)
      u.score = (u.score * u.attempts + hash[:score] )/(u.attempts+1)
      u.attempts += 1
      u.save
      puts "errors #{u.errors.full_messages}"
    end
  end
end
