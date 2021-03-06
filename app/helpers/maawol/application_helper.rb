module Maawol
	module ApplicationHelper
		def yield_html_title
			 title = content_for?(:html_title) ? "#{content_for(:html_title)} | #{school_setting("site-name")}" : default_html_title
		end

		def html_title(title)
			content_for	:html_title, title
		end

		def default_html_title
			title = ""
			title << "#{school_setting("site-byline")}" if school_setting("site-byline").present?
			title << " | #{school_setting("site-name")}"
		end

	  def meta_tag(tag, text)
	    content_for :"meta_#{tag}", text
	  end

	  def yield_meta_tag(tag, default_text='')
	    content_for?(:"meta_#{tag}") ? content_for(:"meta_#{tag}") : default_text
	  end

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

		def render_content_block_by_slug(slug)
			block = ContentManagement::ContentBlock.find_by(slug: slug.downcase)
			render_content_block(block) unless block.nil?
		end

		def render_content_block_by_id(id)
			block = ContentManagement::ContentBlock.find_by(id: id)
			render_content_block(block) unless block.nil?
		end

		def render_content_block(block)
			render partial: "content_management/block", locals: { block: block }
		end

		def nav_item_is_current_request(nav_item)
			if nav_item.url == "/"
				request.path == "/"
			elsif nav_item.url.include?("/lessons")
				(params[:controller] == 'lessons') && (params[:action] != 'show') && (params[:root_category] == nav_item.slug)
			else
				request.path.include?(nav_item.url)
			end
		end

		def video_iframe(video)
			video.vimeo_data["html"].to_s.html_safe
		end
	end
end