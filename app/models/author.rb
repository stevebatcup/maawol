class Author < ApplicationRecord
	has_many	:lessons
	has_many	:courses
	has_many	:downloadables
	has_one	:user

	mount_uploader :avatar, AuthorAvatarUploader

	before_save	:set_referral_token

	def set_referral_token
		if self.referral_token.nil? || self.referral_token.size == 0
		  begin
		    random_token = SecureRandom.hex(6)
		  end while self.class.find_by(referral_token: random_token)
		  self.referral_token = random_token
		end
	end

	def referral_registration_url
		self.referral_token.present? ? Rails.application.routes.url_helpers.sign_up_url(referral: self.referral_token) : ''
	end

	def referral_home_url
		self.referral_token.present? ? Rails.application.routes.url_helpers.root_url(referral: self.referral_token) : ''
	end
end