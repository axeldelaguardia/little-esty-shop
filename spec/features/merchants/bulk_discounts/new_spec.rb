require 'rails_helper'

RSpec.describe 'merchant bulk discount new page', type: :feature do
  describe "as a merchant visiting bulk discounts new page" do
    let!(:merchant_1) { create(:merchant) }
		let!(:discount_1) { create(:bulk_discount, merchant: merchant_1) }
		let!(:discount_2) { create(:better_bulk_discount, merchant: merchant_1) }

		describe 'new bulk discount' do
			it 'there is a form to add a new bulk discount' do
				visit new_merchant_bulk_discount_path(merchant_1)

				expect(page).to have_field('Percentage')
				expect(page).to have_field('Quantity Threshold')
			end

			it 'creating a new discount' do
				visit new_merchant_bulk_discount_path(merchant_1)
				
				fill_in 'Percentage', with: '50'
				fill_in 'Quantity Threshold', with: '100'
				click_button

				expect(page).to have_current_path(merchant_bulk_discounts_path(merchant_1))
			end

			it 'should have the new discount in the merchant bulk discounts index page' do
				visit new_merchant_bulk_discount_path(merchant_1)
				
				fill_in 'Percentage', with: '50'
				fill_in 'Quantity Threshold', with: '100'
				click_button

				expect(page).to have_content("Bulk Discount ##{discount_2.id}")
				expect(page).to have_content('Percentage: 50')
				expect(page).to have_content('Quantity Threshold: 100')
			end
		end
  end
end


