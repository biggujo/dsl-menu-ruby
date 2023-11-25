class MenuStorage
  def initialize
    @storage = []
  end

  def add(function_to_invoke)
    @storage << function_to_invoke
  end

  def add_submenu(name, submenu_storage)
    @storage << { name: name, submenu: submenu_storage }
  end

  def invoke(index)
    item = @storage[index]
    return false unless item

    if item.is_a?(Symbol)
      send(item)
      return true
    elsif item[:submenu].is_a?(MenuStorage)
      puts "Submenu"
      item[:submenu].print 
      loop do
        printf "> "
        submenu_choice = gets.to_i

        return true if submenu_choice.zero?  # Exit submenu here

        unless item[:submenu].invoke(submenu_choice - 1)
          puts "No function with the shortcut '#{submenu_choice}' has been found"
        end
      end
    else
      return false
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
    puts "0 - return"
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

  def submenu(subname, &block)
    submenu_storage = MenuBuilder.new(&block).storage
    @storage.add_submenu(subname, submenu_storage)
  end
end

class MenuRunner
  def initialize(storage)
    @storage = storage
  end

  def run
    loop do
      printf "> "
      item_by_shortcut = gets.to_i

      return if item_by_shortcut.zero?

      unless @storage.invoke(item_by_shortcut - 1)
        puts "No function with the shortcut '#{item_by_shortcut}' has been found"
      end
    end
  end
end