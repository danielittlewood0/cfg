class Terminal 
  attr_accessor :char

  def initialize(char)
    @char = char
  end

  def ==(other)
    self.char == other.char
  end

end

class NonTerminal 
  attr_accessor :char

  def initialize(char)
    @char = char
  end

  def ==(other)
    self.char == other.char
  end

end

class String 
  def to_pseudo(non_terms,terms) 
    chars = self.split('')
    new_chars = []
    chars.each do |c| 
      if non_terms.include?(c)
        new_chars << NonTerminal.new(c)
      elsif terms.include?(c)
        new_chars << Terminal.new(c)
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
    self.write == other.write
  end

 # def ++(other)
 #   new_chars = self.chars + other.chars
 #   ps(new_chars)
 # end

  def apply(rule)
    i = self.chars.index(rule.ls.chars.first)
    if i.nil?
      return self
    else
      new_chars = chars[0...i] + rule.rs.chars + chars[i+1..-1]
      return ps(new_chars)    
    end
  end
  
  def unapply(rule,index)
    rs = rule.rs
    new_chars = chars[0...index]
    if rs == ps(chars[index...rs.chars.length])
      tail = chars[index+rs.chars.length..-1]
      p tail
      new_chars += rule.ls.chars + tail
      return ps(new_chars)
    else
      return nil
    end
  end

  def index(word)
    for i in 0...self.chars.length 
      p i
      p ps(chars[i...i+word.chars.length])
      if chars[i...i+word.chars.length] == word.chars
        return i
      end
    end
    return nil 
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
    words = rules.map{|rule| rule.rs}
    words.map{|word| [scan(word),rule]}
  end

  def go_ahead
    add_move_to_move_stack
    add_remaining_moves_to_remaining_move_stack
    parse(rules,start,past_moves,remaining_moves
  end

  def backtrack
    remove_move_from_stack
    remove_remaining_moves_from_remaining_moves_stack
    if not_empty
      add_head_to_move_stack
      put_rest_back
    else
      backtrack
    end

  end

  def parse(rules,start,past_moves,remaining_moves)
#    descend parse tree = apply rule 
#    so to ascend parse tree we must know all rules we could have applied
#    for each rule, check whether it could have been applied possible_rhs = rules.map{|r| r.rhs}
    if self == start
      return past_moves
    end
    compute_possible_undos 
    if empty 
      return backtrack
    else
      return go_ahead
    end


  end
end

class ProductionRule 
  attr_accessor :ls,:rs 

  def initialize(ls,rs)
    @ls = ls
    @rs = rs 
  end
end

def rule(ls,rs) 
  ProductionRule.new(ls,rs) 
end


def ps(chars)
  PseudoString.new(chars) 
end
