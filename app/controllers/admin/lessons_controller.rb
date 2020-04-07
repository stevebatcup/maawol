module Admin
  class LessonsController < Admin::ApplicationController
    def order
      @order ||= Administrate::Order.new(
        params.fetch(resource_name, {}).fetch(:order, :publish_date),
        params.fetch(resource_name, {}).fetch(:direction, :desc),
      )
    end
  end
end