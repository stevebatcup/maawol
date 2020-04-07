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
			end
		end
	end
end