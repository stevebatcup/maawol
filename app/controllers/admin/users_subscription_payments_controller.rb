module Admin
  class UsersSubscriptionPaymentsController < Admin::ApplicationController
    def valid_action?(name, resource = resource_class)
      %w[edit new destroy].exclude?(name.to_s) && super
    end

    def order
      @order ||= Administrate::Order.new(
        params.fetch(resource_name, {}).fetch(:created_at, :id),
        params.fetch(resource_name, {}).fetch(:direction, :desc),
      )
    end
  end
end