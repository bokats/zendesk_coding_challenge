require 'rails_helper'

RSpec.describe Search do
  describe '#initialize' do
    subject { Search.new }

    context 'when object is created' do
      it 'should create new object' do
        expect(subject).to be_kind_of(Search)
      end

      it 'should have the correct attrbitus' do
        expect(subject).to have_attributes(
          running: true,
          object: nil, 
          search_term: nil,
          search_value: nil,
          searchable_fields: {
            "1" => [
              "url", 
              "external_id", 
              "name", 
              "details", 
              "shared_tickets", 
              "created_at", 
              "_id", 
              "tags", 
              "domain_names"
            ], 
            "2" => [
              "url", 
              "external_id", 
              "name", 
              "alias", 
              "created_at", 
              "active", 
              "verified", 
              "shared", 
              "locale", 
              "timezone", 
              "last_login_at", 
              "email", 
              "phone", 
              "signature", 
              "organization_id", 
              "suspended", 
              "role", 
              "_id", 
              "tags"
              ], 
            "3" => [
              "_id", 
              "url", 
              "external_id", 
              "created_at", 
              "type", 
              "subject", 
              "description", 
              "priority", 
              "status", 
              "submitter_id", 
              "assignee_id", 
              "organization_id", 
              "has_incidents", 
              "due_at", 
              "via", 
              "_id", 
              "tags"
            ]
          }
        )
      end
    end
  end

  describe '#start_program' do
    subject do 
      search = Search.new
      search.send(:start_program)
      search
    end

    context 'when user exits' do
      it 'should change running to false' do
        allow_any_instance_of(Object).to receive(:gets).and_return('Exit')
        expect(subject).to have_attributes(running: false)
      end
    end

    context 'when incorrect input' do
      context 'when user exits the second time' do
        it 'should change running to false' do
          allow_any_instance_of(Object).to receive(:gets).and_return('na', 'Exit')
          expect(subject).to have_attributes(running: false)
        end
      end

      context 'when user starts the program' do
        it 'should change running to false' do
          allow_any_instance_of(Object).to receive(:gets).and_return('na', 'Start')
          expect(subject).to have_attributes(running: true)
        end
      end
    end

    context 'when user starts program the first time' do
      it 'should change running to false' do
        allow_any_instance_of(Object).to receive(:gets).and_return('Start')
        expect(subject).to have_attributes(running: true)
      end
    end
  end

  describe '#select_object_type' do
    subject do 
      search = Search.new
      search.send(:select_object_type)
      search
    end

    context 'when user quits' do
      it 'should change running to false' do
        allow_any_instance_of(Object).to receive(:gets).and_return('Exit')
        expect(subject).to have_attributes(running: false, object: nil)
      end
    end

    context 'when user input is invalid' do
      context 'when invalid then quit' do
        it 'should change running to false' do
          allow_any_instance_of(Object).to receive(:gets).and_return('4', 'Exit')
          expect(subject).to have_attributes(running: false, object: nil)
        end
      end
      
      context 'when invalid then valid' do
        it 'should have running as true and set object value' do
          allow_any_instance_of(Object).to receive(:gets).and_return('4', '1')
          expect(subject).to have_attributes(running: true, object: '1')
        end
      end
    end

    context 'when user input is valid the first time' do
      it 'should have running as true and set object value' do
        allow_any_instance_of(Object).to receive(:gets).and_return('1')
        expect(subject).to have_attributes(running: true, object: '1')
      end
    end
  end

  describe '#select_field_type' do
    subject do 
      search = Search.new
      search.object = '1'
      search.send(:select_field_type)
      search
    end

    context 'when user quits' do
      it 'should change running to false' do
        allow_any_instance_of(Object).to receive(:gets).and_return('Exit')
        expect(subject).to have_attributes(running: false, search_term: nil)
      end
    end

    context 'when user input is invalid' do
      context 'when invalid then quit' do
        it 'should change running to false' do
          allow_any_instance_of(Object).to receive(:gets).and_return('4', 'Exit')
          expect(subject).to have_attributes(running: false, search_term: nil)
        end
      end
      
      context 'when invalid then valid' do
        it 'should have running as true and set object value' do
          allow_any_instance_of(Object).to receive(:gets).and_return('4', 'name')
          expect(subject).to have_attributes(running: true, search_term: 'name')
        end
      end
    end

    context 'when view searchable list is selected' do
      it 'should call print_searchable_fields method' do
        allow_any_instance_of(Object).to receive(:gets).and_return('1', 'Exit')
        allow_any_instance_of(Search).to receive(:print_searchable_fields)
        subject
        expect(subject).to have_received(:print_searchable_fields).once
      end
    end

    context 'when user enters valid search term' do
      it 'should set search term' do
        allow_any_instance_of(Object).to receive(:gets).and_return('name')
        expect(subject).to have_attributes(running: true, search_term: 'name')
      end
    end
  end

  describe '#select_value' do
    subject do
      search = Search.new
      search.object = '1'
      search.send(:select_value)
      search
    end

    context 'when false is selected' do
      it 'should set search value as boolean' do
        allow_any_instance_of(Object).to receive(:gets).and_return('false')
        expect(subject).to have_attributes(running: true, search_value: false)
      end
    end

    context 'when true is selected' do
      it 'should set search value as boolean' do
        allow_any_instance_of(Object).to receive(:gets).and_return('true')
        expect(subject).to have_attributes(running: true, search_value: true)
      end
    end

    context 'when empty entry' do
      it 'should set search value as nil' do
        allow_any_instance_of(Object).to receive(:gets).and_return('')
        expect(subject).to have_attributes(running: true, search_value: nil)
      end
    end

    context 'when string is entered' do
      it 'should set the search value as the input' do
        allow_any_instance_of(Object).to receive(:gets).and_return('test')
        expect(subject).to have_attributes(running: true, search_value: 'test')
      end
    end
  end

  describe '#complete_search' do
    subject do
      search = Search.new
      search.object = object
      search.search_term = search_term
      search.search_value = search_value
      search.send(:complete_search)
    end

    context 'when search value is a string and search term is a boolean' do
      let(:object) { '1' }
      let(:search_term) { 'shared_tickets' }
      let(:search_value) { 'invalid' }
      let!(:organization) { create(:organization) }

      it 'should return nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'when search term is part of object' do
      let(:object) { '1' }
      let(:search_term) { 'url' }
      let(:search_value) { 'test' }
      let!(:organization) { create(:organization, url: 'test') }

      it 'should return nil' do
        expect(subject).to eq([organization])
      end
    end

    context 'when search term is part of related object' do
      let(:object) { '1' }
      let(:search_term) { 'tags' }
      let(:search_value) { 'test' }
      let!(:organization) { create(:organization, :with_tags) }

      it 'should return nil' do
        expect(subject).to eq([organization])
      end 
    end

    context 'when nothing is found' do
      let(:object) { '1' }
      let(:search_term) { 'url' }
      let(:search_value) { 'test' }
      let!(:organization) { create(:organization, url: 'test1') }
      
      it 'should return empty array' do
        expect(subject).to be_empty
      end
    end
  end
end