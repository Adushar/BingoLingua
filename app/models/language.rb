class Language < ApplicationRecord
  self.primary_key = "code"
  mount_uploader :flag, FlagUploader
  validates :code, :presence => true
  validates :name, :presence => true
  has_many :tests
  has_many :users
end
