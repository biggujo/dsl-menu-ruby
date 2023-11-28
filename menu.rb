require 'rainbow'

# Represents an function with a name alias.
# It is used in menu as an item.
class MenuItem
  attr_reader :function, :name

  def initialize(function, name = nil)
    @function = function

    # Set name as a function.to_s if no name is provided
    @name = name || function.to_s
  end
end

# Menu storage with properties
class MenuMenu
  attr_accessor :name, :is_submenu
  attr_reader :storage

  def initialize(name = "Menu")
    @name = name
    @storage = []
    @is_submenu = false
  end

  # Add to the end of the @storage
  def add(function, name = nil)
    @storage << MenuItem.new(function, name)
  end

  # Add at index
  def add_at(index, function, name = nil)
    if index < 0
      index = 0
    end

    if index > @storage.length - 1
      index = @storage.length
    end

    @storage.insert(index, MenuItem.new(function, name))
  end

  def add_submenu(menu)
    @storage << menu
  end

  def remove_at(index)
    item = @storage[index]

    return false unless item

    if item.is_a? MenuItem
      @storage.delete_at index
      return true
    end

    if item.is_a? MenuMenu
      # Do additional ask if it is okay to remove non-empty submenu
      if item.storage.length > 0
        puts "There are items in submenu. Do you want to proceed? (y/n)"

        if gets.strip != "y"
          return true
        end

        puts "Abort"
      end

      @storage.delete_at index
      true
    end
  end

  def remove_by(name)
    item_index = get_item_index_by_name(name)

    if item_index == nil
      return false
    end

    remove_at(item_index)
  end

  def get_item_index_by_name(name)
    @storage.each_with_index do |item, index|
      if item.name == name
        return index
      end
    end

    nil
  end

  def invoke(index)
    item = @storage[index]

    return false unless item

    if item.is_a?(MenuItem)
      send(item.function)
      return true
    end

    if item.is_a?(MenuMenu)
      MenuRunner.new(item).run
      return true
    end

    false
  end

  def print
    @storage.each_with_index do |item, index|
      puts "  #{index + 1} - #{item.name}"
    end
  end
end

class MenuRunner
  def initialize(menu)
    @menu = menu
    @is_remove_mode = false
    @is_remove_by_index = false
  end

  # Runners runs some CLI with custom business logic
  def run
    system "clear"

    loop do
      print_all

      printf "> "
      user_choice = gets.strip

      is_to_enable_remove_mode = user_choice.downcase == 'x' ||
        user_choice.downcase == 'y' && !@is_remove_mode

      if is_to_enable_remove_mode
        @is_remove_mode = true

        if user_choice.downcase == 'x'
          @is_remove_by_index = true
        else
          @is_remove_by_index = false
        end

        next
      end

      item_shortcut = user_choice.to_i
      is_shortcut_correct = !item_shortcut.zero?

      unless @is_remove_mode
        unless is_shortcut_correct
          # Exit on 0 given (0 - Return)
          return
        end
      end

      # If remove mode in on with incorrect shortcut
      if @is_remove_mode && !is_shortcut_correct
        # And if choice to go back
        if @is_remove_by_index || user_choice == "0"
          @is_remove_mode = false

          system "clear" if @menu.is_submenu

          next
        end
      end

      # Do the required task
      if @is_remove_mode
        if @is_remove_by_index
          next if @menu.remove_at(item_shortcut - 1)
        end

        next if @menu.remove_by(user_choice)
      else
        next if @menu.invoke(item_shortcut - 1)
      end

      # Print an error if any
      puts "No item with the shortcut '#{user_choice}' has been found"
    end
  end

  # Below are located private utility methods help to print things

  private

  # Print menu in stylish mode
  def print_all
    puts Rainbow("#{@menu.name}:").cyan.bright

    mode = "Normal"

    if @is_remove_mode
      mode = "Remove By"
      mode += @is_remove_by_index ? " Shortcut" : " Name"
    end

    puts "Mode: #{mode}"
    @menu.print
    print_utils
  end

  # Print additional utility menu items to work with menu
  def print_utils
    if @is_remove_mode
      puts Rainbow("0 - Exit remove mode").magenta
      return
    end

    puts Rainbow("X - Remove by shortcut").green
    puts Rainbow("Y - Remove by name").green

    puts Rainbow(@menu.is_submenu ? "0 - Go back" : "0 - Exit").magenta
  end
end

# Builder to configure menu with a block
class MenuBuilder
  attr_accessor :menu

  def initialize(&init_block)
    @menu = MenuMenu.new
    instance_eval(&init_block) if block_given?
  end

  def modify(&block)
    instance_eval(&block) if block_given?
  end

  def add(function, name = nil)
    @menu.add(function, name)
  end

  def add_at(index, function, name = nil)
    @menu.add_at(index, function, name)
  end

  def add_submenu(name, &block)
    submenu = MenuBuilder.new(&block)
    storage = submenu.menu

    storage.name = name
    storage.is_submenu = true

    @menu.add_submenu(storage)
  end
end