class LessonsController < MaawolController
	include Maawol::Controllers::CourseAccess

	def index
		respond_to do |format|
			format.json do
				if params[:search]
					@lessons = Lesson.published.search(params[:search])
				elsif params[:tag]
					@lessons = Lesson.joins(:tags).where("tags.slug = ?", params[:tag]).published
				elsif params[:root_category] && params[:root_category].to_i > 0
					root_category = RootCategory.find(params[:root_category])
					if params[:category] && params[:category].to_i > 0
						category = Category.find(params[:category])
						@lessons = Lesson.in_category(params[:category].to_i).published
					else
						@lessons = Lesson.in_root_category(params[:root_category].to_i).published
					end
				else
					@lessons = Lesson.published
				end

				if params[:tag]
					@total = @lessons.size if params[:page].to_i == 1
					@lessons = @lessons.page(params[:page] ||= 1).per(results_per_page)
				else
					@total = @lessons.where(course_only: false).size if params[:page].to_i == 1
					@lessons = @lessons.where(course_only: false).page(params[:page] ||= 1).per(results_per_page)
				end

				if full_access
					@lessons = @lessons.order(publish_date: :desc)
				else
					@lessons = @lessons.order(is_free: :desc, publish_date: :desc)
				end
				@lessons = @lessons.includes(:videos).references(:videos).includes(:categories).references(:categories)
			end

			format.html do
				return redirect_to(root_path) unless signed_in?
				@root_categories = RootCategory.all
				if params[:root_category] && params[:root_category].to_i > 0
					@categories = Category.where(root_category_id: params[:root_category])
					root_category = RootCategory.find(params[:root_category])
					if params[:category] && params[:category].to_i > 0
						category = Category.find(params[:category])
						@category_title = "#{root_category.name} > #{category.name}"
					else
						@category_title = "#{root_category.name}"
					end
				end
			end
		end
	end

	def show
		@lesson = Lesson.find_by(slug: params[:id])
		redirect_to(root_path) if !@lesson.is_published && !params[:preview]

		if params[:from_course].present?
			@course = Course.find(params[:from_course])
		elsif @lesson.courses.any?
			@course = @lesson.courses.first
		else
			@course = nil
		end

		redirect_to lessons_path, alert: t('views.lesson.must_register') unless full_access || access_without_account?(@lesson, @course)
	end

private

	helper_method	:full_access
	def full_access
		user_signed_in? && current_user.has_full_account?
	end

	def access_without_account?(lesson, course)
		lesson.is_free? || can_access_full_course_without_account(course)
	end
end