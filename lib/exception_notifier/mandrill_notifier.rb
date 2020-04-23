require 'mandrill'
require_relative '../maawol/email/mandrill'

module ExceptionNotifier
  class MandrillNotifier
	  include ::Maawol::Email::Mandrill

    def initialize(options)
      @subject = options[:subject]
      @recipient_address = options[:recipient_address]
    end

    def call(exception, options={})
    	merge_vars = {
    		EXCEPTION_MSG: exception.message,
    		EXCEPTION_BACKTRACE: exception.backtrace.inspect
    	}
			body = template('exception', merge_vars)
  	  data = mail_data(@recipient_address, @subject, body)
		  response = api.messages.send(data)
    end
  end
end