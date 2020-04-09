require "maawol/externals"
require "maawol/config"
require "maawol/engine"

module Maawol
  include Maawol::Config

  module Controllers
    autoload :Helpers,           'maawol/controllers/helpers'
    autoload :CourseAccess,      'maawol/controllers/course_access'
  end

  module Models
    module Concerns
      autoload :Mailable,        'maawol/models/concerns/mailable'
      autoload :Productable,     'maawol/models/concerns/productable'
      autoload :Subscribable,    'maawol/models/concerns/subscribable'
      autoload :Vimeoable,       'maawol/models/concerns/vimeoable'
    end
  end

  module Email
    autoload :Mandrill,          'maawol/email/mandrill'
    autoload :Mailchimp,         'maawol/email/mailchimp'
  end

  def self.table_name_prefix
  end

  def self.configure
    yield self::Config
    initialise
  end

  def self.initialise
    setup_carrierwave
    setup_clearance
  end

  def self.setup_carrierwave
    fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     Config::aws_access_key_id,
      aws_secret_access_key: Config::aws_secret_access_key,
      region:                'us-east-1'
    }
    CarrierWave.configure do |config|
      config.fog_provider = 'fog/aws'
      config.fog_credentials = fog_credentials
      config.fog_directory  = Config::aws_basket
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
      config.mailer_sender = Config::mail_from
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
end
