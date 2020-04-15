class MaawolController < Maawol::Config.application_controller_class
  include Clearance::Controller
	include Maawol::Controllers::Helpers
	helper Maawol::Engine.helpers

	protect_from_forgery with: :exception

	skip_before_action :verify_authenticity_token, if: :json_request?
	before_action :set_device_type
	before_action :set_referral_session, if: :can_set_referral_session?

	layout	:set_layout

	def render_404
		respond_to do |format|
			format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
			format.xml  { head :not_found }
			format.any  { head :not_found }
		end
	end

	def set_layout
		"#{signed_in? ? 'maawol' : 'home'}"
	end

	def require_subscription
		unless signed_in? && current_user.can_access_dashboard?
			flash[:alert] = "Sorry, that page requires a subcription"
			redirect_to lessons_path
		end
	end

	def set_device_type
		request.variant = browser.device.mobile? ? :mobile : :desktop
	end

	def json_request?
		request.format.json?
	end

	def can_set_referral_session?
		params[:referral].present? && !signed_in?
	end

	def set_referral_session
		if author = Author.find_by(referral_token: params[:referral])
			session[:referral_author_id] = author.id
		end
	end
end