class PseudoChar
  attr_accessor :char

  def initialize(char)
    @char = char
  end

  def ==(other)
    (other.class == self.class) && (self.char == other.char)
  end

  def to_s
    char
  end

end
