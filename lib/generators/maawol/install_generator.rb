# frozen_string_literal: true

require 'rails/generators/base'

module Maawol
  module Generators
  	class InstallGenerator < Rails::Generators::Base
			desc "Installing maawol files..."
			source_root File.expand_path("../../templates", __FILE__)

		  def initializers
		    template "maawol.rb", "config/initializers/maawol.rb"
		    template "mustache.rb", "config/initializers/mustache.rb"
		  end

		  def credentials_templates
		    template "credentials-development.yml", "config/_credentials-development.yml"
		    template "credentials-production.yml", "config/_credentials-production.yml"
		  end

		  def git_ignore_template
		    template "gitignore_tpl", ".gitignore"
		  end

		  def locales
				copy_file "../../../config/locales/en.yml", "config/locales/maawol.en.yml"
				copy_file "../../../config/locales/admin.en.yml", "config/locales/admin.en.yml"
				copy_file "../../../config/locales/clearance.en.yml", "config/locales/clearance.en.yml"
		  end

		  def routes
		    template "routes.rb", "config/routes.rb"
		  end
		end
	end
end