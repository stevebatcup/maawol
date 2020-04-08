require 'coffee-rails'
require 'clearance'
require 'browser'
require 'acts_as_commentable_with_threading'
require 'acts_as_shopping_cart'
require 'carrierwave'
require 'fog-aws'
require 'recaptcha'
require 'bootstrap'
require 'underscore-rails'
require 'ladda-rails'
require 'mustache'
require 'mustache-js-rails'
require 'mini_magick'
require 'sidekiq'

require 'angularjs-rails'
require 'angularjs-rails-resource'
require 'vimeo_me2'

# Payment APIs
require 'credit_card_validations'
require 'chargebee'
require 'paypal-sdk-rest'

# Email APIs
require 'mandrill'
require "mandrill_mailer"
require 'mailchimp'

# Admin
require 'tinymce-rails'
require 'administrate'
require 'cocoon'
require 'rinku'

require "maawol/engine"

module Maawol

  mattr_accessor :site_name
  @site_name = nil

  mattr_accessor :site_host
  @site_host = nil

  mattr_accessor :application_controller_class
  @@application_controller_class = 'ApplicationController'
  def self.application_controller_class
    @@application_controller_class.constantize
  end

  mattr_accessor :application_mailer_class
  @@application_mailer_class = 'ApplicationMailer'
  def self.application_mailer_class
    @@application_mailer_class.constantize
  end

  mattr_accessor :recaptcha_site_key
  @@recaptcha_site_key = nil

  mattr_accessor :recaptcha_secret_key
  @@recaptcha_secret_key = nil

  mattr_accessor  :mandrill_api_key
  @mandrill_api_key = nil

  mattr_accessor  :mailchimp_api_key
  @mailchimp_api_key = nil

  mattr_accessor :mail_admin_to
  @@mail_admin_to = nil

  mattr_accessor :mail_interceptor_to
  @@mail_interceptor_to = nil

  mattr_accessor :mail_from
  @@mail_from = nil

  mattr_accessor :mail_reply_to
  @@mail_reply_to = nil

  mattr_accessor :aws_access_key_id
  @@aws_access_key_id = nil

  mattr_accessor :aws_secret_access_key
  @@aws_secret_access_key = nil

  mattr_accessor :aws_basket
  @@aws_basket = nil

  mattr_accessor :site_owner_fname
  @site_owner_fname = nil

  mattr_accessor :site_owner_lname
  @site_owner_lname = nil

  mattr_accessor :site_owner_email
  @site_owner_email = nil

  mattr_accessor :vimeo_api_key
  @vimeo_api_key = nil

  mattr_accessor :vimeo_project_id
  @vimeo_project_id = nil

  def self.table_name_prefix
  end

  def self.configure
    yield self
  end

  def self.initialise
    setup_carrierwave
    setup_clearance
  end

  def self.setup_carrierwave
  	fog_credentials = {
  	  provider:              'AWS',
  	  aws_access_key_id:     @@aws_access_key_id,
  	  aws_secret_access_key: @@aws_secret_access_key,
  	  region:                'us-east-1'
  	}
  	CarrierWave.configure do |config|
  	  config.fog_provider = 'fog/aws'
  	  config.fog_credentials = fog_credentials
  	  config.fog_directory  = @@aws_basket
  	end
  	Fog::Storage.new(fog_credentials).sync_clock
  end

  def self.setup_clearance
    Clearance.configure do |config|
      config.routes = false
      config.allow_sign_up = true
      config.cookie_expiration = lambda { |cookies| 1.year.from_now.utc }
      config.cookie_name = "remember_token"
      config.cookie_path = "/"
      config.httponly = false
      config.mailer_sender = @@mail_from
      config.redirect_url = "/dashboard"
      config.rotate_csrf_on_sign_in = true
      config.secure_cookie = false
      config.sign_in_guards = []
      config.parent_controller = "MaawolController"
      config.user_model = "User"
      # config.cookie_domain = ".example.com"
      # config.password_strategy = Clearance::PasswordStrategies::BCrypt
    end
  end

	module Controllers
	  autoload :Helpers,        'maawol/controllers/helpers'
	  autoload :CourseAccess,   'maawol/controllers/course_access'
	end

  module Models
    module Concerns
      autoload :Mailable,        'maawol/models/concerns/mailable'
      autoload :Productable,     'maawol/models/concerns/productable'
      autoload :Subscribable,    'maawol/models/concerns/subscribable'
      autoload :Vimeoable,       'maawol/models/concerns/vimeoable'
    end
  end

end
