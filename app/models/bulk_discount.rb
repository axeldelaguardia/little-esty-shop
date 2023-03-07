class BulkDiscount < ApplicationRecord
	belongs_to :merchant
	has_many :items, through: :merchant
	has_many :invoice_items, through: :items
	has_many :invoices, through: :invoice_items
	validates :percentage, presence: true, inclusion: 0..1
	validates :quantity_threshold, presence: true

	before_destroy :pending_invoice
	before_update :pending_invoice

	private
	def pending_invoice
		if invoices.where(status: 1).empty?
			return
		end
		errors[:base] << 'There are pending invoices, cannot edit or delete'
		throw :abort
	end
end
