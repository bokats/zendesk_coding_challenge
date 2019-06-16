module ApplicationHelper
  def self.print_object(object)
    puts '----------------'
    object.attributes.each do |attribute, value|
      next if attribute.include?('_id') || attribute.include?('source')
      
      puts "#{attribute}: #{value}"
    end
  end
end
