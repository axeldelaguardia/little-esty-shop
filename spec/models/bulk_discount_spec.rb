require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  it { should belong_to(:merchant) }
	it { should validate_presence_of :percentage }
	it { should validate_inclusion_of(:percentage).in_range(0..1) }
	it { should validate_presence_of :quantity_threshold }
end
