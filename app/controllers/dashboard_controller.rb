class DashboardController < MaawolController
	before_action	:require_subscription
	before_action :require_login


	def index
		@latest = Lesson.latest(6)
		@watch_laters = current_user.watch_laters.includes(:lesson)
		@favourites = current_user.favourites.includes(:lesson)
		@views = current_user.views.includes(:lesson)
	end
end