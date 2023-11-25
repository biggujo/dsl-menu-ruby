require "./menu"

# Example functions
def first
  puts "First function"
end

def second
  puts "Second function"
end

def a_func
  puts "A function"
end

def b_func
  puts "B function"
end

builder = MenuBuilder.new do
  add :first
  add :second
  submenu "Submenu 1" do
    submenu "Submenu 11" do
      add :a_func
    end
  end
  submenu "Submenu 2" do
    add :b_func
  end
end

storage = builder.storage
runner = MenuRunner.new(storage)

puts "Menu:"
storage.print
runner.run

puts "Exit from menu"
