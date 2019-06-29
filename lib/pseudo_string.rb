require_relative 'misc.rb'
class PseudoString 
  include Enumerable
  attr_accessor :chars 

  def initialize(chars)
    @chars = chars
  end

  def each
    return to_enum(:each) unless block_given?
    chars.each{|char| yield char}
  end

  def to_s
    reduce(""){|acc,pseudo_char| acc + pseudo_char.char}
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

  def subwords_of_length(n)
    enum_for(:subwords_of_length,n)
    Enumerator.new do |yielder|
      self.each_cons(n).each{|sub_chars| yielder << ps(sub_chars)}
    end
  end
    
  def index(word)
    self.each_cons(word.length).each_with_index do |sub_chars,i|
      return i if ps(sub_chars) == word
    end
    return nil 
  end
  
  def apply_at(i,rule)
    return self if i.nil?
    return self if self.chars[i] != rule.ls
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
    (0...self.length).select{|i| self[i...i+word.length] == word}
  end

  def possible_undos(rules)
    rules.map{|rule| scan(rule.rs).map{|i| unapply_at(i,rule)}}.flatten
  end

  def leftmost_possible_undos(rules)
    rules.map{|rule| unapply(rule)}.compact
  end
end
