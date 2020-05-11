# frozen_string_literal: true

require 'rails/generators/base'

module Maawol
  module Generators
  	class DbGenerator < Rails::Generators::Base
			desc "Setting up maawol db..."
			source_root File.expand_path("../../templates", __FILE__)

		  def copy_migrations
		  	rails "maawol_engine:install:migrations"
		  end

		  def setup
		  	rails "db:setup"
		  end
		end
	end
end
