require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should define_enum_for(:status).with_values(["packaged", "pending", "shipped"])}
  end

	let!(:merchant1) { create(:merchant)}

  let!(:item1) {create(:item, merchant: merchant1) }  
  let!(:item2) {create(:item, merchant: merchant1) }
  let!(:item3) {create(:item, merchant: merchant1) }
  let!(:item4) {create(:item, merchant: merchant1) }
  let!(:item5) {create(:item, merchant: merchant1) }

  let!(:customer1) {create(:customer) }
  let!(:customer2) {create(:customer) }

  let!(:invoice1) {create(:invoice, created_at: Date.new(2020, 1, 2), customer: customer1) }
  let!(:invoice2) {create(:invoice, created_at: Date.new(2019, 3, 9), customer: customer2) }

  let!(:discount_1) {create(:bulk_discount, merchant: merchant1, quantity_threshold: 15, percentage: 30.0) }
  let!(:discount_2) {create(:bulk_discount, merchant: merchant1, quantity_threshold: 10, percentage: 20.0) }

  before(:each) do
    @invoice_item1 = create(:invoice_item, invoice: invoice1, item: item1, quantity: 1)
    @invoice_item2 = create(:invoice_item, invoice: invoice1, item: item2, quantity: 1)
    @invoice_item3 = create(:invoice_item, invoice: invoice1, item: item3, quantity: 1)
		@invoice_item4 = create(:invoice_item, invoice: invoice1, item: item4, quantity: 1)
    @invoice_item5 = create(:invoice_item, invoice: invoice2, item: item5, quantity: 16)
  end

	describe ':class method' do
		it '#bulk_discount_applies?' do
			expect(@invoice_item1.bulk_discount_applies?).to be(false)
			expect(@invoice_item4.bulk_discount_applies?).to be(false)

			@invoice_item4 = create(:invoice_item, invoice: invoice1, item: item4, quantity: 10)

			expect(@invoice_item4.bulk_discount_applies?).to be(true)
		end

		it '#discount_applied' do
			expect(@invoice_item5.discount_applied).to eq(0.3)
		end
	end

	describe '#instance methods' do
		it '#merchant' do
			expect(@invoice_item1.merchant).to eq(merchant1)
		end
	end
end
