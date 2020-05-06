class TmpMedium < ApplicationRecord
	mount_uploader	:media_file, TmpMediaUploader

	def file_extension_whitelist
		case self.attributes['file_type'].to_sym
		when :image
			%w(jpg jpeg gif png)
		when :audio_file
			%w(mp3 wav ogg)
		when :document
			%w(pdf doc docx)
		when :video
			%w(mp4 mov wmv avi flv)
		end
	end

	def uploads_url
		url = self.media_file.url
		if Rails.env.development?
			url
		else
			uploads_str_pos = url.index("/uploads")
			url[uploads_str_pos..-1]
		end
	end
end
