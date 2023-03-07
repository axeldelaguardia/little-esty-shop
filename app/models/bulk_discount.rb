class BulkDiscount < ApplicationRecord
	belongs_to :merchant
	has_many :items, through: :merchant
	has_many :invoice_items, through: :items
	validates :percentage, presence: true, inclusion: 0..1
	validates :quantity_threshold, presence: true
end
