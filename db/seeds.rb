# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

file_path = File.join Rails.root, 'db/seed_files/'
file = File.read(File.join(file_path, 'organizations.json'))
organization_data = JSON.parse(file)

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
          'domain_name' => domain_name,
          'organization_id' => organization['_id']
        }
      end
    when 'tags'
      organization[key].each do |tag|
        tags << {
          'tag_name' => tag,
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

file_path = File.join Rails.root, 'db/seed_files/'
file = File.read(File.join(file_path, 'users.json'))
user_data = JSON.parse(file)

user_data.each do |user|
  user_fields = {}
  user.each do |key, value|
    case key
    when '_id'
      user_fields['id'] = value
    when 'tags'
      user[key].each do |tag|
        tags << {
          'tag_name' => tag,
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

file_path = File.join Rails.root, 'db/seed_files/'
file = File.read(File.join(file_path, 'tickets.json'))
ticket_data = JSON.parse(file)

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
        tag_name: tag,
        source_id: ticket_entry.id,
        source_type: 'Ticket'
      )
    end
  end
  Tag.create!(tags)
end
