class WordList
  
  attr_accessor :root_nodes
  
  def initialize
    @root_nodes = {}
    ('a'..'z').each do |letter|
      @root_nodes[letter] = WordNode.new(letter)
    end
  end
  
  def <<(word)
    return if word.nil? || word == ''
    word = word.gsub(/\s/, '').downcase.to_a
    root_letter = word.shift
    last_node = @root_nodes[root_letter]
    word.inject(last_node) do |node, letter|
      node.children[letter] ||= WordNode.new(letter)
      node = node.children[letter]
      last_node = node
    end
    last_node.end_word = true
  end
  
  def check(word)
    letters = word.downcase.to_a
    root_letter = letters.shift
    result = @root_nodes[root_letter].check(letters.join(''))
    vowels = ['a', 'e', 'i', 'o', 'u', 'y']
    if !result && vowels.include?(root_letter)
      vowels -= [root_letter]
      vowels.each {|v| next if result; result = @root_nodes[v].check(letters.join('')) }
    end
    return result ? result : "NO SUGGESTION"
  end
  
end