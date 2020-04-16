module Admin
  class SubscriptionOptionsController < Admin::ApplicationController
  	def valid_action?(name, resource = resource_class)
  	  %w[edit new destroy].exclude?(name.to_s) && super
  	end
  end
end