Maawol.configure do |config|
	config.site_name = "Music Academy"
	config.site_slug = "music_academy"
	config.site_host = ENV['HOST']

	config.currency_code = "GBP"
	config.currency_symbol = "£"

	config.site_owner_fname = "James"
	config.site_owner_lname = "McGillacuddy"
	config.site_owner_email = "james.macgill@maawol.com"

	config.application_controller_class = 'ApplicationController'
	config.application_mailer_class = 'ApplicationMailer'

	config.recaptcha_site_key =  ENV['RECAPTCHA_SITE_KEY']
	config.recaptcha_secret_key =  ENV['RECAPTCHA_SECRET_KEY']

	config.mandrill_api_key = ENV['MAIL_MANDRILL_API_KEY']
	config.mailchimp_api_key = ENV['MAIL_MAILCHIMP_API_KEY']
	config.mailchimp_list_id = ENV['MAIL_MAILCHIMP_LIST_ID']

	config.mail_from = ENV['MAIL_FROM']
	config.mail_reply_to = ENV['MAIL_REPLY_TO']
	config.mail_admin_to = ENV['MAIL_ADMIN_TO']
	config.mail_interceptor_to = ENV['MAIL_INTERCEPTOR_TO']

	config.aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
	config.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
	config.aws_basket = "maawol"

	config.vimeo_api_key = ENV['VIMEO_API_KEY']
	config.vimeo_project_id = ENV['VIMEO_PROJECT_ID']

	config.chargebee_site = ENV['CHARGEBEE_SITE']
	config.chargebee_api_key = ENV['CHARGEBEE_API_KEY']
	config.chargebee_gateway = ENV['CHARGEBEE_GATEWAY']

	config.paypal_client_id = ENV['PAYPAL_CLIENT_ID']
	config.paypal_client_secret = ENV['PAYPAL_CLIENT_SECRET']
end