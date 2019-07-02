require 'production_rule.rb'
require 'terminal.rb'
require 'non_terminal.rb'
require 'move.rb'
require 'pseudo_string.rb'
require 'context_free_grammar.rb'

class String
  def nt
    NonTerminal.new(self)
  end

  def t
    Terminal.new(self)
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
