class Admin::ApplicationController < Administrate::ApplicationController
  include Clearance::Controller
  include Maawol::Controllers::Helpers
  helper Maawol::Engine.helpers

  before_action :authenticate_admin

  rescue_from SecurityError do |exception|
    sign_out current_user if current_user
    redirect_to sign_in_path, alert: "You must be signed in as a site administrator to access that page."
  end

  def authenticate_admin
    raise SecurityError unless current_user.try(:is_admin?)
  end

  def translate_with_resource(action)
    key = controller_path.split("/").last.singularize
    t( "administrate.controller.resources.#{key}.#{action}",
      default: t(
        "administrate.controller.#{action}",
        resource: key,
      )
    ).capitalize
  end
end