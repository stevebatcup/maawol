class MaawolMailer < Maawol::Config.application_mailer_class
  helper :application
	include Maawol::Controllers::Helpers
  include Maawol::Email::Mandrill

	default(
    from: Maawol::Config.mail_from,
    reply_to: Maawol::Config.mail_reply_to
  )

  layout 'mailer'
end