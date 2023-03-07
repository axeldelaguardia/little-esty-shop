class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices
  has_many :items, through: :invoice_items
  has_many :merchants, through: :invoices
	validates_presence_of :first_name, :last_name, presence: true

	before_validation :normalize_name, on: :create

  def self.top_five_customers
    joins(:transactions)
		.select("customers.*, count(result) as result_count")
		.where(transactions: {result: 'success'})
		.group(:id)
		.order(result_count: :desc)
		.limit(5)
	end
		
		private

		def normalize_name
			self.first_name = first_name.downcase.titleize
			self.last_name = last_name.downcase.titleize
		end
end
