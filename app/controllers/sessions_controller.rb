class SessionsController < Clearance::SessionsController

	private

	def url_after_create
		lessons_path
	end

	def url_after_destroy
		root_path
	end
end