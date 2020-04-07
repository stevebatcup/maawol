class Product < ApplicationRecord
	belongs_to :store, optional: true
	belongs_to :productable, polymorphic: true
	accepts_nested_attributes_for :productable, :reject_if => :all_blank
	has_many	:product_permissions
	has_many	:payments

	before_save	:get_attributes_from_full_id

	def productable_full_id=(productable_full_id)
		@productable_full_id = productable_full_id
	end

	def productable_full_id
		@productable_full_id ||= (self.productable ? "#{self.productable_type.downcase}_#{self.productable_id}" : nil)
	end

	def get_attributes_from_full_id
		unless @productable_full_id.nil?
			n, i = @productable_full_id.split("_")
			self.productable_type = n.capitalize.constantize
			self.productable_id = i
		end
	end

	def self.get_options
		Downloadable.order(id: :desc).to_a + Course.order(id: :desc).to_a
	end
end