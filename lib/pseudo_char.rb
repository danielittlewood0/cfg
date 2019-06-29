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

  def self.with_char(char)
    self.new(char)
  end

  def as_pseudo_string
    PseudoString.new([self])
  end
end
