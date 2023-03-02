require 'rails_helper'

RSpec.describe 'merchant bulk discount new page', type: :feature do
  describe "as a merchant visiting bulk discounts new page" do
    let!(:merchant_1) { create(:merchant) }
		let!(:discount_1) { create(:bulk_discount, merchant: merchant_1) }
		let!(:discount_2) { create(:better_bulk_discount, merchant: merchant_1) }

		describe 'new bulk discount' do
			it 'there is a form to add a new bulk discount' do
				visit new_merchant_bulk_discount_path(merchant_1)

				expect(page).to have_field(:percentage)
				expect(page).to have_field(:quantity_threshold)
			end
		end
  end
end


