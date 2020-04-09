class MaawolMailer < Maawol.application_mailer_class
  helper :application
	include Maawol::Controllers::Helpers
  include Maawol::Email::Mandrill

	default(
    from: Maawol.mail_from,
    reply_to: Maawol.mail_reply_to
  )

  layout 'mailer'
end