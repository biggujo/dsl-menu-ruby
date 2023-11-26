class MenuStorage
  attr_accessor :is_submenu

  def initialize
    @storage = []
    @is_submenu = false
  end

  def add(function_to_invoke)
    @storage << function_to_invoke
  end

  def add_submenu(name, submenu_storage)
    @storage << { name: name, add_submenu: submenu_storage }
  end

  def invoke(index)
    item = @storage[index]

    return false unless item

    if item.is_a?(Symbol)
      send(item)
      return true
    end

    if item.is_a?(Hash)
      item[:add_submenu].execute
      return true
    end

    false
  end

  def execute
    loop do
      puts @is_submenu ? "Submenu:" : "Menu"
      print

      printf "> "
      item_by_shortcut = gets.to_i

      # Exit on 0 given (0 - Return)
      return if item_by_shortcut.zero?

      unless invoke(item_by_shortcut - 1)
        puts "No function with the shortcut '#{item_by_shortcut}' has been found"
      end
    end
  end

  def print
    @storage.each_with_index do |value, index|
      if value.is_a?(Symbol)
        puts "#{index + 1} - #{value}"
      else
        puts "#{index + 1} - #{value[:name]}"
      end
    end
    puts @is_submenu ? "0 - Go back" : "0 - Quit"
  end
end

class MenuBuilder
  attr_reader :storage

  def initialize(&init_block)
    @storage = MenuStorage.new
    instance_eval(&init_block) if block_given?
  end

  def add(function_to_invoke)
    @storage.add function_to_invoke
  end

  def add_submenu(name, &block)
    submenu = MenuBuilder.new(&block)
    storage = submenu.storage
    storage.is_submenu = true

    @storage.add_submenu(name, storage)
  end
end