require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BingoLingua
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.assets.precompile += %w( resources/* )
    config.serve_static_assets = true
    config.middleware.use Rack::Deflater
    config.assets.precompile += %w(ckeditor/* ckeditor/lang/*)

    config.action_mailer.default_url_options = { :host => 'bingolinguo.club' }
    ActionMailer::Base.smtp_settings = {
      :address        => "smtp.sendgrid.net",
      :port           => "25",
      :authentication => :plain,
      :user_name      => 'apikey',
      :password       => Rails.application.secrets.mailer,
      :domain         => 'bingolinguo.club'
    }


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
