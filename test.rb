# require "./menu"
#
# # Example functions
# def first
#   puts "First function"
# end
#
# def second
#   puts "Second function"
# end
#
# def third
#   puts "Third function"
# end
#
# def fourth
#   puts "Fourth function"
# end
#
# builder = MenuBuilder.new do
#   add :first, "My First Function"
#   add :second, "A Second Function"
#
#   add_at 2, :third, "A Third Function"
#
#   add_submenu "Submenu 1" do
#     add :third, "A Third Function"
#     add :first, "My First Function"
#     add :fourth, "A Fourth Function"
#   end
#
#   add_submenu "Submenu 2" do
#     add :fourth, "A Fourth Function"
#     add :second, "A Second Function"
#   end
# end
#
# menu = builder.menu
#
# runner = MenuRunner.new(menu)
#
# runner.run
#
# puts "Exit from menu"

puts 2.class
puts false.class