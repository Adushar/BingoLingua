class Point < ApplicationRecord
  belongs_to :test_result
  belongs_to :user
  attr_reader :test_id
end
