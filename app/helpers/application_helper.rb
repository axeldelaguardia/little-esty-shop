module ApplicationHelper
	def pennies_to_dollars(number)
		number/100.0
	end

	def decimal_to_percent(decimal)
		decimal*100
	end
end
