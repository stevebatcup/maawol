class CardDetailsController < MaawolController
	def update
		card = params[:card]
    if error_msg = PaymentService::Chargebee.detect_card_errors(card)
    	flash[:alert] = error_msg
		else
			begin
				if subscription = current_user.current_subscription
					PaymentService::Chargebee.update_card_details(subscription, card)
					flash[:notice] = t('controllers.card_details.update.success')
				else
					flash[:alert] = t('controllers.card_details.update.error')
				end
			rescue Exception => e
				flash[:alert] = e.message
			end
		end
		redirect_to settings_path
	end
end