require './string'
require 'open3'
require 'progressbar'

total_runs = ENV['RUNS'] || 100
use_stdin = ENV['STDIN']

# ['sheeeeep', 'peepple', 'sheeple', 'inSIDE', 'jjoobbb', 'weke', 'CUNsperrICY', 'uuuuunChiValRooooSli'].each do |ex|
#   puts "#{ex} #{big_list.check(ex)}"
# end

unless use_stdin
  require './string'
  require './word_node'
  require './word_list'
  
  word_list = WordList.new
end

puts "Reading word list..."
words = []
File.readlines('/usr/share/dict/words').each do |word|
  word.gsub!(/\s/, '')
  words << word
  word_list << word.gsub(/\s/, '') unless use_stdin
end

vowels = ['a', 'e', 'i', 'o', 'u', 'y']
errors = {}
pbar = ProgressBar.new("Spell errors", total_runs)
total_runs.times do
  word = words.sample.to_a
  mistake = []
  word.each do |char|
    len = mistake.count
    if vowels.include?(char) && rand(10) < 3
      mistake << (vowels - [char]).sample
      next
    end
    
    case rand(100)
    when 0..10
      (rand(10) + 1).times { mistake << char }
    when 11..43
      mistake << char.upcase
    else
      mistake << char
    end
  end
  
  mistake = mistake.join('')
  if use_stdin
    stdout, status = Open3.capture2("ruby spellcheck.rb", :stdin_data => mistake)
    errors[word.join('')] = mistake if stdout =~ /NO SUGGESTION/
  else
    errors[word.join('')] = mistake if word_list.check(mistake) == "NO SUGGESTION"
  end
  pbar.inc
end
pbar.finish

if errors.count > 0
  puts "Failed on:"
  errors.each {|word, mistake| puts "#{word}: #{mistake}" }
else
  puts "Run successful"
end
