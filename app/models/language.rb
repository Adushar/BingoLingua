class Language < ApplicationRecord
  mount_uploader :flag, FlagUploader
  has_many :tests
  has_many :users
end
