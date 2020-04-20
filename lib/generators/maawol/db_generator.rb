# frozen_string_literal: true

require 'rails/generators/base'

module Maawol
  module Generators
  	class DbGenerator < Rails::Generators::Base
			desc "Setting up maawol db..."
			source_root File.expand_path("../../templates", __FILE__)

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
		  	rake "db:seed"
		  end
		end
	end
end
