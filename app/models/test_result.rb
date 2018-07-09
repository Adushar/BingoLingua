class TestResult < ApplicationRecord
  include PublicActivity::Model
  tracked only: :create, owner: Proc.new{ |controller, model| controller.current_user }
  # Relationships
  belongs_to :user, optional: true
  belongs_to :test, optional: true
  # Here validations go
  validates :last_result, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100,  only_integer: true }
end
