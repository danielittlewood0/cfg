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
end

