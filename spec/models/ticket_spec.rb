require 'rails_helper'

RSpec.describe Ticket, :type => :model do
  describe 'associations' do
    it { should belong_to(:submitter) }
    it { should belong_to(:assignee) }
    it { should belong_to(:organization) }
    it { should have_many(:tags) }
  end
end