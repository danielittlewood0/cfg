require 'misc.rb'
class PseudoString 
  attr_accessor :chars 

  def initialize(chars)
    @chars = chars
  end

  def to_s
    @chars.map{|c| c.char}.join('')
  end  

  def self.from_string_default(string)
    ContextFreeGrammar.default.string_to_pseudo(string)
  end

  def ==(other)
    (self.class == other.class) && (self.chars == other.chars)
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
    return self if i.nil?
    self[0...i] + rule.rs + self[i+1..-1]
  end

  def apply(rule)
    i = self.chars.index(rule.ls)
    apply_at(i,rule)
  end

  def unapply_at(i,rule)
    rs = rule.rs
    return nil if i.nil?
    proposed_rs = self[i...i + rs.length]
    if rs == proposed_rs
      after = i + rs.length
      return self[0...i] + rule.ls_as_pseudo_string + self[after..-1]
    else
      return nil
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
  end

  def leftmost_possible_undos(rules)
    rules.map{|rule| unapply(rule)}.compact
  end

  def possible_last_moves(rules)
    rules.map{|rule| scan(rule.rs).map{|i| move(rule,i)}}.flatten
  end

  def parse(start_sym,rules,derivation=[],seen_before=[])
    return nil if seen_before.include?(self)
    seen_before << self

    possible_undos = leftmost_possible_undos(rules)
    if self == ps([start_sym])
      return [ps([start_sym])] + derivation.reverse
    elsif possible_undos.empty?
      return nil
    else
      try = []
      possible_undos.select{|w| !seen_before.include?(w)}.each_with_index do |preword,i|
        try = preword.parse(start_sym,rules,derivation + [self],seen_before)
        return try unless try.nil?
      end
      return nil
    end
  end

end
