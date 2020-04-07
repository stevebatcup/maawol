class ProductPayment < ApplicationRecord
	belongs_to :product

	def item_name
		self.product.productable.name
	end

	def item_type
		self.product.productable_type
	end

	def author_fee
		percentage = self.product.author_fee_split.to_i
		"%.2f" % (amount * (percentage.to_f / 100))
	end

	def author_name
		self.product.productable.author.name
	end

	def user_name
		"#{self.first_name} #{self.last_name}"
	end

	def user_email
		self.email
	end

	def processed_at
		self.created_at.strftime("%H:%M on %B %d, %Y")
	end
end