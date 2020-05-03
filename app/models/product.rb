class Product < ApplicationRecord
	belongs_to :store, optional: true
	belongs_to :productable, polymorphic: true
	accepts_nested_attributes_for :productable, :reject_if => :all_blank
	has_many	:product_permissions
	has_many	:payments

	def productable_gid
		productable&.to_global_id
	end

	def productable_gid=(gid)
		self.productable = GlobalID::Locator.locate gid
	end

	def self.get_options
		Downloadable.order(id: :desc).to_a + Course.order(id: :desc).to_a + AudioFile.order(id: :desc).to_a
	end
end