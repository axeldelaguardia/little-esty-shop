require 'rails_helper'

RSpec.describe 'merchant bulk discount edit page', type: :feature do
  describe "as a merchant visiting bulk discounts edit page" do
    let!(:merchant_1) { create(:merchant) }
		let!(:discount_1) { create(:bulk_discount, merchant: merchant_1) }
		let!(:discount_2) { create(:bulk_discount, merchant: merchant_1) }

		before do
			visit edit_merchant_bulk_discount_path(merchant_1, discount_1)
		end
