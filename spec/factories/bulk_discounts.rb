FactoryBot.define do
  factory :bulk_discount do
    percentage { 0.2 }
    quantity_threshold { 10 }
		association :merchant


		trait :thirty_percent do
			percentage { 0.3 }
			quantity_threshold { 15 }
		end

		trait :five_percent do
			percentage {0.05 }
			quantity_threshold { 35 }
		end

		factory :better_bulk_discount, traits: [:thirty_percent]
		factory :other_bulk_discount, traits: [:five_percent]
	end
end
