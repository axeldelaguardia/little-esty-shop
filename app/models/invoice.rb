class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  
  enum status: ["cancelled", "in progress", "completed"]

	scope :invoice_items_not_shipped, -> { joins(:invoice_items)
																				 .where.not(invoice_items: {status: 2})
																				 .distinct.order(:created_at) }

  def total_revenue
  	invoice_items.sum('invoice_items.unit_price * invoice_items.quantity')
  end

	def merchant_total_revenue(merchant)
		invoice_items
		.where(item_id: merchant.items.ids)
		.sum("invoice_items.unit_price * invoice_items.quantity")
	end

	def total_discounts
		ii_with_discounts = invoice_items.joins(:bulk_discounts)
												.where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
												.select("invoice_items.*,  MAX(bulk_discounts.percentage) as discount")
												.group(:id)

		total_discount = InvoiceItem.select('COALESCE(SUM(ii_with_discounts.discount*ii_with_discounts.unit_price*ii_with_discounts.quantity), 0) as total')
										.from(ii_with_discounts, :ii_with_discounts)

		total_discount.take.total
	end

	def merchant_total_discounts(merchant)
		ii_with_discounts = invoice_items.joins(:bulk_discounts)
		.where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
		.where(item_id: merchant.items.ids)
		.select("invoice_items.*,  MAX(bulk_discounts.percentage) as discount")
		.group(:id)

		total_discount = InvoiceItem.select('COALESCE(SUM(ii_with_discounts.discount*ii_with_discounts.unit_price*ii_with_discounts.quantity), 0) as total')
		.from(ii_with_discounts, :ii_with_discounts)

		total_discount.take.total
	end

	def merchant_revenue_after_discount(merchant)
		merchant_total_revenue(merchant) - merchant_total_discounts(merchant)
	end
end