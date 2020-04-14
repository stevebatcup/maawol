class SessionsController < Clearance::SessionsController

	private

	def url_after_create
		current_user.is_admin? ? admin_root_path : (current_user.has_full_account? ? dashboard_path : lessons_path)
	end
end