class MigrateTmpMediaFileJob < ApplicationJob
  queue_as :site_image

  def perform(site_image)
  	site_image.migrate_file_from_tmp_upload
  end
end