module Maawol
  module Models
    module Concerns
			module Productable
				extend ActiveSupport::Concern
				included do
					has_many :products, as: :productable, dependent: :destroy
					has_many :stores, through: :products
					has_many	:product_permissions
				end

				def set_token
				  if self.token.nil? || self.token.size == 0
				    begin
				      random_token = SecureRandom.urlsafe_base64
				    end while self.class.find_by(token: random_token)
				    self.token = random_token
				  end
				end

			end
		end
	end
end