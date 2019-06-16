require 'rails_helper'

RSpec.describe User, :type => :model do
  describe 'associations' do
    it { should belong_to(:organization) }
    it { should have_many(:assigned_tickets) }
    it { should have_many(:tags) }
  end
end