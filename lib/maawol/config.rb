module Maawol
	module Config
		mattr_accessor :site_name
		@site_name = nil

		mattr_accessor :site_slug
		@site_slug = nil

		mattr_accessor :site_host
		@site_host = nil

		mattr_accessor :application_controller_class
		@@application_controller_class = 'ApplicationController'
		def self.application_controller_class
		  @@application_controller_class.constantize
		end

		mattr_accessor :application_mailer_class
		@@application_mailer_class = 'ApplicationMailer'
		def self.application_mailer_class
		  @@application_mailer_class.constantize
		end

		mattr_accessor :recaptcha_site_key
		@@recaptcha_site_key = nil

		mattr_accessor :recaptcha_secret_key
		@@recaptcha_secret_key = nil

		mattr_accessor  :mandrill_api_key
		@mandrill_api_key = nil

		mattr_accessor  :mailchimp_api_key
		@mailchimp_api_key = nil

		mattr_accessor  :mailchimp_list_id
		@mailchimp_list_id = nil

		mattr_accessor :mail_admin_to
		@@mail_admin_to = nil

		mattr_accessor :mail_interceptor_to
		@@mail_interceptor_to = nil

		mattr_accessor :mail_from
		@@mail_from = nil

		mattr_accessor :mail_reply_to
		@@mail_reply_to = nil

		mattr_accessor :aws_access_key_id
		@@aws_access_key_id = nil

		mattr_accessor :aws_secret_access_key
		@@aws_secret_access_key = nil

		mattr_accessor :aws_basket
		@@aws_basket = nil

		mattr_accessor :site_owner_fname
		@site_owner_fname = nil

		mattr_accessor :site_owner_lname
		@site_owner_lname = nil

		mattr_accessor :site_owner_email
		@site_owner_email = nil

		mattr_accessor :vimeo_api_key
		@vimeo_api_key = nil

		mattr_accessor :vimeo_project_id
		@vimeo_project_id = nil
	end
end