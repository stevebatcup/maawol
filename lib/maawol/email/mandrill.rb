module Maawol
  module Email
    module Mandrill
      extend ActiveSupport::Concern

      def requires_interception?
        if Rails.env.production?
          return false
        elsif Rails.env.staging?
          return false
        else
          return true
        end
      end

      def send_non_user_mail(to, subject, body)
        if requires_interception?
          to = Rails.application.credentials.mail[:interceptor_to]
          subject = "#{subject} [for #{to}]"
        end
        data = { to: to, subject: subject, body: body, content_type: "text/html" }
        response = mail(**data)
        log_mandrill_request(nil, "send_non_user_mail", data, response)
      end

      def send_mail(user, subject, body, email_override=nil)
        if requires_interception?
          to = Rails.application.credentials.mail[:interceptor_to]
          subject = "#{subject} [for #{user.email}]"
        else
          to = email_override.nil? ? user.email : email_override
        end
        data = { to: to, subject: subject, body: body, content_type: "text/html" }
        response = mail(**data)
        log_mandrill_request(user.id, "send_mail", data, response)
      end

      def send_admin_mail(subject, body)
        data = { to: Rails.application.credentials.mail[:admin_email], subject: subject, body: body, content_type: "text/html" }
        response = mail(**data)
        log_mandrill_request(0, "send_admin_mail", data, response)
      end

      def mandrill_template(template_name, attributes)
        mandrill = Mandrill::API.new(Rails.application.credentials.mandrill[:api_key])
        merge_vars = attributes.map do |key, value|
          { name: key, content: value }
        end
        mandrill.templates.render(template_name, [], merge_vars)["html"]
      end

      def log_mandrill_request(user_id, method, request_data, response)
        response = response.is_a?(Mail::Message) ? {status: 'success'} : nil
        ApiLog.request(
          user_id: user_id,
          service: 'mandrill',
          request_method: method,
          request_data: request_data,
          response: response,
        )
      end
    end
  end
end