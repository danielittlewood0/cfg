require 'production_rule.rb'
require 'terminal.rb'
require 'non_terminal.rb'
require 'move.rb'
require 'pseudo_string.rb'
require 'context_free_grammar.rb'

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
