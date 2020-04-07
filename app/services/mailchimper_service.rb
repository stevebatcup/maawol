require 'mailchimp'

module Maawol
	module MailchimperService
		MAILCHIMP_SERVICE_FOR_API_LOG = "mailchimp"
		GROUPING_LABEL_WEEKLY_DIGEST = 'Opted into weekly digest'

		class << self

			def mailchimp_api
				Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])
			end

			def mailchimp_list_id(name=:free_members)
				ENV["MAILCHIMP_LIST_ID_#{name.to_s.upcase}"]
			end

			def mailchimp_groupings(user)
				[
					{ name: MailchimperService::GROUPING_LABEL_WEEKLY_DIGEST, groups: [user.receives_weekly_digest ? "Yes" : "No"] }
				]
			end

			def merge_vars(user)
				{
					FNAME: user.first_name,
					LNAME: user.last_name,
					GROUPINGS: mailchimp_groupings(user)
				}
			end

			def subscribe_to_mailchimp_list(user, list_name=:free_members)
				standard_error = "Sorry there has been an error submitting your details, please try again."
				begin
					request_data = [
						mailchimp_list_id(list_name),
						{ email: user.email },
						merge_vars(user),
						'html', # email_type
						false,	# double_optin
						false,	# update_existing
						true,		# replace_interests
						false		# send_welcome
					]
					response = mailchimp_api.lists.subscribe(*request_data)
					log_mailchimp_request(user, :subscribe, request_data, response)
		    rescue Mailchimp::ListAlreadySubscribedError => e
		    	raise Exception.new("It looks like the email address #{user.email} has already been registered with TheArticle.")
		    rescue Mailchimp::Error => e
		    	raise Exception.new(standard_error)
		    rescue Exception => e
		    	raise Exception.new(standard_error)
		    end
			end

			def update_mailchimp_list(user, email_on_mailchimp)
				unless user.status.to_sym == :deleted
					begin
						vars = merge_vars(user)
						vars[:EMAIL] = user.email
						request_data = [
							mailchimp_list_id(user.determine_mailchimp_list),
							{ email: email_on_mailchimp },
							vars,
							'html', # email_type
							true		# replace_interests
						]
						response = mailchimp_api.lists.update_member(*request_data)
						log_mailchimp_request(user, :update, request_data, response)
					rescue Mailchimp::Error => e
						raise e
					rescue Exception => e
						raise e
					end
			  end
			end

			def remove_from_mailchimp_list(user, list_name=:free_members)
				begin
					request_data = [
						mailchimp_list_id(list_name),
						{ email: user.email },
						true, # delete_member
						false,  # send_goodbye
						false  # send_notify
					]
					response = mailchimp_api.lists.unsubscribe(*request_data)
					log_mailchimp_request(user, :remove, request_data, response)
			    rescue Mailchimp::Error => e
			    	raise e
			    end
			end

			def upgrade_to_subscription_list(user)
				self.remove_from_mailchimp_list(user, :free_members)
				self.subscribe_to_mailchimp_list(user, :subscribers)
			end

			def downgrade_to_free_members_list(user)
				self.remove_from_mailchimp_list(user, :subscribers)
				self.subscribe_to_mailchimp_list(user, :free_members)
			end

			def log_mailchimp_request(user, method_type, request_data, response)
				ApiLog.request(
					user_id: user.id,
		  		service: MailchimperService::MAILCHIMP_SERVICE_FOR_API_LOG,
		  		request_method: method_type,
		  		request_data: request_data,
		  		response: response,
				)
			end
		end
	end
end