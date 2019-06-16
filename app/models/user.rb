class User < ActiveRecord::Base
  belongs_to :organization
  has_many :assigned_tickets, class_name: 'Ticket', foreign_key: 'assignee_id'
  has_many :tags, as: :source

  def render_object
    puts self.class.name
    puts '----------------'
    ApplicationHelper.print_object(self)

    if organization
      puts "Organization Name: #{organization.name}"
    end

    puts 'Tags'
    puts '----------------'
    tags.each do |tag|
      ApplicationHelper.print_object(tag)
    end

    if !assigned_tickets.empty?
      puts 'Assigned Tickets'
      puts '----------------'
      assigned_tickets.each do |ticket|
        ApplicationHelper.print_object(ticket)
      end
    end
  end
end