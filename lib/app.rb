require_relative '../config/load_initializers'

class App
  attr_accessor :keep_going

  def self.call
    new
  end

  def initialize
    @keep_going = true
    @menu = Menu.new
    run
  end

  private

  def run
    Repo.load_repos
  
    while keep_going
      STDOUT.clear_screen
      @menu.display_menu
      trigger_option if keep_going?
    end
  end

  def keep_going?
    @user_option = gets.chomp.to_i
    self.keep_going = false if @menu.options[@user_option] == :exit
    self.keep_going
  end

  def trigger_option
    STDOUT.clear_screen
    call_method_from_class
  end

  def call_method_from_class
    class_name = @menu.options[@user_option].to_s.split('_').last
    class_action = @menu.options[@user_option].to_s.split('_').first

    class_name = format_class_name(class_name)

    class_constant = Object.const_get(class_name)
    class_constant.send(class_action)
  end

  def format_class_name(class_name)
    if class_name.chars.last == 's'
      class_name.slice(0, class_name.length - 1).capitalize
    else
      class_name.capitalize
    end
  end
end

App.call
