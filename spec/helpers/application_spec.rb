require 'rails_helper'

RSpec.describe ApplicationHelper do
	it 'pennies_to_dollars' do
		expect(pennies_to_dollars(100)).to eq(1.00)
	end

	it 'decimal_to_percent' do
		expect(decimal_to_percent(0.03)).to eq(3)
	end
end