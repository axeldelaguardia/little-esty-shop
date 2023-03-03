FactoryBot.define do
  factory :bulk_discount do
    percentage { 20.0 }
    quantity_threshold { 10 }
		association :merchant


		trait :thirty_percent do
			percentage { 30.0 }
			quantity_threshold { 15 }
		end

		trait :five_percent do
			percentage {5.0 }
			quantity_threshold { 35 }
		end

		factory :better_bulk_discount, traits: [:thirty_percent]
		factory :other_bulk_discount, traits: [:five_percent]
	end
end
