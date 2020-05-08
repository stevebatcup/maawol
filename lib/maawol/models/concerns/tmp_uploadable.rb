module Maawol
  module Models
    module Concerns
			module TmpUploadable
				extend ActiveSupport::Concern

			  def migrate_file_from_tmp_upload
			  	fields_for_upload.each do |field|
			  		attribute = tmp_media_attribute(field)
			  		if self[attribute].present?
				  		tmp_medium = TmpMedium.find(self[attribute])
					  	self.send(file_attribute_setter(field), File.new(tmp_medium.uploaded_file_url))
				  		self[attribute] = nil
				  		self.save!
				  		tmp_medium.destroy
				  	end
			  	end
			  end

			  def file_attribute_setter(field)
			  	"#{field}=".to_sym
			  end

			  def tmp_media_attribute(field)
			  	"#{field}_tmp_media_id".to_sym
			  end
			end
		end
	end
end
