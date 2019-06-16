class Ticket < ActiveRecord::Base
  self.inheritance_column = nil

  belongs_to :submitter, class_name: 'User', foreign_key: 'submitter_id'
  belongs_to :assignee, class_name: 'User', foreign_key: 'assignee_id'
  belongs_to :organization
  has_many :tags, as: :source

  def render_object
    puts self.class.name
    puts '----------------'
    ApplicationHelper.print_object(self)

    puts 'Tags'
    puts '----------------'
    tags.each do |tag|
      ApplicationHelper.print_object(tag)
    end

    if organization
      puts "Organization Name: #{organization.name}"
    end

    if submitter
      puts "Submitter Name: #{submitter.name}"
    end

    if assignee
      puts "Assignee Name: #{assignee.name}"
    end
  end
end