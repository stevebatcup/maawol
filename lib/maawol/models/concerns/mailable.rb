module Maawol
  module Models
    module Concerns
      module Mailable
        def add_to_mailchimp
          unless Rails.env.development?
            MailchimperService.subscribe_to_mailchimp_list(self, self.determine_mailchimp_list)
          end
        end

        def send_welcome_email
          UserMailer.welcome(self).deliver_now unless self.is_admin?
        end

        def send_admin_registration_email
          AdminMailer.registration(self).deliver_now unless self.is_admin?
        end

        def determine_mailchimp_list
        	self.has_recurring_subscription? || self.status.to_sym == :complimentary ? :subscribers : :free_members
        end
      end
    end
  end
end