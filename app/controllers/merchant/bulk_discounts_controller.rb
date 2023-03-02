class  Merchant::BulkDiscountsController < ApplicationController

  def index
		@merchant = Merchant.find(params[:merchant_id])
		@discounts = @merchant.bulk_discounts
  end

	def new
		@discount = BulkDiscount.new
	end

	def create
		require 'pry'; binding.pry
	end

end