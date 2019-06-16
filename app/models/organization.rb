class Organization < ActiveRecord::Base
  has_many :tags, as: :source
  has_many :domain_names

  def render_object
    puts self.class.name
    ApplicationHelper.print_object(self)

    puts 'Domain names'
    puts '----------------'
    domain_names.each do |domain_name|
      ApplicationHelper.print_object(domain_name)
    end

    puts 'Tags'
    puts '----------------'
    tags.each do |tag|
      ApplicationHelper.print_object(tag)
    end
  end
end
