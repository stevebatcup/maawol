class CoursesController < MaawolController
	before_action :require_login, only: [:index]

	include Maawol::Controllers::CourseAccess

	def index
		if(params[:skill_level])
			level = params[:skill_level]
			@skill_level = SkillLevel.find(level).name
			@courses = Course.published.joins(:skill_levels).where(skill_levels: { id: [level] })
		else
			@courses = Course.published.order(:name)
		end
	end

	def show
		if params[:slug]
			@course = Course.find_by(slug: params[:slug])
		elsif params[:id]
			@course = Course.find(params[:id])
		end
	end
end