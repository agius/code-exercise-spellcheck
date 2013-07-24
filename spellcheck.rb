require './string'
require './word_node'
require './word_list'

puts "Reading in dictionary..."
big_list = WordList.new
File.readlines('/usr/share/dict/words').each do |word|
  big_list << word
end

$debug = !ENV['DEBUG'].nil?

$stdout.write ">"
while input = gets
  puts big_list.check(input.gsub(/\s/, '')) || "NO SUGGESTION"
  $stdout.write ">"
end