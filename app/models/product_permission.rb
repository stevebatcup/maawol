class ProductPermission < ApplicationRecord
	belongs_to :product
	validates_presence_of	:expires_at
	before_create	:set_token
	before_create	:reset_download_count

  def self.default_expires_at
  	10.days.from_now
  end

	def reset_download_count
		self.download_count = 0
	end

	def set_token
		begin
			random_token = SecureRandom.urlsafe_base64
		end while self.class.find_by(token: random_token)
		self.token = random_token
	end

	def full_url
		if self.product.productable.is_a?(Downloadable)
			Rails.application.routes.url_helpers.download_file_url(token: self.token)
		elsif self.product.productable.is_a?(Course)
			Rails.application.routes.url_helpers.course_url(self.product.productable, token: self.token)
		end
	end
end