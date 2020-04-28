class DashboardController < MaawolController
	before_action	:require_subscription

	def index
		@watch_laters = current_user.watch_laters.includes(:lesson)
		@favourites = current_user.favourites.includes(:lesson)
		@views = current_user.views.includes(:lesson)
		@personalised_lessons = current_user.lessons
	end
end