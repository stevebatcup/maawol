# frozen_string_literal: true

require 'rails/generators/base'

module Maawol
  module Generators
  	class SetupGenerator < Rails::Generators::Base
			desc "Setting up maawol..."
			source_root File.expand_path("../../templates", __FILE__)

		  def copy_initializers
		    template "maawol.rb", "config/initializers/maawol.rb"
		    template "mustache.rb", "config/initializers/mustache.rb"
		  end

		  def copy_locales
				copy_file "../../../config/locales/en.yml", "config/locales/maawol.en.yml"
				copy_file "../../../config/locales/admin.en.yml", "config/locales/admin.en.yml"
				copy_file "../../../config/locales/clearance.en.yml", "config/locales/clearance.en.yml"
		  end

		  def run_migrations
		  	rake "maawol_engine:install:migrations"
		  	rake "db:migrate"
		  end

		  def copy_seeds
				copy_file "../../../db/seeds.rb", "db/seeds/maawol.rb"
				inject_into_file "db/seeds.rb" do <<-'RUBY'
					Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each { |seed| load seed }
				RUBY
				end
		  end

		  def update_asset_manifest
		  	inject_into_file "app/assets/config/manifest.js" do
		  		"\n//= link_tree ../javascripts js"
		  	end
		  end
		end
	end
end