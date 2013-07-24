class String
  def to_a
    arr = []
    self.each_char {|char| arr << char }
    return arr
  end
end