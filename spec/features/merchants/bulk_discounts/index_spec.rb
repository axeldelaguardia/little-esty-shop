require 'rails_helper'

RSpec.describe 'merchant bulk discount index page', type: :feature do
  describe "as a merchant visiting bulk discounts index page" do
    let!(:merchant_1) { create(:merchant) }
		let!(:discount_1) { create(:bulk_discount, merchant: merchant_1) }
		let!(:discount_2) { create(:better_bulk_discount, merchant: merchant_1) }

    let!(:merchant_2) { create(:merchant) }
		let!(:discount_3) { create(:other_bulk_discount, merchant: merchant_2) }

		describe 'all bulk discounts' do
			it 'lists all bulk discounts belonging to merchant' do
				visit merchant_bulk_discounts_path(merchant_1)
				
				within "##{discount_1.id}" do
					expect(page).to have_content("Bulk Discount #1")
					expect(page).to have_content("Percentage: #{(discount_1.percentage * 100)}%")
					expect(page).to have_content("Quantity Threshold: #{discount_1.quantity_threshold}")
				end

				expect(page).to_not have_content(discount_3.percentage)
				expect(page).to_not have_content(discount_3.quantity_threshold)
			end

			it 'has a link to each bulk discounts show page' do
				visit merchant_bulk_discounts_path(merchant_1)
				
				within "##{discount_1.id}" do
					expect(page).to have_link("Bulk Discount #1", href:  merchant_bulk_discount_path(merchant_1, discount_1))
				end

				within "##{discount_2.id}" do
					expect(page).to have_link("Bulk Discount #2", href:  merchant_bulk_discount_path(merchant_1, discount_2))
				end
			end
		end
  end
end