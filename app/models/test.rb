class Test < ApplicationRecord
  # Relationships
  has_many :test_results
  has_many :cards
  belongs_to :language, optional: true
end
