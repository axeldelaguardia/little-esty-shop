require 'rails_helper'

RSpec.describe Invoice, type: :model do
  let!(:merchant1) { create(:merchant) }
  let!(:merchant2) { create(:merchant) }

  let!(:customer1) { create(:customer) }
  let!(:customer2) { create(:customer) }
  let!(:customer3) { create(:customer) }
  let!(:customer4) { create(:customer) }
  let!(:customer5) { create(:customer) }
  let!(:customer6) { create(:customer) }

  let!(:invoice1) { create(:completed_invoice, created_at: DateTime.now - 12) }
  let!(:invoice2) { create(:completed_invoice, created_at: DateTime.now - 2) }
  let!(:invoice3) { create(:completed_invoice, created_at: DateTime.now - 3) }
  let!(:invoice4) { create(:completed_invoice, created_at: DateTime.now - 4) }
  let!(:invoice5) { create(:completed_invoice, created_at: DateTime.now - 5) }
  let!(:invoice6) { create(:completed_invoice, created_at: DateTime.now - 6) }
  let!(:invoice7) { create(:completed_invoice, created_at: DateTime.now - 7) }
  let!(:invoice8) { create(:completed_invoice, created_at: DateTime.now - 8) }
  let!(:invoice9) { create(:completed_invoice, created_at: DateTime.now - 9) }
  let!(:invoice10) { create(:completed_invoice, created_at: DateTime.now - 10) }
  let!(:invoice11) { create(:completed_invoice, created_at: DateTime.now - 11) }

  let!(:item1) { create(:item, merchant: merchant1) }
  let!(:item2) { create(:item, merchant: merchant1) }
  let!(:item3) { create(:item, merchant: merchant1) }
  let!(:item4) { create(:item, merchant: merchant1) }
  let!(:item5) { create(:item, merchant: merchant1) }
  let!(:item6) { create(:item, merchant: merchant2) }

  let!(:transaction1) { create(:transaction, invoice: invoice1) }
  let!(:transaction2) { create(:transaction, invoice: invoice2) }
  let!(:transaction3) { create(:transaction, invoice: invoice3) }
  let!(:transaction4) { create(:transaction, invoice: invoice4) }
  let!(:transaction5) { create(:transaction, invoice: invoice5) }
  let!(:transaction6) { create(:transaction, invoice: invoice6) }
  let!(:transaction7) { create(:transaction, invoice: invoice7) }
  let!(:transaction8) { create(:failed_transaction, invoice: invoice7) }
  let!(:transaction9) { create(:transaction, invoice: invoice8) }
  let!(:transaction10) { create(:transaction, invoice: invoice9) }
  let!(:transaction11) { create(:failed_transaction, invoice: invoice10) }
  let!(:transaction12) { create(:transaction, invoice: invoice10) }
  let!(:transaction13) { create(:transaction, invoice: invoice11) }

  let!(:invoice_item1) { create(:invoice_item, invoice: invoice1, item: item1, status: 0, quantity: 1, unit_price: 5) }
  let!(:invoice_item2) { create(:invoice_item, invoice: invoice2, item: item2, status: 1, quantity: 1, unit_price: 5) }
  let!(:invoice_item3) { create(:invoice_item, invoice: invoice2, item: item3, status: 2, quantity: 1, unit_price: 5) }
  let!(:invoice_item4) { create(:invoice_item, invoice: invoice3, item: item3, status: 2, quantity: 1, unit_price: 5) }
  let!(:invoice_item5) { create(:invoice_item, invoice: invoice4, item: item4, status: 1, quantity: 1, unit_price: 5) }
  let!(:invoice_item6) { create(:invoice_item, invoice: invoice5, item: item5, status: 0, quantity: 1, unit_price: 5) }
  let!(:invoice_item7) { create(:invoice_item, invoice: invoice5, item: item4, status: 0, quantity: 1, unit_price: 5) }
  let!(:invoice_item8) { create(:invoice_item, invoice: invoice6, item: item4, status: 2, quantity: 1, unit_price: 5) }
  let!(:invoice_item9) { create(:invoice_item, invoice: invoice7, item: item3, status: 1, quantity: 1, unit_price: 5) }
  let!(:invoice_item10) { create(:invoice_item, invoice: invoice8, item: item2, status: 0, quantity: 1, unit_price: 5) }
  let!(:invoice_item11) { create(:invoice_item, invoice: invoice9, item: item1, status: 2, quantity: 1, unit_price: 5) }
  let!(:invoice_item12) { create(:invoice_item, invoice: invoice10, item: item2, status: 1, quantity: 1, unit_price: 5) }
  let!(:invoice_item13) { create(:invoice_item, invoice: invoice10, item: item5, status: 0, quantity: 1, unit_price: 5) }
  let!(:invoice_item14) { create(:invoice_item, invoice: invoice11, item: item3, status: 0, quantity: 1, unit_price: 5) }
  let!(:invoice_item15) { create(:invoice_item, invoice: invoice11, item: item6, status: 0, quantity: 1, unit_price: 5) }

  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items)}
    it { should have_many(:merchants).through(:items) }
    it { should define_enum_for(:status).with_values(["cancelled", "in progress", "completed"])}
  end

  describe 'class methods' do
    describe '::invoice_items_not_shipped' do
      it 'lists the ids of all invoices that have items that have not shipped' do
        expect(Invoice.invoice_items_not_shipped).to eq([invoice1, invoice11, invoice10, invoice8, invoice7, invoice5, invoice4, invoice2])

        create(:invoice_item, invoice: invoice3, item: item1)

        expect(Invoice.invoice_items_not_shipped).to eq([invoice1, invoice11, invoice10, invoice8, invoice7, invoice5, invoice4, invoice3, invoice2])
      end
    end
  end

  describe 'instance_methods' do
    describe '#total_revenue' do
      it 'returns the total revenue generated for an invoice' do
        revenue = (invoice_item1.unit_price * invoice_item1.quantity)
        
        expect(invoice1.total_revenue).to eq(revenue)
       
        revenue_2 = (invoice_item2.unit_price * invoice_item2.quantity) + (invoice_item3.unit_price * invoice_item3.quantity)

        expect(invoice2.total_revenue).to eq(revenue_2)        
      end
    end

		describe '#merchant_total_revenue' do
			it 'returns the revenue for a specific merchant' do
				expect(invoice11.merchant_total_revenue(merchant1)).to eq(5)
			end
		end

    describe '#total_discounts' do
      it 'returns the total revenue generated for an invoice with discounts' do
				discount_1 = create(:bulk_discount, merchant: merchant1, quantity_threshold: 15, percentage: 0.3)
				discount_2 = create(:bulk_discount, merchant: merchant1, quantity_threshold: 10, percentage: 0.2)

        revenue = (invoice_item1.unit_price * invoice_item1.quantity)
				create(:invoice_item, invoice: invoice1, item: item1, status: 0, quantity: 10, unit_price: 5)
				create(:invoice_item, invoice: invoice1, item: item2, status: 1, quantity: 15, unit_price: 5)
				create(:invoice_item, invoice: invoice1, item: item3, status: 2, quantity: 1, unit_price: 5)

        expect(invoice1.total_discounts).to eq(32.5)
      end

			it 'example 1' do
				merchant_a = create(:merchant)
				item_a = create(:item)
				item_b = create(:item)
				invoice_a = create(:completed_invoice)
				invoice_item_a = create(:invoice_item, invoice: invoice_a, item: item_a, quantity: 5, unit_price: 5)
				invoice_item_b = create(:invoice_item, invoice: invoice_a, item: item_b, quantity: 5, unit_price: 5)
				BulkDiscount.create(merchant: merchant_a, quantity_threshold: 10, percentage: 0.2)

				expect(invoice_a.total_discounts).to eq(0.0)
			end

			it 'example 2' do
				merchant_a = create(:merchant)
				item_a = create(:item, merchant: merchant_a)
				item_b = create(:item, merchant: merchant_a)
				invoice_a = create(:completed_invoice)
				invoice_item_a = create(:invoice_item, invoice: invoice_a, item: item_a, quantity: 10, unit_price: 5)
				invoice_item_b = create(:invoice_item, invoice: invoice_a, item: item_b, quantity: 5, unit_price: 5)
				BulkDiscount.create(merchant: merchant_a, quantity_threshold: 10, percentage: 0.2)

				expect(invoice_a.total_discounts).to eq(10.0)
			end

			it 'example 3' do
				merchant_a = create(:merchant)
				item_a = create(:item, merchant: merchant_a)
				item_b = create(:item, merchant: merchant_a)
				invoice_a = create(:completed_invoice)
				invoice_item_a = create(:invoice_item, invoice: invoice_a, item: item_a, quantity: 12, unit_price: 5)
				invoice_item_b = create(:invoice_item, invoice: invoice_a, item: item_b, quantity: 15, unit_price: 5)
				BulkDiscount.create(merchant: merchant_a, quantity_threshold: 10, percentage: 0.2)
				BulkDiscount.create(merchant: merchant_a, quantity_threshold: 15, percentage: 0.3)

				expect(invoice_a.total_discounts).to eq(34.5)
			end

			it 'example 4' do
				merchant_a = create(:merchant)
				item_a = create(:item, merchant: merchant_a)
				item_b = create(:item, merchant: merchant_a)
				invoice_a = create(:completed_invoice)
				invoice_item_a = create(:invoice_item, invoice: invoice_a, item: item_a, quantity: 12, unit_price: 5)
				invoice_item_b = create(:invoice_item, invoice: invoice_a, item: item_b, quantity: 15, unit_price: 5)
				BulkDiscount.create(merchant: merchant_a, quantity_threshold: 10, percentage: 0.2)
				BulkDiscount.create(merchant: merchant_a, quantity_threshold: 15, percentage: 0.15)

				expect(invoice_a.total_discounts).to eq(27.0)
			end

			it 'example 5' do
				merchant_a = create(:merchant)
				merchant_b = create(:merchant)
				item_a1 = create(:item, merchant: merchant_a)
				item_a2 = create(:item, merchant: merchant_a)
				item_b = create(:item, merchant: merchant_b)
				invoice_a = create(:completed_invoice)
				invoice_item_a = create(:invoice_item, invoice: invoice_a, item: item_a1, quantity: 12, unit_price: 5)
				invoice_item_b = create(:invoice_item, invoice: invoice_a, item: item_a2, quantity: 15, unit_price: 5)
				invoice_item_c = create(:invoice_item, invoice: invoice_a, item: item_b, quantity: 15, unit_price: 5)
				BulkDiscount.create(merchant: merchant_a, quantity_threshold: 10, percentage: 0.2)
				BulkDiscount.create(merchant: merchant_a, quantity_threshold: 15, percentage: 0.3)

				expect(invoice_a.total_discounts).to eq(34.5)
			end

			it 'merchant_total_discounts' do
				merchant_a = create(:merchant)
				merchant_b = create(:merchant)
				item_a1 = create(:item, merchant: merchant_a)
				item_a2 = create(:item, merchant: merchant_a)
				item_b = create(:item, merchant: merchant_b)
				invoice_a = create(:completed_invoice)
				invoice_item_a = create(:invoice_item, invoice: invoice_a, item: item_a1, quantity: 12, unit_price: 5)
				invoice_item_b = create(:invoice_item, invoice: invoice_a, item: item_a2, quantity: 15, unit_price: 5)
				invoice_item_c = create(:invoice_item, invoice: invoice_a, item: item_b, quantity: 15, unit_price: 5)
				BulkDiscount.create(merchant: merchant_a, quantity_threshold: 10, percentage: 0.2)
				BulkDiscount.create(merchant: merchant_a, quantity_threshold: 15, percentage: 0.3)
				BulkDiscount.create(merchant: merchant_b, quantity_threshold: 15, percentage: 0.3)


				expect(invoice_a.merchant_total_discounts(merchant_a)).to eq(34.5)
			end
    end
  end
end
