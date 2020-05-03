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
        themes/light-blue.css
        themes/light-red.css
        themes/light-green.css
        themes/dark-blue.css
        themes/dark-red.css
        themes/dark-green.css
      	subscribe/visa.png
      	subscribe/mastercard.png
      	subscribe/paypal.png
      	subscribe/paypal-checkout.png
      	subscribe/comodo.png
        no-avatar.png
        lessons/no-thumbnail.png
        transparent-pixel.png
        transparent-100x67.png
      )
    end
  end
end
