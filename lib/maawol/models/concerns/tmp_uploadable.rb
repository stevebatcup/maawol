module Maawol
  module Models
    module Concerns
			module TmpUploadable
				extend ActiveSupport::Concern

			  def migrate_file_from_tmp_upload
			  	self.send("#{self.field_for_upload}=", uploaded_file_uri)
			  	self.tmp_media_id = nil
			  	self.save!
			  	associated_tmp_medium.destroy
			  end

			  def uploaded_file_uri
			  	if Rails.env.development?
				  	File.new(File.join(Rails.root, '/public' + associated_tmp_medium.media_file.url))
				  else
				  	associated_tmp_medium.media_file.url
				  end
			  end

			  def associated_tmp_medium
			  	@associated_tmp_medium ||= TmpMedium.find(self.tmp_media_id)
			  end
			end
		end
	end
end
