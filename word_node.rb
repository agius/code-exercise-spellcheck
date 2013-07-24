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
  
  def check(word)
    $stderr.puts @@depth + @letter + " + #{word}" if $debug
    return @letter if (word.nil? || word == '') && @end_word
    vowels = ['a', 'e', 'i', 'o', 'u', 'y']
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
    if next_letter == self.letter
      letterz = letters.dup
      nextl = next_letter.dup

      begin
        nextl = letterz.shift
      end while letterz.count > 0 && nextl == @letter

      return @letter if letterz.count <= 0 && (nextl == @letter || nextl == '' || nextl.nil?) && @end_word

      if @children[nextl]
        @@depth << " "
        result = @children[nextl].check(letterz.join(''))
        @@depth.chop!
        return @letter + result if result.is_a?(String)
      end
      
      # since the next letter might be a vowel, we may have to try substitution on that
      if vowels.include?(nextl)
        vowels -= [nextl]
        vowels.each do |v|
          next unless @children[v]
          @@depth << " Z"
          result = @children[v].check(letterz.join(''))
          @@depth.chop!
          return @letter + result if result.is_a?(String)
        end
      end
    end
    
    # else try vowel substitution
    if vowels.include?(next_letter)
      vowels -= [next_letter]
      vowels.each do |v|
        next unless @children[v]
        @@depth << " "
        result = @children[v].check(letters.join(''))
        @@depth.chop!
        return @letter + result if result.is_a?(String)
      end
    end
    
    return false
  end
  
  def inspect
    "#<WordNode: #{self.letter} end?#{self.end_word.inspect}>"
  end
  
end