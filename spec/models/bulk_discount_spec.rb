require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  it { should belong_to(:merchant) }
end
