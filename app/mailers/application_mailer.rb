module Maawol
	class ApplicationMailer < ActionMailer::Base
	  helper :application
	  include MandrillMailer
		default(
	    from: Rails.application.credentials.mail[:from],
	    reply_to: Rails.application.credentials.mail[:reply_to]
	  )
	  layout 'mailer'
	end
end