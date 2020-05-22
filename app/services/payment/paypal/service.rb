module Payment
	module Paypal
		class Service < Payment::Service

			def initialize(options)
				super(options)
			end

			def self.log(user, action, request, result)
				ApiLog.request({
					service: :paypal,
					user_id: user ? user.id : nil,
					request_method: action,
					request_data: request,
					response: result
			  })
			end

		protected

			def log(user, action, request, result)
				self.class.log(user, action, request, result)
			end

		end
	end
end