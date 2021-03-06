module Maawol
  module Email
    module Mandrill
      # extend ActiveSupport::Concern

      def send_mail(email_address, subject, body, recipient_name=nil, recipient_id=nil, email_override=nil)
        begin
          if requires_interception?
            email_address = Maawol::Config.mail_interceptor_to
            subject = "#{subject} [for #{email_address}]"
          else
            email_address = email_override.nil? ? email_address : email_override
          end
          data = mail_data(email_address, subject, body, recipient_name)
          response = api.messages.send(data)
          log_request(recipient_id, "send_mail", data, response)
        rescue Exception => e
          log_request(nil, :mandrill_send_mail, data, { error: e.message, backtrace: e.backtrace })
        end
      end

      def send_admin_mail(subject, body)
        begin
          data = mail_data(SiteSetting.admin_email_address, subject, body)
          response = api.messages.send(data)
          log_request(nil, "send_admin_mail", data, response)
        rescue Exception => e
          log_request(nil, :mandrill_send_admin_mail, data, { error: e.message, backtrace: e.backtrace })
        end
      end

      def mail_data(email_address, subject, body, recipient_name=nil)
        data = {
          subject: subject,
          html: body,
          from_email: Maawol::Config.mail_from,
          from_name: Maawol::Config.site_name,
          to: [
            {
              email: email_address,
              name: recipient_name || email_address,
              type: 'to'
            }
          ],
          headers: { 'Reply-To': Maawol::Config.mail_reply_to },
          merge: true
        }
      end

      def template(template_name, vars)
        begin
          merge_vars = vars.merge(site_vars).map { |key, value| { name: key, content: value } }
          api.templates.render(template_name, [], merge_vars)["html"]
        rescue Exception => e
          log_request(nil, :mandrill_template, merge_vars, { error: e.message, backtrace: e.backtrace })
        end
      end

      protected

      def site_vars
        {
          FROM_NAME: Maawol::Config.site_name,
          FROM_EMAIL: Maawol::Config.mail_from,
          ADMIN_NAME: Maawol::Config.site_owner_fname,
          SITE_NAME: Maawol::Config.site_name,
          SITE_HOST: Maawol::Config.site_host,
          SITE_HEADER_IMG: SiteImage.email_banner_url,
        }
      end

      def requires_interception?
        if Rails.env.production?
          return false
        elsif Rails.env.staging?
          return false
        else
          return true
        end
      end

      def api
        @api ||= ::Mandrill::API.new(Maawol::Config.mandrill_api_key)
      end

      def log_request(user_id, method, request_data, response)
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