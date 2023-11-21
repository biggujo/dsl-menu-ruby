require "./menu"

# Example function to run
def first
  puts "First function"
end

def second
  puts "Second function"
end

builder = MenuBuilder.new do
  add :first
  add :second
end

storage = builder.storage
runner = MenuRunner.new storage

puts "Menu:"
storage.print
runner.run

puts "Exit from menu"