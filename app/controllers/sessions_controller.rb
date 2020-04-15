class SessionsController < Clearance::SessionsController

	private

	def url_after_create
		current_user.is_admin? ? admin_root_path : lessons_path
	end
end