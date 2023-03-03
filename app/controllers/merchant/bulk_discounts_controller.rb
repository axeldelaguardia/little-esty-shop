class  Merchant::BulkDiscountsController < ApplicationController

  def index
		@merchant = Merchant.find(params[:merchant_id])
		@discounts = @merchant.bulk_discounts
  end

	def new
		@merchant = Merchant.find(params[:merchant_id])
		@discount = BulkDiscount.new
	end

	def create
		merchant = Merchant.find(params[:merchant_id])
		merchant.bulk_discounts.create(bulk_discount_params)
		redirect_to merchant_bulk_discounts_path
	end

	private

	def bulk_discount_params
		params.require(:bulk_discount).permit(:percentage, :quantity_threshold)
	end

end