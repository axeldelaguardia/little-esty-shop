require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  it { should belong_to(:merchant) }
	it { should have_many(:items).through(:merchant)}
	it { should have_many(:invoice_items).through(:items)}
	it { should have_many(:invoices).through(:invoice_items)}
	it { should validate_presence_of :percentage }
	it { should validate_inclusion_of(:percentage).in_range(0..1) }
	it { should validate_presence_of :quantity_threshold }

	describe 'pending_invoice callback' do
		it 'does not allow discount to be destroyed when there are pending invoices' do
			merchant_a = create(:merchant)
			merchant_b = create(:merchant)
			item_a1 = create(:item, merchant: merchant_a)
			item_a2 = create(:item, merchant: merchant_a)
			item_b = create(:item, merchant: merchant_b)
			invoice_a = create(:invoice)
			invoice_item_a = create(:invoice_item, invoice: invoice_a, item: item_a1, quantity: 12, unit_price: 5)
			invoice_item_b = create(:invoice_item, invoice: invoice_a, item: item_a2, quantity: 15, unit_price: 5)
			invoice_item_c = create(:invoice_item, invoice: invoice_a, item: item_b, quantity: 15, unit_price: 5)
			bd_1 = BulkDiscount.create(merchant: merchant_a, quantity_threshold: 10, percentage: 0.2)
			bd_2 = BulkDiscount.create(merchant: merchant_a, quantity_threshold: 15, percentage: 0.3)
			bd_3 = BulkDiscount.create(merchant: merchant_b, quantity_threshold: 15, percentage: 0.3)

			expect(bd_1.destroy).to be(false)

			invoice_a.update status: 2

			bd_1.destroy

			expect(BulkDiscount.all).to_not include(bd_1)
		end
	end
end
