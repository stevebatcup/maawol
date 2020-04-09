# frozen_string_literal: true

require 'rails/generators/base'

module Maawol
  module Generators
  	class DbGenerator < Rails::Generators::Base
			desc "Setting up maawol db..."
			source_root File.expand_path("../../templates", __FILE__)

			def database_config
			  template "database.yml", "config/database.yml"
			end

			def setup
				rake "db:create"
				rake "db:schema:load"
				rake "db:migrate"
			end

		  def migrations
		  	rake "maawol_engine:install:migrations"
		  	rake "db:migrate"
		  end

		  def seed
		  	copy_file "../../../db/seeds.rb", "db/seeds/maawol.rb"
		  	inject_into_file "db/seeds.rb" do <<-'RUBY'
		  		Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each { |seed| load seed }
		  	RUBY
		  	end
		  	rake "db:seed"
		  end
		end
	end
end
