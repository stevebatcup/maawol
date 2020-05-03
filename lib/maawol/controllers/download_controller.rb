module Maawol
	module Controllers
		module DownloadController
			extend ActiveSupport::Concern

			def download_resource
				if @resource.nil?
					if permission = ProductPermission.find_by(token: params[:token])
						if permission.expires_at > Time.now
							@resource = permission.product.productable
							permission.increment!(:download_count)
						end
					end
				end

				if @resource.present?
					 file_data = open(@resource.file.url) { |f| f.read }
					 send_data file_data, filename: filename_for_download, type: @resource.file.content_type, disposition: 'attachment'
				else
					render_404
				end

			end
		end
	end
end