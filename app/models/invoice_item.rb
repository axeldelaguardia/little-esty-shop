class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
	has_many :bulk_discounts, through: :item
  enum status: ["packaged", "pending", "shipped"]

	def bulk_discount_applies?
		quantity_thresholds = item.merchant.bulk_discounts.pluck(:quantity_threshold)
		quantity_thresholds.any? { |q| quantity >= q }
	end

	def discount_applied
		bulk_discounts
		.joins(:invoice_items)
		.where(invoice_items: {id: self.id})
		.where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
		.order(percentage: :desc)
		.first
		.percentage
		.to_f / 100
	end

	def merchant
		item.merchant
	end
end