# frozen_string_literal: true

require 'rails/generators/base'

module Maawol
  module Generators
  	class InstallGenerator < Rails::Generators::Base
			desc "Installing maawol files..."
			source_root File.expand_path("../../templates", __FILE__)

		  def initializers
		    template "config/initializers/maawol.rb", "config/initializers/maawol.rb"
		    template "config/initializers/mustache.rb", "config/initializers/mustache.rb"
		  end

		  def credentials_templates
		    template "config/credentials.development.sample.yml", "config/_credentials.development.sample.yml"
		    template "config/credentials.production.sample.yml", "config/_credentials.production.sample.yml"
		  end

		  def paypal_settings
		    template "config/paypal.yml", "config/paypal.yml"
		  end

		  def dockerfile
		    template "Dockerfile", "Dockerfile"
		  end

		  def git_ignore_template
		    template ".gitignore.sample", ".gitignore"
		  end

		  def locales
				template "config/locales/en.yml", "config/locales/maawol.en.yml"
				template "config/locales/admin.en.yml", "config/locales/admin.en.yml"
				template "config/locales/clearance.en.yml", "config/locales/clearance.en.yml"
		  end

		  def routes
		    template "config/routes.rb", "config/routes.rb"
		  end
		end
	end
end