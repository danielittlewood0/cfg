class Terminal 
  attr_accessor :char

  def initialize(char)
    @char = char
  end

  def ==(other)
    self.class == other.class &&
    self.char == other.char
  end

end

class NonTerminal 
  attr_accessor :char

  def initialize(char)
    @char = char
  end

  def ==(other)
    self.class == other.class &&
    self.char == other.char
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

  def apply(rule)
    i = self.chars.index(rule.ls.chars.first)
    if i.nil?
      return self
    else
      return self[0...i] + rule.rs + self[i+1..-1]
    end
  end
  
  def apply_at(i,rule)
    return self[0...i] + rule.rs + self[i+1..-1]
  end

  def unapply_at(index,rule)
    rs = rule.rs
    proposed_rs = self[index...index + rs.length]
    if rs == proposed_rs
      after = index + rs.length
      return self[0...index] + rule.ls + self[after..-1]
    else
      raise "#{rs.write} is different from #{proposed_rs.write}"
      return nil
    end
  end

  def index(word)
    for i in 0...self.length 
      if self[i...i+word.chars.length] == word
        return i
      end
    end
    return nil 
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
    rules.map{|rule| scan(rule.rs).map{|i| unapply_at(i,rule)}}.flatten
  end

  def possible_last_moves(rules)
    rules.map{|rule| scan(rule.rs).map{|i| move(rule,i)}}.flatten
  end

# def try_unapply(rules,start,past_moves,moves_to_try)
#   move_to_
#   past_moves << 
#   add_moves_to_try_to_remaining_move_stack
#   parse(rules,start,past_moves,moves_to_try)
# end

# def unapply_failed(rules,start,past_moves,moves_to_try)
#   past_moves.pop
#   
#   if not_empty
#     add_head_to_move_stack
#     put_rest_back
#   else
#     backtrack
#   end

# end

  def pop_move_off_stack(rules,start,past_moves,moves_to_try)
    move_to_try = moves_to_try.last.pop
    past_moves << move_to_try
    string = unapply_at(move_to_try.index,move_to_try.rule)
    moves_to_try << string.possible_last_moves(rules)
    return string
  end

  def undo_most_recent_move(rules,start,past_moves,moves_to_try)
    move_to_undo = past_moves.pop
    m = move_to_undo
    puts "Applying rule #{m.rule.ls.write} => #{m.rule.rs.write} at index #{m.index} to string #{write}"
    raise 'last moves_to_try should be empty' unless moves_to_try.last.empty?
    moves_to_try.pop
    res = apply_at(move_to_undo.index,move_to_undo.rule)
    puts res.write
    return res
  end

  def initial_setup(rules,start,past_moves,moves_to_try)
    moves_to_try << possible_last_moves(rules)
  end

  def parse(rules,start,past_moves=[],moves_to_try=[])
    $LOOPER += 1
#   raise "too much looping!" if $LOOPER > 1000
#   puts "hello"
    puts write
#   puts past_moves.length
#   puts moves_to_try.last.length unless moves_to_try.empty?
#    descend parse tree = apply rule 
#    so to ascend parse tree we must know all rules we could have applied
#    for each rule, check whether it could have been applied possible_rhs = rules.map{|r| r.rhs}
    if moves_to_try.empty?
      initial_setup(rules,start,past_moves,moves_to_try)
    end
    if self == start
      past_moves = past_moves.reverse
        res = start 
      for i in 0...past_moves.length 
        move = past_moves[i]
        p past_moves[i].rule.ls.write
        line =  "Apply #{move.rule.ls.write} => #{move.rule.rs.write} at #{move.index} to #{res.write}"
        res = res.apply_at(move.index,move.rule)
        line += " to get #{res.write}..."
        puts line
      end
      raise 'You win!'
    end
    #check for failures
    if past_moves.empty? && moves_to_try.last.empty?
      raise 'Ungrammatical word!'
    end
    if moves_to_try.last.empty?
      puts "going up"
      string = undo_most_recent_move(rules,start,past_moves,moves_to_try)
      puts string.write
#     raise "please stop here sir"
      return string.parse(rules,start,past_moves,moves_to_try)
    end
    puts "going down"
    #given no failures, apply a move
    string = pop_move_off_stack(rules,start,past_moves,moves_to_try)
   #return string
    return string.parse(rules,start,past_moves,moves_to_try)
#   to_try_from_here = possible_last_moves(rules)
#   if to_try_from_here.empty? 
#     return unapply_failed
#   else
#     result = 
#     return 
#   end


  end
end

class ProductionRule 
  attr_accessor :ls,:rs 

  def initialize(ls,rs)
    @ls = ls
    @rs = rs 
  end
end

class Move
  attr_accessor :rule, :index

  def initialize(rule,index)
    @rule = rule
    @index = index
  end
end

def rule(ls,rs) 
  ProductionRule.new(ls,rs) 
end


def ps(chars)
  PseudoString.new(chars) 
end

def move(rule,index)
  Move.new(rule,index)
end
