Maawol.configure do |config|
	config.site_name = "Music Academy"
	config.site_slug = "music_academy"
	config.site_host = Rails.application.credentials.host

	config.site_owner_fname = "James"
	config.site_owner_lname = "McGillacuddy"
	config.site_owner_email = "james.macgill@maawol.com"

	config.application_controller_class = 'ApplicationController'
	config.application_mailer_class = 'ApplicationMailer'

	config.recaptcha_site_key =  Rails.application.credentials.recaptcaha[:site_key]
	config.recaptcha_secret_key =  Rails.application.credentials.recaptcaha[:secret_key],

	config.mandrill_api_key = Rails.application.credentials.mail[:mandrill_api_key]
	config.mailchimp_api_key = Rails.application.credentials.mail[:mailchimp_api_key]
	config.mailchimp_list_id = Rails.application.credentials.mail[:mailchimp_list_id]

	config.mail_from = Rails.application.credentials.mail[:from]
	config.mail_reply_to = Rails.application.credentials.mail[:reply_to]
	config.mail_admin_to = Rails.application.credentials.mail[:admin_to]
	config.mail_interceptor_to = Rails.application.credentials.mail[:interceptor_to]

	config.aws_access_key_id = Rails.application.credentials.aws[:access_key_id]
	config.aws_secret_access_key = Rails.application.credentials.aws[:secret_access_key]
	config.aws_basket = "maawol"

	config.vimeo_api_key = Rails.application.credentials.vimeo[:api_key]
	config.vimeo_project_id = Rails.application.credentials.vimeo[:project_id]

	# config.chargebee Rails.application.credentials[:chargebee]
end