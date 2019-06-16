# the method that is called externally in order to start the search program
class Main
  def self.run_main_program
    s = Search.new
    s.run_program
  end
end
