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

		  def paypal_settings
		    template "config/paypal.yml", "config/paypal.yml"
		  end

		  def database_config
		    template "config/database.yml", "config/database.yml"
		  end

		  def git_ignore_template
		    template ".ignore.sample", ".gitignore"
		    template ".ignore.sample", ".dockerignore"
		  end

		  def nginx_conf
		    template "config/nginx.conf", "config/nginx.conf"
		  end

		  def locales
				template "config/locales/en.yml", "config/locales/maawol.en.yml"
				template "config/locales/admin.en.yml", "config/locales/admin.en.yml"
				template "config/locales/clearance.en.yml", "config/locales/clearance.en.yml"
		  end

		  def routes
		    template "config/routes.rb", "config/routes.rb"
		  end

		  def db_seeds
	  		copy_file "seeds.rb", "db/seeds/maawol.rb"
	  		inject_into_file "db/seeds.rb" do <<-'RUBY'
	  			Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each { |seed| load seed }
	  		RUBY
	  		end
		  end
		end
	end
end