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
				
				within "#discounts" do
					within "##{discount_1.id}" do
						expect(page).to have_content("Bulk Discount ##{discount_1.id}")
						expect(page).to have_content("Percentage: #{(discount_1.percentage)}%")
						expect(page).to have_content("Quantity Threshold: #{discount_1.quantity_threshold}")
					end

					within "##{discount_2.id}" do
						expect(page).to have_content("Bulk Discount ##{discount_2.id}")
						expect(page).to have_content("Percentage: #{(discount_2.percentage)}%")
						expect(page).to have_content("Quantity Threshold: #{discount_2.quantity_threshold}")
					end

					expect(page).to_not have_content(discount_3.percentage)
					expect(page).to_not have_content(discount_3.quantity_threshold)
				end
			end

			it 'has a link to each bulk discounts show page' do
				visit merchant_bulk_discounts_path(merchant_1)
				
				within "##{discount_1.id}" do
					expect(page).to have_link("Bulk Discount ##{discount_1.id}", href:  merchant_bulk_discount_path(merchant_1, discount_1))
				end

				within "##{discount_2.id}" do
					expect(page).to have_link("Bulk Discount ##{discount_2.id}", href:  merchant_bulk_discount_path(merchant_1, discount_2))
				end
			end
		end

		describe 'discount create' do
			it 'has a link to create a new discount' do
				visit merchant_bulk_discounts_path(merchant_1)

				expect(page).to have_link("Create Bulk Discount", href: new_merchant_bulk_discount_path(merchant_1))
			end

			it 'takes us to a new bulk discount page' do
				visit merchant_bulk_discounts_path(merchant_1)

				click_link "Create Bulk Discount"

				expect(page).to have_current_path(new_merchant_bulk_discount_path(merchant_1))
			end
		end

		describe 'delete bulk discount' do
			it 'has a link to delete next to each bulk discount' do
				visit merchant_bulk_discounts_path(merchant_1)

				within "##{discount_1.id}" do
					expect(page).to have_link("Delete", href: merchant_bulk_discount_path(merchant_1, discount_1))
				end

				within "##{discount_2.id}" do
					expect(page).to have_link("Delete", href: merchant_bulk_discount_path(merchant_1, discount_2))
				end
			end

			it 'clicking the delete link will remove the bulk discount from the page' do
				visit merchant_bulk_discounts_path(merchant_1)
				
				within "##{discount_1.id}" do
					click_link 'Delete'
				end

				expect(page).to_not have_content("Bulk Discount ##{discount_1.id}")
			end
		end

		describe 'upcoming holidays' do
			it 'has a section with a header of upcoming holidays' do
				visit merchant_bulk_discounts_path(merchant_1)

				within '#upcoming_holidays' do
					expect(page).to have_content('Upcoming Holidays')
					expect(page).to have_content('Memorial Day')
					expect(page).to have_content('Juneteenth')
				end
			end
		end
  end
end