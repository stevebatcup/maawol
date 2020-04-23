require "maawol/config"
require "maawol/vendor_libs"
require "maawol/engine"
require "exception_notifier/mandrill_notifier"

module Maawol
  include Maawol::Config
  include Maawol::VendorLibs
  # include ExceptionNotifier::MandrillNotifier

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
    setup_administrate
    setup_chargebee
  end
end
