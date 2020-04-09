module Maawol
	module Email
		class Mailchimp
			def initialize(user)
				@user = user
			end

			def subscribe_to_list
				begin
					request_data = [
						list_id,
						{ email: @user.email },
						merge_vars,
						'html', # email_type
						false,	# double_optin
						false,	# update_existing
						true,		# replace_interests
						false		# send_welcome
					]
					response = api.lists.subscribe(*request_data)
					log_request(:subscribe, request_data, response)
		    rescue ::Mailchimp::ListAlreadySubscribedError => e
		    	# raise Exception.new("It looks like the email address #{@user.email} has already been registered.")
		    rescue ::Mailchimp::Error => e
		    	# raise Exception.new(default_subscribe_error_msg)
		    rescue Exception => e
		    	# raise Exception.new(default_subscribe_error_msg)
		    end
			end

			def update_on_list(old_email_to_change=nil)
				unless @user.status.to_sym == :deleted
					begin
						vars = merge_vars
						vars[:EMAIL] = @user.email
						request_data = [
							list_id,
							{ email: old_email_to_change || @user.email },
							vars,
							'html', # email_type
							true		# replace_interests
						]
						response = api.lists.update_member(*request_data)
						log_request(:update, request_data, response)
					rescue ::Mailchimp::Error => e
						# raise e
					rescue Exception => e
						# raise e
					end
			  end
			end

			def remove_from_list
				begin
					request_data = [
						list_id,
						{ email: @user.email },
						true, # delete_member
						false,  # send_goodbye
						false  # send_notify
					]
					response = api.lists.unsubscribe(*request_data)
					log_request(:remove, request_data, response)
			    rescue ::Mailchimp::Error => e
			    	# raise e
			    end
			end

			private

			def default_subscribe_error_msg
				"Sorry there has been an error submitting your details, please try again."
			end

			def api
				@api ||= ::Mailchimp::API.new(Maawol::Config.mailchimp_api_key)
			end

			def list_id
				@list_id ||= Maawol::Config.mailchimp_list_id
			end

			def merge_vars
				{
					FNAME: @user.first_name,
					LNAME: @user.last_name,
					SITE: Maawol::Config.site_slug,
					GROUPINGS: groupings
				}
			end

			def groupings
				[
					{
						name: 'Opted into weekly digest',
						groups: [@user.receives_weekly_digest ? "Yes" : "No"]
					},
					{
						name: 'Is subscriber',
						groups: [@user.is_subscriber? ? "Yes" : "No"]
					}
				]
			end

			def log_request(method_type, request_data, response)
				ApiLog.request(
					user_id: @user.id,
		  		service: "mailchimp",
		  		request_method: method_type,
		  		request_data: request_data,
		  		response: response,
				)
			end
		end
	end
end