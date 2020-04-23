$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "maawol/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "maawol"
  spec.version     = Maawol::VERSION
  spec.authors     = ["Steve Batcup"]
  spec.email       = ["steve@maawol.com"]
  spec.homepage    = "https://github.com/stevebatcup/maawol"
  spec.summary     = "Remote music lessons platform"
  spec.description = "Remote music lessons platform"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  spec.test_files = Dir["spec/**/*"]

  spec.add_dependency "rails", "~> 6.0.0"
  spec.add_dependency "pg"
  spec.add_dependency 'acts_as_shopping_cart', '~> 0.4.0'
  spec.add_dependency "acts_as_commentable_with_threading"
  spec.add_dependency 'mandrill-api', '~> 1.0'
  spec.add_dependency 'mailchimp-api', '~> 2.0'
  spec.add_dependency "clearance", "~> 2.1"
  spec.add_dependency "browser", "~> 2.6"
  spec.add_dependency "carrierwave", "~> 2.1"
  spec.add_dependency "fog-aws", "~> 3.5"
  spec.add_dependency "recaptcha", "~> 5.2"
  spec.add_dependency "bootstrap", "~> 4.4"
  spec.add_dependency "underscore-rails"
  spec.add_dependency "ladda-rails"
  spec.add_dependency "mustache"
  spec.add_dependency "mustache-js-rails"
  spec.add_dependency "mini_magick", '>= 4.9.5'
  spec.add_dependency 'tinymce-rails', '~> 5.0'
  spec.add_dependency 'coffee-rails', '~> 5.0'
  spec.add_dependency 'angularjs-rails', '~> 1.6'
  spec.add_dependency 'angularjs-rails-resource', '~> 2.0.0'
  spec.add_dependency 'credit_card_validations', '~> 3.5'
  spec.add_dependency 'chargebee', '~>2'
  spec.add_dependency 'paypal-sdk-rest', '~> 1.7'
  spec.add_dependency 'sidekiq'
  spec.add_dependency 'exception_notification'

  spec.add_dependency "administrate", "~> 0.13"
  spec.add_dependency 'cocoon', '~> 1.2'
  spec.add_dependency 'rinku', '~> 2.0'

  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'dotenv-rails'
end
