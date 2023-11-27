require "./menu"

# Example functions
def first
  puts "First function"
end

def second
  puts "Second function"
end

def third
  puts "Third function"
end

def fourth
  puts "Fourth function"
end

builder = MenuBuilder.new do
  add :first
  add :second, "Second function"

  add_at 2, :third, "Third function"

  add_submenu "Submenu 1" do
    add :third
  end

  add_submenu "Submenu 2" do
    add :fourth
  end
end

menu = builder.menu

runner = MenuRunner.new(menu)

runner.run

puts "Exit from menu"
