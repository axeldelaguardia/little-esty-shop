class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  
  enum status: ["cancelled", "in progress", "completed"]

  def self.invoice_items_not_shipped
    joins(:invoice_items).where.not(invoice_items: {status: 2}).distinct.order(:created_at)
  end

  def total_revenue
    self.invoice_items.sum('invoice_items.unit_price * invoice_items.quantity')
  end

	def total_discounts
		ii_with_discounts = invoice_items.joins(:bulk_discounts).where("invoice_items.quantity >= bulk_discounts.quantity_threshold").select("invoice_items.*,  MAX(bulk_discounts.percentage) as discount").group(:id)

		total_discount = InvoiceItem.select('COALESCE(SUM(ii_with_discounts.discount*ii_with_discounts.unit_price*ii_with_discounts.quantity), 0) as total').from(ii_with_discounts, :ii_with_discounts)

		total_discount.take.total
	end
end
