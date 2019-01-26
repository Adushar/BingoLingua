require 'rails_helper'

RSpec.describe Test, type: :model do
  it { should belong_to(:language) }
end
