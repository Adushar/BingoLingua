source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.2'

# Rails defaults
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

# Haml gem. Reed more: https://www.rubydoc.info/gems/haml-rails/0.9.0
gem 'haml-rails'
# Devise for auth
gem 'devise'
# For admin panel
gem "administrate"
# For images in admin panel
gem 'administrate-field-image'
# For code generator in admin panel
gem "administrate-field-ckeditor", "~> 0.0.9"
# Bootstrap
gem 'bootstrap'
gem 'jquery-datatables-rails', '~> 3.4.0'
# Jquery
gem 'jquery-rails'
# Slider
gem "jquery-slick-rails"
# Gon
gem 'gon'
# Font awesome
gem "font-awesome-rails"
# Recording activity
gem 'public_activity'
# Pagination
gem 'kaminari'
# Mailer
gem 'sendgrid-actionmailer'
# SEO
gem 'meta-tags'
gem 'sitemap_generator'
# deployment
gem 'unicorn'
gem 'mina-unicorn', :require => false

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pg'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "letter_opener"
end

gem 'rspec-rails', :group => [:development, :test]
group :test do
  gem 'rspec-json_matchers', require: false
  gem 'factory_bot_rails'
  gem 'faker'
  # Adds support for Capybara saystem testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'guard-rspec', require: false
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

group :production do
  gem 'pg'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
