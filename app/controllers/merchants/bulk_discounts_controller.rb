class  Merchants::BulkDiscountsController < ApplicationController

  def index
		@merchant = Merchant.find(params[:merchant_id])
		@discounts = @merchant.bulk_discounts
		@upcoming_holidays =  HolidaySearch.new.upcoming_holidays
  end

	def show
		@discount = BulkDiscount.find(params[:id])
		@merchant = @discount.merchant
	end

	def new
		@merchant = Merchant.find(params[:merchant_id])
		@discount = BulkDiscount.new
	end

	def create
		merchant = Merchant.find(params[:merchant_id])
		discount = merchant.bulk_discounts.create(bulk_discount_params)
		flash[:notice] = error_message(d.errors)
		redirect_to merchant_bulk_discounts_path
	end

	def edit
		@discount = BulkDiscount.find(params[:id])
	end

	def update
		discount = BulkDiscount.find(params[:id])
		merchant = discount.merchant
		discount.update(bulk_discount_params)
		flash[:notice] = error_message(discount.errors)
		redirect_to merchant_bulk_discount_path(merchant, discount)
	end

	def destroy
		bulk_discount = BulkDiscount.find(params[:id])
		# require 'pry'; binding.pry
		bulk_discount.destroy
		flash[:notice] = error_message(bulk_discount.errors)
		redirect_to merchant_bulk_discounts_path(params[:merchant_id])
	end

	private

	def bulk_discount_params
		params.require(:bulk_discount).permit(:percentage, :quantity_threshold)
	end

end