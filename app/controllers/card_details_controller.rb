class CardDetailsController < MaawolController
	respond_to	:html

	def update
		card = params[:card]
    if error_msg = PaymentService::Chargebee.detect_card_errors(card)
    	flash[:alert] = error_msg
		else
			begin
				if subscription = current_user.current_subscription
					PaymentService::Chargebee.update_card_details(subscription, card)
					flash[:notice] = "Thanks, your card details have been updated"
				else
					flash[:alert] = "Your subscription cannot be not found"
				end
			rescue Exception => e
				flash[:alert] = e.message
			end
		end
		redirect_to settings_path
	end
end