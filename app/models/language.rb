class Language < ApplicationRecord
  self.primary_key = "code"
  mount_uploader :flag, FlagUploader
  has_many :tests
  has_many :users
end
