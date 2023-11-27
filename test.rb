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
  add :first, "First function"
  add :second, "Second function"

  add_submenu "Submenu 1" do
    add :third
  end

  add_submenu "Submenu 2" do
    add :fourth
  end
end

storage = builder.storage

storage.execute

puts "Exit from menu"
