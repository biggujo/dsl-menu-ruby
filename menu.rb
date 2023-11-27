class MenuStorage
  attr_accessor :is_submenu
  attr_reader :storage

  def initialize
    @storage = []
    @is_submenu = false
    @is_remove_mode = false
    @is_remove_by_index = false
  end

  def add(function_to_invoke)
    @storage << function_to_invoke
  end

  def add_submenu(name, submenu_storage)
    @storage << { name: name, storage: submenu_storage }
  end

  def remove_at(index)
    item = @storage[index]

    return false unless item

    if item.is_a? Symbol
      @storage.delete_at index
      return true
    end

    if item.is_a? Hash
      if item[:storage].storage.length > 0
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
      if item.is_a? Symbol
        if item.id2name == name
          return index
        end
      end

      if item.is_a Hash
        if item[:name] == name
          return index
        end
      end
    end

    nil
  end

  def invoke(index)
    item = @storage[index]

    return false unless item

    if item.is_a?(Symbol)
      send(item)
      return true
    end

    if item.is_a?(Hash)
      item[:storage].execute
      return true
    end

    false
  end

  def execute
    loop do
      puts @is_submenu ? "Submenu:" : "Menu"
      print

      printf "> "
      user_choice = gets.strip

      is_to_enable_remove_mode = user_choice.downcase == 'x' ||
        user_choice.downcase == 'y' if !@is_remove_mode

      if is_to_enable_remove_mode
        puts "Enter remove mode"
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

      unless is_shortcut_correct
        # TODO: Add proper logic for removing (@biggujo)
        # is_in_remove_by_index = @is_remove_mode && @is_remove_by_index
        # is_in_remove_by_position = @is_remove_mode && !@is_remove_by_index
        # choice_is_zero = user_choice == "0"
        #
        # if @is_remove_mode || (is_in_remove_by_position && choice_is_zero)
        #   puts "Leave remove mode"
        #   @is_remove_mode = false
        #   next
        # end

        # Exit on 0 given (0 - Return)
        return
      end

      if @is_remove_mode
        if @is_remove_by_index
          next if remove_at(item_shortcut - 1)
        end

        next if remove_by(user_choice)
      else
        next if invoke(item_shortcut - 1)
      end

      puts "No item with the shortcut '#{item_shortcut}' has been found"
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

    puts "X - Remove by shortcut" unless @is_remove_mode
    puts "Y - Remove by name" unless @is_remove_mode

    if @is_remove_mode
      puts "0 - Exit remove mode"
      return
    end

    puts @is_submenu ? "0 - Go back" : "0 - Exit"
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