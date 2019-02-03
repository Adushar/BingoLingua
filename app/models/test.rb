class Test < ApplicationRecord
  include PublicActivity::Model
  tracked only: :create, owner: Proc.new{ |controller, model| controller.current_user }
  # Relationships
  has_many :test_results
  has_many :cards
  belongs_to :language, optional: true
end
