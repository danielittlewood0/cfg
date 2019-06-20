require 'terminal'
require 'non_terminal'
require 'pseudo_string'
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

