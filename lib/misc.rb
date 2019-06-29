require_relative 'production_rule.rb'
require_relative 'terminal.rb'
require_relative 'non_terminal.rb'
require_relative 'move.rb'
require_relative 'pseudo_string.rb'
require_relative 'context_free_grammar.rb'

class String
end

def rule(ls,rs) 
  raise "LHS should be a NonTerminal!" if !ls.is_a?(NonTerminal)
  ProductionRule.new(ls: ls,rs: rs) 
end

def ps(chars)
  PseudoString.new(chars) 
end

def move(rule,index)
  Move.new(rule: rule,index: index)
end
