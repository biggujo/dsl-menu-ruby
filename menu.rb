class MenuStorage
  def initialize
    @storage = []
  end

  def add(function_to_invoke)
    @storage << method(function_to_invoke)
  end

  def invoke(index)
    begin
      @storage[index].call

      true
    rescue NoMethodError
      false
    end
  end

  def print
    @storage.each_with_index do |value, index|
      puts "#{index + 1} - #{value.original_name}"
    end
  end
end

class MenuBuilder
  attr_reader :storage

  def initialize(&init_block)
    @storage = MenuStorage.new

    instance_eval(&init_block) if block_given?
  end

  # Is intended to be used in a block
  def add(function_to_invoke)
    @storage.add function_to_invoke
  end
end

class MenuRunner
  def initialize(storage)
    @storage = storage
  end

  # Run the menu usage in an infinite loop
  def run
    loop do
      printf "> "

      item_by_shortcut = gets.to_i

      # Exit if 0
      return if item_by_shortcut == 0

      # Print error if invoke returned false
      unless @storage.invoke item_by_shortcut - 1
        puts "No function with the shortcut '#{item_by_shortcut}' has been found"
      end
    end
  end
end