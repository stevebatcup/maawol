module Maawol
	module Controllers
		module CourseAccess
			extend ActiveSupport::Concern

			included do
				helper_method	:can_access_full_course_without_account
			end

			def can_access_full_course_without_account(course=nil)
				@can_access_full_course_without_account ||= begin
					return false if course.nil?
					if params[:token].present? && (permission = ProductPermission.find_by(token: params[:token]))
						permission.product.productable.id == course.id
					else
						false
					end
				end
			end
		end
	end
end