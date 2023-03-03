require 'rails_helper'

RSpec.describe 'merchant bulk discount edit page', type: :feature do
  describe "as a merchant visiting bulk discounts edit page" do
    let!(:merchant_1) { create(:merchant) }
		let!(:discount_1) { create(:bulk_discount, merchant: merchant_1) }
		let!(:discount_2) { create(:bulk_discount, merchant: merchant_1) }

		before do
			visit edit_merchant_bulk_discount_path(merchant_1, discount_1)
		end

		describe 'edit bulk discount' do
			it 'has a form to update fields with current values pre-filled' do
				expect(page).to have_field('Percentage', with: '20.0')
				expect(page).to have_field('Quantity Threshold', with: '10')
				expect(page).to have_button('Update Bulk discount')
			end

			it 'changing information and submitting updates the status in show page' do
				fill_in 'Percentage', with: '30.0'
				fill_in 'Quantity Threshold', with: '15'
				click_button 'Update Bulk discount'

				expect(current_path).to eq(merchant_bulk_discount_path(merchant_1, discount_1))
				
				expect(page).to have_content("Percentage: 30.0%")
				expect(page).to have_content("Quantity Threshold: 15")
			end
		end
	end
end