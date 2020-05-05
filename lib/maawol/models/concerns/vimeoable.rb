module Maawol
  module Models
    module Concerns
      module Vimeoable
      	def perform_upload_to_vimeo_job
      		self.vimeo_data = nil
      	  migrate_file_from_tmp_upload
      	  UploadVideoToVimeoJob.set(wait: 1.minute).perform_later(self)
      	end

    	  def upload_to_vimeo
    	  	video_file = File.open(tmp_video_file.file.file)
			    remote_video_data = vimeo_client.upload_video(video_file, **{name: self.name})
			    puts remote_video_data.inspect

			    remote_id = remote_id_from_uri(remote_video_data['uri'])
			    add_remote_video_to_folder(remote_id, Maawol::Config.vimeo_project_id)

			    sleep(20)
			    update_local(remote_video_data, remote_id)
			    true
			  rescue VimeoMe2::RequestFailed => e
			    self.errors.add(:video_file, e.message)
			    throw(:abort)
			  end

			  def remote_id_from_uri(uri)
			    uri.gsub(/\/videos\//, '')
			  end

			  def vimeo_client
			    @vimeo_client ||= VimeoMe2::User.new(Maawol::Config.vimeo_api_key)
			  end

			  def update_remote_video_name(video_id, name)
			    video = VimeoMe2::Video.new(Maawol::Config.vimeo_api_key, video_id)
			    video.name = name
			    video.update
			  end

			  def add_remote_video_to_folder(video_id, folder_id)
			    vimeo_client.add_video_to_folder(folder_id, video_id)
			  end

			  def update_local(remote_data, remote_id)
			    self.update({
			      url: remote_data['link'],
			      vimeo_id: remote_id,
			      vimeo_data: remote_data["embed"],
			      status: :uploaded,
			      tmp_video_file: nil
			    })
			  end

			  def delete_from_vimeo
			    begin
			      v = VimeoMe2::Video.new(Maawol::Config.vimeo_api_key, self.vimeo_id)
			      v.destroy
			    rescue
			    end
			  end
			end
		end
	end
end
