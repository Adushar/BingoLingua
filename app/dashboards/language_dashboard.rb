require "administrate/base_dashboard"

class LanguageDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    name: Field::String,
    code: Field::String,
    flag: Field::Carrierwave.with_options(
      remove: true,
      image_on_index: true
    ),
    tests: Field::HasMany,
    users: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :flag,
    :name,
    :code,
    :created_at,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :flag,
    :name,
    :code,
    :users,
    :tests,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :flag,
    :name,
    :code,
    :users,
    :tests,
  ].freeze

  # Overwrite this method to customize how languages are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(language)
    "#{language.name} language"
  end
end
