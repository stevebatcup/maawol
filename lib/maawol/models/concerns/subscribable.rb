module Maawol
  module Models
    module Concerns
			module Subscribable
				def subscription_status
				  if self.is_subscriber?
				  	if current_recurring_subscription.present? || self.future_recurring_subscription.present?
				  		"Recurring subscription. <br />Next payment due on #{current_subscription.next_payment_due_at.strftime("%A %B %d, %Y")}".html_safe
				  	elsif current_ending_subscription.present?
				  		"Recurring payments have been cancelled and their subscription expires on #{current_ending_subscription.ends_at.strftime("%A %B %d, %Y")}"
				  	end
				  else
				    false
				  end
				end

				def find_or_create_pending_paypal_subscription(options)
					if subscription = self.subscriptions.find_by(status: :pending_paypal)
						subscription.initial_price = options[:initial_price]
						subscription.subscription_option_id = options[:subscription_option].id
						subscription.starts_at = options[:future_start].nil? ? Time.now : options[:future_start]
						subscription.updated_at = Time.now
					else
						subscription = self.subscriptions.build({
							status: :pending_paypal,
							payment_system: :paypal,
							initial_price: options[:initial_price],
							subscription_option_id: options[:subscription_option].id,
							successful_recurring_payments: 0,
							starts_at: options[:future_start].nil? ? Time.now : options[:future_start],
						})
					end

					if options[:discount_code].present?
						discount_code = DiscountCode.find_by_code(options[:discount_code])
						subscription.discount_code_id = discount_code.id
					end
					subscription.save
					subscription
				end

				def get_pending_paypal_subscription
					self.subscriptions.where(status: :pending_paypal).last
				end

				def build_new_subscription(options)
					subscription = self.subscriptions.build({
						status: :recurring,
						payment_system: :chargebee,
						initial_price: options[:initial_price],
						subscription_option_id: options[:subscription_option].id,
						successful_recurring_payments: 0,
						remote_customer_id: options[:remote_subscription].customer.id,
						remote_subscription_id: options[:remote_subscription].subscription.id,
						starts_at: options[:future_start].nil? ? Time.now : options[:future_start],
						next_payment_due_at: calculate_next_payment_date(options[:remote_subscription], options[:future_start], options[:subscription_option].months),
					})
					subscription.discount_code_id = options[:discount_code].id if options[:discount_code].present?
					subscription
				end

				def calculate_next_payment_date(remote_result, future_start, months)
					if future_start.present?
						future_start
					else
						Time.at(remote_result.subscription.current_term_end).to_datetime
					end
				end

				def is_subscriber?
					self.current_recurring_subscription.present? || self.current_ending_subscription.present?  || self.future_recurring_subscription.present?
				end

				def current_subscription
					if current_recurring_subscription.present?
						current_recurring_subscription
					elsif future_recurring_subscription.present?
						future_recurring_subscription
					elsif current_ending_subscription.present?
						if future_recurring_subscription.present?
							# we may be on a current-ending sub now but we still return an
							# ordered recurring sub which has not yet started
							future_recurring_subscription
						else
							current_ending_subscription
						end
					else
						nil
					end
				end

				def has_recurring_subscription?
					current_recurring_subscription.present? || future_recurring_subscription.present?
				end

				def future_recurring_subscription
					self.subscriptions.where(status: :recurring).where("starts_at > ?", Time.now).first
				end

				def current_recurring_subscription
					self.subscriptions.where(status: :recurring).where("starts_at <= ?", Time.now).first
				end

				def current_ending_subscription
					self.subscriptions.where(status: :ending)
						.where("ends_at > ?", Time.now)
						.order(ends_at: :desc)
						.first
				end

				def has_current_ending_card_subscription?
					ending_sub = self.current_ending_subscription
					ending_sub.present? && ending_sub.is_card?
				end

				def has_current_ending_paypal_subscription?
					ending_sub = self.current_ending_subscription
					ending_sub.present? && ending_sub.is_paypal?
				end

				def cancel_all_subscriptions
					self.subscriptions.where.not(status: :cancelled).each do |subscription|
						subscription.cancel(:account_cancelled)
					end
				end

				def subscribed_within_one_day?
					current_subscription && current_subscription.within_one_day?
				end

				def subscription_created
					current_subscription.created_at.strftime("%H:%M on %B %d, %Y")
				end

				def subscription_referring_author
					Author.find_by(id: referral_author_id) unless referral_author_id.nil?
				end

				def subscription_referring_author_name
					if author = subscription_referring_author
						author.name
					end
				end

				def is_paying_by_card?
					self.has_recurring_subscription? && !self.current_subscription.is_paypal?
				end

			end
		end
	end
end