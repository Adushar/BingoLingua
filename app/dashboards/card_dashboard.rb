require "administrate/base_dashboard"

class CardDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    position_in_test: Field::Number,
    picture: Administrate::Field::Image,
    sound: Field::String,
    test: Field::BelongsTo,
    description: Field::String,
    translation: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :position_in_test,
    :picture,
    :sound,
    :created_at,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :position_in_test,
    :picture,
    :sound,
    :description,
    :translation,
    :test,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :position_in_test,
    :picture,
    :sound,
    :description,
    :translation,
    :test,
  ].freeze

  # Overwrite this method to customize how cards are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(card)
  #   "Card ##{card.id}"
  # end
end
