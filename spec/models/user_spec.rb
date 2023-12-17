require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:description) }
    it { should define_enum_for(:status).with_values(registered: 0, upcoming: 1) }
  end
end
