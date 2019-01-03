class Terminal 
  attr_accessor :char

  def initialize(char)
    @char = char
  end

  def ==(other)
    other.is_a?(Terminal) && self.char == other.char
  end

  def to_abstract
    AbstractChar.new(self)
  end
end

class NonTerminal 
  attr_accessor :char

  def initialize(char)
    @char = char
  end

  def ==(other)
    other.is_a?(NonTerminal) && self.char == other.char
  end

  def to_abstract
    AbstractChar.new(self)
  end
end

class String
  def to_pseudo(non_terms=('A'..'Z').to_a,terms=('a'..'z').to_a) 
    chars = self.split('')
    new_chars = []
    chars.each do |c| 
      if non_terms.include?(c)
        new_chars << NonTerminal.new(c)
      elsif terms.include?(c)
        new_chars << Terminal.new(c)
      else 
        new_chars << Terminal.new(c)
#       raise "No known character: |#{c}|"
      end
    end
    return ps(new_chars)
  end

  def nt
    NonTerminal.new(self)
  end

  def t
    Terminal.new(self)
  end

end

class PseudoString 
  attr_accessor :chars 

  def initialize(chars)
    @chars = chars
  end

  def write
    @chars.map{|c| c.char}.join('')
  end  

  def ==(other)
    self.chars == other.chars
  end

  def +(other)
    new_chars = self.chars + other.chars
    ps(new_chars)
  end

  def [](range)
    ps(chars[range])
  end

  def length
    chars.length
  end

  def index(word)
    for i in 0...self.length 
      if self[i...i+word.chars.length] == word
        return i
      end
    end
    return nil 
  end
  
  def apply_at(i,rule)
    raise "nil index" if i.nil?
    self[0...i] + rule.rs + self[i+1..-1]
  end

  def apply(rule)
    i = self.chars.index(rule.ls.chars.first)
    apply_at(i,rule)
  end

  def unapply_at(i,rule)
    rs = rule.rs
    proposed_rs = self[i...i + rs.length]
    if rs == proposed_rs
      after = i + rs.length
      return self[0...i] + rule.ls + self[after..-1]
    else
      raise "#{rs.write} is different from #{proposed_rs.write}"
    end
  end

  def unapply(rule)
    unapply_at(index(rule.rs),rule)
  end

  def scan(word)
    indices = []
    for i in 0...self.chars.length 
      if chars[i...i+word.chars.length] == word.chars
        indices << i
      end
    end
    return indices 
  end

  def possible_undos(rules)
    rules.map{|rule| scan(rule.rs).
              map{|i| unapply_at(i,rule)}}.flatten
    rules.map{|rule| scan(rule.rs).
              map{|i| [unapply_at(i,rule),i]}}.flatten(1).
              sort_by{|arr| arr[-1]}.map(&:first)
  end

  def possible_last_moves(rules)
    rules.map{|rule| scan(rule.rs).map{|i| move(rule,i)}}.flatten
  end

  def parse(rules,derivation=[self],moves=[])
    moves << possible_undos(rules)
    if moves[-1].empty?
      moves.pop
      derivation.pop
    else
      try = moves[-1].pop
      try.parse(rules,derivation,moves)
      derivation << try
    end
    derivation
  end

  def to_abstract
    abstract_chars = self.chars.map(&:to_abstract)
    AbstractWord.new(abstract_chars)
  end
end

class ProductionRule 
  attr_accessor :ls,:rs 

  def initialize(ls,rs)
    @ls = ls
    @rs = rs 
  end

  def write
    ls.write + " --> " + rs.write
  end
end

class Move # subclass of ProductionRule?
  attr_accessor :rule, :index

  def initialize(rule,index)
    @rule = rule
    @index = index
  end
end

class AbstractChar
  attr_accessor :char, :move, :child_nodes, :parent

  def initialize(char)
    @char = char
  end

  def ==(other_char)
    self.char == other_char.char
  end

  def init_from_move(move)
    @move = move
    @char = move.ls
    @children = moves.rs.chars
    @children.each{|child| child.parent = self}
  end
end

class AbstractWord
  attr_accessor :abstract_chars 

  def initialize(chars)
    @abstract_chars = chars
  end

  def to_pseudo
    ps(@abstract_chars.map{|c| c.char})
  end

  def write
    to_pseudo.write
  end  

  def ==(other)
    self.abstract_chars == other.abstract_chars
  end

  def +(other)
    new_abstract_chars = self.abstract_chars + other.abstract_chars
    AbstractWord.new(new_abstract_chars)
  end

  def [](range)
    aw(abstract_chars[range])
  end

  def length
    abstract_chars.length
  end

  def index(pseudo)
    for i in 0...self.length 
      if self[i...i+pseudo.chars.length].to_pseudo == pseudo
        return i
      end
    end
    return nil 
  end
  
#  def apply_at(i,rule)
#    raise "nil index" if i.nil?
#    self[0...i] + rule.rs + self[i+1..-1]
#  end
#
#  def apply(rule)
#    i = self.chars.index(rule.ls.chars.first)
#    apply_at(i,rule)
#  end
#
#  def unapply_at(i,rule)
#    rs = rule.rs
#    proposed_rs = self[i...i + rs.length]
#    if rs == proposed_rs
#      after = i + rs.length
#      return self[0...i] + rule.ls + self[after..-1]
#    else
#      raise "#{rs.write} is different from #{proposed_rs.write}"
#    end
#  end
#
#  def unapply(rule)
#    unapply_at(index(rule.rs),rule)
#  end
#
#  def scan(word)
#    indices = []
#    for i in 0...self.chars.length 
#      if chars[i...i+word.chars.length] == word.chars
#        indices << i
#      end
#    end
#    return indices 
#  end
#
#  def possible_undos(rules)
#    rules.map{|rule| scan(rule.rs).
#              map{|i| unapply_at(i,rule)}}.flatten
#    rules.map{|rule| scan(rule.rs).
#              map{|i| [unapply_at(i,rule),i]}}.flatten(1).
#              sort_by{|arr| arr[-1]}.map(&:first)
#  end
#
#  def possible_last_moves(rules)
#    rules.map{|rule| scan(rule.rs).map{|i| move(rule,i)}}.flatten
#  end
#
#  def parse(rules,derivation=[self],moves=[])
#    moves << possible_undos(rules)
#    if moves[-1].empty?
#      moves.pop
#      derivation.pop
#    else
#      try = moves[-1].pop
#      try.parse(rules,derivation,moves)
#      derivation << try
#    end
#    derivation
#  end
#  def construct_tree
#
#  end
end

class PseudoString 
  def abstract_syntax_tree
    @chars
  end
end

# factories

def rule(ls,rs) 
  ProductionRule.new(ls,rs) 
end

def ps(chars)
  raise "chars should be array!" if !chars.is_a?(Array)
  PseudoString.new(chars) 
end

def move(rule,index)
  Move.new(rule,index)
end

def aw(abstract_chars)
  AbstractWord.new(abstract_chars)
end
