class Test < ApplicationRecord
  include PublicActivity::Model
  validates :free, :presence => true
  tracked only: :create, owner: Proc.new{ |controller, model| controller.current_user }
  # Relationships
  has_many :test_results
  has_many :cards
end
