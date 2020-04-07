Maawol.configure do |config|
	config.site_name = "Music Academy"

	config.application_controller_class = 'ApplicationController'

	config.recaptcha_site_key =  "my_recaptcha_site_key"
	config.recaptcha_secret_key =  "my_recaptcha_secret_key"

	# config.chargebee Rails.application.credentials[:chargebee]

	config.mail_admin_to = "admin@example.com"
	config.mail_interceptor_to = "intercept@example.com"
	config.mail_from = "from@example.com"
	config.mail_reply_to = "reply_to@example.com"
	config.mail_admin_to = "admin@example.com"

	config.site_owner_fname = "James"
	config.site_owner_lname = "McGillacuddy"
	config.site_owner_email = "james.macgillacuddy@example.com"

	config.aws_access_key_id = "my_aws_access_key_id"
	config.aws_secret_access_key = "my_aws_secret_access_key"
	config.aws_basket = "maawol"

	config.vimeo_api_key = "vimeo_api_key"
	config.vimeo_project_id = "vimeo_project_id"

end
Maawol.initialise