# config valid for current version and patch releases of Capistrano
lock "~> 3.10.0"

set :application, "jdr"
set :repo_url, "git@github.com:BigDilettante/jazzdrummersresource.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/jdr/production"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/application.yml", "config/paypal.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", '.bundle', "bin"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 2

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.5.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value


namespace :deploy do
	task :stop_unicorn do
    on roles(:web) do
			execute "/var/www/jdr/production/shared/config/restart_unicorn stop"
		end
  end
	task :regenerate_bins do
    on roles(:web) do
      within release_path do
	      execute :bundle, 'binstubs bundler --force'
	      execute :bundle, 'binstubs unicorn'
	      execute :bundle, 'binstubs railties'
	    end
    end
  end
	task :start_unicorn do
    on roles(:web) do
			execute "/var/www/jdr/production/shared/config/restart_unicorn start"
		end
  end
	before  :finishing, :stop_unicorn
	after  :finishing, :regenerate_bins
	after  :regenerate_bins, :start_unicorn
end

