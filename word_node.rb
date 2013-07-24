class WordNode
  
  @@depth = ""
  
  attr_accessor :letter
  attr_accessor :end_word
  attr_accessor :children
  
  def initialize(new_letter)
    self.letter = new_letter
    self.children = {}
    self.end_word = false
  end
  
  def self.vowels
    ['a', 'e', 'i', 'o', 'u', 'y']
  end
  
  def vowels
    self.class.vowels
  end
  
  def self.vowel_permutes(length)
    length = 2 if length > 2 # catch most common cases
    permutes = []
    0.upto(length) do |n|
      vowels_multiples = [] 
      n.times { vowels_multiples += vowels.dup }
      permutes += vowels_multiples.permutation(n).to_a
    end
    permutes
  end
  
  def vowel_permutes(length)
    self.class.vowel_permutes(length)
  end
  
  def check(word)
    $stderr.puts @@depth + @letter + " + #{word}" if $debug
    return @letter if (word.nil? || word == '') && @end_word
    letters = word.downcase.to_a
    next_letter = letters.shift
    
    # if valid, return
    if @children[next_letter]
      @@depth << " "
      result = @children[next_letter].check(letters.join(''))
      @@depth.chop!
      return @letter + result if result.is_a?(String)
    end
    
    # else try removing dups from this set
    return check_dups(next_letter, letters.dup) if next_letter == self.letter
    
    # else try vowel substitution
    return check_vowels(next_letter, letters.dup) if vowels.include?(next_letter)
    
    return false
  end
  
  def check_vowels(next_letter, letters)
    vowels_instance = vowels - [next_letter]
    vowels_instance.each do |v|
      next unless @children[v]
      @@depth << " "
      result = @children[v].check(letters.join(''))
      @@depth.chop!
      return @letter + result if result.is_a?(String)
    end
    
    return false
  end
  
  def check_dups(next_letter, letters)
    orig = next_letter.dup
    region_length = 1
    begin
      next_letter = letters.shift
      region_length += 1
    end while letters.count > 0 && next_letter == @letter

    # if we reached the end of the word and it's a valid word, return
    return @letter if letters.count <= 0 && (next_letter == @letter || next_letter == '' || next_letter.nil?) && @end_word
    
    # if this was a duplicated vowel, we have to check permutations
    if vowels.include?(orig)
      permutes = vowel_permutes(region_length)
      permutes.each do |permute|
        letterz = permute + [next_letter] + letters
        ltr = letterz.shift
        next unless @children[ltr]
        @@depth << " "
        result = @children[ltr].check(letterz.join(''))
        @@depth.chop!
        return @letter + result if result.is_a?(String)
      end
    end
    
    # this kills performance - let's just catch the most likely case
    # if orig == 'o' && @children['u']
    #   @@depth << " "
    #   letters.unshift(next_letter)
    #   result = @children['u'].check(letters.join(''))
    #   @@depth.chop!
    #   return @letter + result if result.is_a?(String)
    # end

    if @children[next_letter]
      @@depth << " "
      result = @children[next_letter].check(letters.join(''))
      @@depth.chop!
      return @letter + result if result.is_a?(String)
    end
    
    # since the next letter might be a vowel, we may have to try substitution on that
    if vowels.include?(next_letter)
      return check_vowels(next_letter, letters.dup)
    end
    
    return false
  end
  
  def inspect
    "#<WordNode: #{self.letter} end?#{self.end_word.inspect}>"
  end
  
end