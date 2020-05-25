require 'clearance'
require 'acts_as_commentable_with_threading'
require 'acts_as_shopping_cart'
require 'sidekiq'
require 'exception_notification'
require 'httparty'

# Views
require 'browser'
require 'coffee-rails'
require 'bootstrap'
require 'underscore-rails'
require 'mustache'
require 'mustache-js-rails'
require 'angularjs-rails'
require 'angularjs-rails-resource'
require 'recaptcha'

# Images/files/videos
require 'carrierwave'
require 'fog-aws'
require 'mini_magick'
require 'vimeo_me2'

# Payment APIs
require 'credit_card_validations'
require 'chargebee'
require 'paypal-sdk-rest'

# Email APIs
require 'mandrill'
require 'mailchimp'

# Admin
require 'tinymce-rails'
require 'administrate'
require 'cocoon'
require 'rinku'
require 'dropzonejs-rails'

module Maawol
	module VendorLibs
		extend ActiveSupport::Concern

		module ClassMethods
			def setup_carrierwave
			  fog_credentials = {
			    provider:              'AWS',
			    aws_access_key_id:     Config.aws_access_key_id,
			    aws_secret_access_key: Config.aws_secret_access_key,
			    region:                'us-east-1'
			  }
			  CarrierWave.configure do |config|
			    config.fog_credentials = fog_credentials
			    config.fog_directory  = Config.aws_basket
			  end
			  Fog::Storage.new(fog_credentials).sync_clock
			end

			def setup_clearance
			  Clearance.configure do |config|
			    config.routes = false
			    config.allow_sign_up = true
			    config.cookie_expiration = lambda { |cookies| 1.year.from_now.utc }
			    config.cookie_name = "#{Config.site_slug}_remember_token"
			    config.cookie_path = "/"
			    config.httponly = false
			    config.mailer_sender = Config.mail_from
			    config.redirect_url = "/lessons"
			    config.rotate_csrf_on_sign_in = true
			    config.secure_cookie = false
			    config.sign_in_guards = []
			    config.parent_controller = "MaawolController"
			    config.user_model = "User"
			    config.password_strategy = Clearance::PasswordStrategies::BCrypt
			  end
			end

			def setup_administrate
			  Administrate::Engine.add_javascript :'tinymce'
			  Administrate::Engine.add_javascript :'admin'
			end

			def setup_chargebee
				ChargeBee.configure(:site => Config.chargebee_site,  :api_key => Config.chargebee_api_key)
			end
		end
	end
end