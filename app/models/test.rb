class Test < ApplicationRecord
  def pack_name
    name.split("-")[0].gsub(/[^0-9]/, '').to_i
  end
  # Relationships
  has_many :test_results
  has_many :cards
  belongs_to :language, optional: true
end
