module Maawol
  module Models
    module Concerns
      module Mailable
        def add_to_mailchimp
          begin
            mailchimp_service = Maawol::Email::Mailchimp.new(self)
            mailchimp_service.subscribe_to_list
          rescue
          end
        end

        def send_welcome_email
          UserMailer.welcome(self).deliver_now unless self.is_admin?
        end

        def send_admin_registration_email
          AdminMailer.registration(self).deliver_now unless self.is_admin?
        end
      end
    end
  end
end