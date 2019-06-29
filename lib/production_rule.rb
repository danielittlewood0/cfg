require_relative 'terminal'
require_relative 'non_terminal'
require_relative 'pseudo_string'
class ProductionRule 
  attr_accessor :ls,:rs 

  def initialize(ls:, rs:)
    @ls = ls
    @rs = rs 
  end

  def to_s
    ls.to_s + " -> " + rs.to_s
  end

  def ls_as_pseudo_string
    raise "LHS should be a NonTerminal!" unless ls.is_a?(NonTerminal)
    return PseudoString.new([ls])
  end
end

