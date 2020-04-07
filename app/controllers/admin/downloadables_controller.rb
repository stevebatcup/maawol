module Admin
  class DownloadablesController < Admin::ApplicationController
    def order
      @order ||= Administrate::Order.new(
        params.fetch(resource_name, {}).fetch(:order, :id),
        params.fetch(resource_name, {}).fetch(:direction, :desc),
      )
    end
  end
end