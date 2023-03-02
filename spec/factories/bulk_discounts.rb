FactoryBot.define do
  factory :bulk_discount do
    discount_percentage { "9.99" }
    quantity_threshold { 1 }
  end
end
