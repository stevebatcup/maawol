class LessonsController < MaawolController
	include Maawol::Controllers::CourseAccess

	def index
		respond_to do |format|
			format.json do
				@lessons = Lesson.published

				if params[:search].present?
					@lessons = @lessons.search(params[:search])
				elsif params[:tag].present?
					@lessons = @lessons.joins(:tags).where("tags.slug = ?", params[:tag])
				end

				if category_is_present?
					@lessons = @lessons.in_category(category)
				elsif root_category_is_present?
					@lessons = @lessons.in_root_category(root_category)
				end

				if params[:tag].present?
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

				if root_category_is_present?
					@categories = root_category.categories
					@category_title = "#{root_category.name}"
				else
					params[:root_category] = :all
					params[:category] = :all
					@category_title = t("views.lessons.all_lessons")
					@categories = Category.order(name: :asc)
				end
			end
		end
	end

	def show
		@lesson = Lesson.find_by(slug: params[:id])
		return render_404 if lesson_not_accessible?

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

	def root_category_is_present?
		params[:root_category].present? && params[:root_category].to_sym != :all
	end

	def root_category
		RootCategory.find_by(slug: params[:root_category])
	end

	def category
		Category.find_by(slug: params[:category])
	end

	def category_is_present?
		params[:category].present? && params[:category].to_sym != :all
	end

	def lesson_not_accessible?
		@lesson.nil? || (!@lesson.is_published && !params[:preview])
	end

	helper_method	:full_access
	def full_access
		user_signed_in? && (current_user.has_full_account? || current_user.is_admin?)
	end

	def access_without_account?(lesson, course)
		lesson.is_free? || can_access_full_course_without_account(course)
	end
end