# handles the search logic and user interaction
class Search
  NUMBER_TO_OBJECT_MAP = {
    '1' => Organization,
    '2' => User,
    '3' => Ticket
  }

  attr_accessor :running, :object, :search_term, 
    :search_value, :searchable_fields

  def initialize
    @running = true
    @object = nil
    @search_term = nil
    @search_value = nil
    @searchable_fields = {}
    set_searchable_fields
  end

  def run_program
    start_program
    return if !@running
    
    object_result = select_object_type
    return if !@running

    field_result = select_field_type
    return if !@running

    value_result = select_value
    return if !@running

    complete_search
  end

  private

  # sets the fields for each object that user is allowed to pick
  def set_searchable_fields
    NUMBER_TO_OBJECT_MAP.each do |num, object|
      @searchable_fields[num] = object.column_names - ['id']
    end
  
    @searchable_fields.each do |key, _|
      @searchable_fields[key] += ['_id', 'tags']
    end

    @searchable_fields['1'] << 'domain_names'
  end

  # handles the initial logic of starting the search program
  def start_program
    puts 'Type Start to begin program or type Exit to close it at any time'
    user_response = gets.chomp
    while user_response != 'Exit' && user_response != 'Start'
      puts 'Incorrect input'
      puts 'Type Start to begin program or type Exit to close it at any time'
      user_response = gets.chomp
    end
    @running = false if user_response == 'Exit'
  end

  # handles the selection of overall object
  def select_object_type
    puts 'Select 1 for Organizations, 2 for Users, 3 for Tickets or Exit to quit program'
    user_response = gets.chomp
    while !['1', '2', '3', 'Exit'].include?(user_response)
      puts 'Incorrect input'
      puts 'Select 1 for Organizations, 2 for Users, 3 for Tickets'
      user_response = gets.chomp
    end
    if user_response == 'Exit'
      @running = false
    else
      @object = user_response
    end
  end

  # handles the selection of search term
  def select_field_type
    puts "Enter the name of your search term, enter 1 to see searchable fields or enter 'Exit' to quit the program"
    user_response = gets.chomp
    while !['1','Exit'].include?(user_response) && !@searchable_fields[@object].include?(user_response)
      puts 'Incorrect input'
      puts "Enter the name of your search term, enter 1 to see searchable fields or enter 'Exit' to quit the program"
      user_response = gets.chomp
    end

    if user_response == 'Exit'
      @running = false
    elsif user_response == '1'
      print_searchable_fields
      select_field_type
    else
      @search_term = user_response
    end
  end

  # handles the selection of search value
  def select_value
    puts 'Enter Search Value'
    user_response = gets.chomp
    if user_response == 'true'
      @search_value = true
    elsif user_response == 'false'
      @search_value = false
    elsif user_response == ''
      @search_value = nil
    else
      @search_value = user_response
    end
  end

  # the method that cleans up the data and runs the query
  def complete_search
    if is_boolean? && !!@search_value != @search_value
      puts 'No result found'
      return
    end
    if NUMBER_TO_OBJECT_MAP[@object].column_names.include?(@search_term)
      results = NUMBER_TO_OBJECT_MAP[@object].where("#{@search_term}" => @search_value)
    else
      results = NUMBER_TO_OBJECT_MAP[@object].joins(@search_term.to_sym).where("#{@search_term}" => { value: @search_value })
    end
    
    if !results.empty?
      puts 'Result'
      puts '-------------'
      results.each do |result|
        result.render_object
      end
    else
      puts 'No result found'
    end
    results
  end

  # method for printing searching fields for the selected object
  def print_searchable_fields
    puts
    puts 'Searchable fields'
    puts '-----------------'
    @searchable_fields[@object].each { |field| puts field }
    puts '-----------------'
  end

  # determines if the search term is part of boolean column
  def is_boolean?
    column = NUMBER_TO_OBJECT_MAP[@object].columns.find { |col| col.name == @search_term }
    column && column.type == :boolean
  end
end