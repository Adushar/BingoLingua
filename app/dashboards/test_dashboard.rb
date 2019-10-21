require "administrate/base_dashboard"

class TestDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    picture: Field::Carrierwave.with_options(
      remove: true,
      image_on_index: true
    ),
    free: Field::Boolean,
    promote: Field::Boolean,
    test_results: Field::HasMany,
    cards: Field::HasMany.with_options(sort_by: :position_in_test),
    groups: Field::HasMany,
    language: Administrate::Field::BelongsTo,
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
    :picture,
    :name,
    :free,
    :promote,
    :cards,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :picture,
    :name,
    :free,
    :promote,
    :language,
    :groups,
    :cards,
    :test_results,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :picture,
    :name,
    :free,
    :promote,
    :groups,
    :cards,
    :language,
  ].freeze

  # Overwrite this method to customize how tests are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(test)
    "#{test.name} test"
  end
end
