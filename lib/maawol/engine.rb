module Maawol
  class Engine < ::Rails::Engine
    config.generators do |generators|
      generators.test_framework :rspec
      generators.fixture_replacement :factory_bot
      generators.factory_bot dir: 'spec/factories'
    end

    initializer "maawol.assets.precompile" do |app|
      app.config.assets.precompile += %w(
      	cocoon.js
      	administrate/application.js
      	administrate/application.css
      	admin.js
      	admin/overrides.css
        mobile/overrides.css
        tablet/overrides.css
      	subscribe/visa.png
      	subscribe/mastercard.png
      	subscribe/paypal.png
      	subscribe/paypal-checkout.png
      	subscribe/comodo.png
        no-avatar.png
      )
    end
  end
end
