class HomeController < MaawolController
	layout	'home'

	def index
		if signed_in?
			redirect_to	user_redirect_url
		else
			@latest_lessons = Lesson.latest(4)
			@contact = Contact.new
		end
	end
end