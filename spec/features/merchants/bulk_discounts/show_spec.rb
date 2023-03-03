require 'rails_helper'

RSpec.describe 'merchant bulk discount show page', type: :feature do
  describe "as a merchant visiting bulk discounts show page" do
    let!(:merchant_1) { create(:merchant) }
		let!(:discount_1) { create(:bulk_discount, merchant: merchant_1) }
		let!(:discount_2) { create(:bulk_discount, merchant: merchant_1) }

		describe "bulk discount index page" do
			it 'shows the bulk discounts threshold quantity and discount percentage' do
				visit merchant_bulk_discount_path(merchant_1, discount_1)

				expect(page).to have_content("Bulk Discount ##{discount_1.id}")
				expect(page).to have_content("Percentage: #{discount_1.percentage}%")
				expect(page).to have_content("Quantity Threshold: #{discount_1.quantity_threshold}%")

				expect(page).to_not have_content("Bulk Discount ##{discount_2.id}")
			end
		end
	end
end