require 'production_rule.rb'
require 'terminal.rb'
require 'non_terminal.rb'
require 'move.rb'
require 'pseudo_string.rb'
require 'context_free_grammar.rb'

class String
# def to_pseudo(non_terms=('A'..'Z').to_a,terms=('a'..'z').to_a + 
#               ['(',')','[',']','{','}',']'])
#   chars = self.split('')
#   new_chars = []
#   chars.each do |c| 
#     if non_terms.include?(c)
#       new_chars << NonTerminal.new(c)
#     elsif terms.include?(c)
#       new_chars << Terminal.new(c)
#     end
#   end
#   return ps(new_chars)
# end

  def to_pseudo
    ContextFreeGrammar.default.string_to_pseudo(self)
  end

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
