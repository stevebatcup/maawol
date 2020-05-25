module Maawol
	module ProductHelper
		def can_be_accessed_by_user_without_purchase?(item)
			if item.is_a?(Downloadable)
				signed_in? && item.token.present? && current_user.can_download_files_without_purchase?
			elsif item.is_a?(Course)
				true
			else
				false
			end
		end

		def product_access_url(item)
			if item.is_a?(Downloadable)
				download_file_url(token: item.token)
			elsif item.is_a?(Course)
				course_by_slug_path(slug: item.slug)
			end
		end

		def product_access_label(item)
			if item.is_a?(Downloadable)
				"Download"
			elsif item.is_a?(Course)
				"View course"
			end
		end

		def download_iconise(item)
			if item.is_a?(Downloadable)
				icon_class = 'fas fa-music'
			elsif item.is_a?(Course)
				icon_class = 'fa fa-file'
			elsif item.is_a?(AudioFile)
				icon_class = 'fas fa-file-audio'
			end
			"<i class='#{icon_class} mr-2'></i> #{item.name}".html_safe
		end
	end
end