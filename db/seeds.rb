# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def parse_file(file_name)
  file_path = File.join Rails.root, 'db/seed_files/'
  file = File.read(File.join(file_path, file_name))
  JSON.parse(file)
end

organization_data = parse_file('organizations.json')
user_data = parse_file('users.json')
ticket_data = parse_file('tickets.json')

organizations = []
domain_names = []
tags = []
users = []

organization_data.each do |organization|
  organization_fields = {}
  organization.each do |key, value|
    case key
    when '_id'
      organization_fields['id'] = value
    when 'domain_names'
      organization[key].each do |domain_name|
        domain_names << {
          'value' => domain_name,
          'organization_id' => organization['_id']
        }
      end
    when 'tags'
      organization[key].each do |tag|
        tags << {
          'value' => tag,
          'source_id' => organization['_id'],
          'source_type' => 'Organization'
        }
      end
    else
      organization_fields[key] = value
    end
  end
  organizations << organization_fields
end

user_data.each do |user|
  user_fields = {}
  user.each do |key, value|
    case key
    when '_id'
      user_fields['id'] = value
    when 'tags'
      user[key].each do |tag|
        tags << {
          'value' => tag,
          'source_id' => user['_id'],
          'source_type' => 'User'
        }
      end
    else
      user_fields[key] = value
    end
  end
  users << user_fields
end

ActiveRecord::Base.transaction do
  Organization.create!(organizations)
  DomainName.create!(domain_names)
  User.create!(users)
  ticket_data.each do |ticket|
    ticket_fields = {}
    ticket.each do |key, value|
      ticket_fields[key] = value if key != 'tags'
    end
    ticket_entry = Ticket.create!(ticket_fields)
    ticket['tags'].each do |tag|
      Tag.create!(
        value: tag,
        source_id: ticket_entry.id,
        source_type: 'Ticket'
      )
    end
  end
  Tag.create!(tags)
end
