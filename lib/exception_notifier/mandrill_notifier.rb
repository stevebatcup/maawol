require 'mandrill'
require_relative '../maawol/email/mandrill'

module ExceptionNotifier
  class MandrillNotifier
	  include ::Maawol::Email::Mandrill

    attr_accessor :subject
    attr_accessor :recipient_address

    def initialize(options)
      @subject = options[:subject]
      @recipient_address = options[:recipient_address]
    end

    def call(exception, options={})
      env_vars = []
      unless options[:env].nil?
        env = options[:env]
        env_vars = [
          "Method: #{env['REQUEST_METHOD']}",
          "Path: #{env['REQUEST_PATH']}",
          "Uri:  #{env['REQUEST_URI']}",
          "Query: #{env['QUERY_STRING']}",
          "Host: #{env['HTTP_HOST']}",
          "Browser: #{env['HTTP_USER_AGENT']}",
        ]
      end
    	merge_vars = {
    		EXCEPTION_MSG: exception.message,
        EXCEPTION_ENV_VARS: env_vars.join("<br />"),
    		EXCEPTION_BACKTRACE: exception.backtrace.inspect
    	}
			body = template('exception', merge_vars)
  	  data = mail_data(@recipient_address, @subject, body)
		  response = api.messages.send(data)
    end
  end
end