module Maawol
	module ApplicationHelper
		def linked_skills_list(items)
			linked_items = []
			items.each do |item|
				linked_items << link_to(item.name, "/courses?skill_level=#{item.id}")
			end
			linked_items.join(", ").html_safe
		end

		def comment_for_mustache(comment, can_reply=false)
			{
				id: comment.id,
				firstName: comment.user.display_name,
				photo: comment.user.avatar.url(:thumbnail),
				body: simple_format(comment.body),
				timeActual: comment.created_at.strftime("%Y-%m-%d %H:%M"),
				timeHuman: comment.created_at.strftime("%b %e, %Y at %H:%M"),
				canReply: can_reply
			}
		end

		def render_content_block_by_name(name)
			block = ContentManagement::ContentBlock.find_by(name: name.downcase)
			render_content_block(block) unless block.nil?
		end

		def render_content_block_by_id(id)
			block = ContentManagement::ContentBlock.find_by(id: id)
			render_content_block(block) unless block.nil?
		end

		def render_content_block(block)
			render partial: "content_management/block", locals: { block: block }
		end

		def html_title
			@html_title ||= begin
				title = "#{site_setting("Site name")}"
				title << " | #{site_setting("Site byline")}" if site_setting("Site byline").present?
			end
		end

		def nav_item_is_current_request(nav_item)
			if nav_item.url == "/"
				request.path == "/"
			else
				request.path.include?(nav_item.url)
			end
		end

		def video_iframe(video)
			video.vimeo_data["html"].to_s.html_safe
		end
	end
end