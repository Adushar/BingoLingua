class CardSerializer < ActiveModel::Serializer
  attributes :id, :sound, :picture, :translation, :description, :test_id
end
