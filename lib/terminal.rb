class Terminal 
  attr_accessor :char

  def initialize(char)
    @char = char
  end

  def ==(other)
    other.is_a?(Terminal) && self.char == other.char
  end

  def to_s
    char
  end
end

