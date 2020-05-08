module Maawol
  module Models
    module Concerns
			module TmpUploadable
				extend ActiveSupport::Concern

			  def migrate_file_from_tmp_upload
			  	self.send(file_attribute_setter, File.new(uploaded_file_uri))
			  	self[tmp_media_attribute] = nil
			  	self.save!
			  	associated_tmp_medium.destroy
			  end

			  def file_attribute_setter
			  	"#{field_for_upload}=".to_sym
			  end

			  def tmp_media_attribute
			  	"#{field_for_upload}_tmp_media_id".to_sym
			  end

			  def uploaded_file_uri
			  	if Rails.env.development?
				  	File.join(Rails.root, '/public' + associated_tmp_medium.media_file.url)
				  else
				  	associated_tmp_medium.media_file.url
				  end
			  end

			  def associated_tmp_medium
			  	@associated_tmp_medium ||= TmpMedium.find(self[tmp_media_attribute])
			  end
			end
		end
	end
end
