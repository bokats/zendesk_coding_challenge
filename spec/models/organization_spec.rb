require 'rails_helper'

RSpec.describe Organization, :type => :model do
  describe 'associations' do
    it { should have_many(:tags) }
    it { should have_many(:domain_names) }
  end
end