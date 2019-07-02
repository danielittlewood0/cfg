require 'non_terminal.rb'
require 'terminal.rb'
require 'misc.rb'
class ContextFreeGrammar
  attr_accessor :non_terminals, :terminals, :start_sym, :rules

  def initialize
    @non_terminals = []
    @terminals = []
    @rules = []
  end

  def alphabet
    non_terminals + terminals
  end

  def alphabet_regex
    Regexp.union(*
      self.alphabet.map do |letter|
        /#{Regexp.quote(letter.char)}/
      end
    )
  end

  def lookup_letter
    alphabet.map{|x| [x.char,x]}.to_h
  end

  def execute!(cmd,args)
    non_terminals = []
    terminals = []
    start = ""
    rules = []
    case cmd
    when "NON TERMINALS" 
      split_args = args.match(/\A\[(.*)\]\Z/)[1].split(',')
      self.non_terminals += split_args.map{|x| NonTerminal.new(x)}
    when "TERMINALS"
      split_args = args.match(/\A\[(.*)\]\Z/)[1].split(',')
      self.terminals += split_args.map{|x| Terminal.new(x)}
    when "START"
      self.start_sym = NonTerminal.new(args)
    when "RULE" 
      self.rules << parse_rule(args)
    end
  end

  def string_to_pseudo(str)
    parsed_chars = str.scan(alphabet_regex).map{|x| lookup_letter[x]}
    PseudoString.new(parsed_chars)
  end

  def parse_rule(args)
    ls,rs = args.split(/\s*->\s*/)
    rule(PseudoString.from_string_default(ls),PseudoString.from_string_default(rs))
  end

  def parse(str)
    string_to_pseudo(str).parse(start_sym,rules)
  end

  def self.default
    cfg = ContextFreeGrammar.new
    cfg.non_terminals = ('A'..'Z').to_a.map{|x| NonTerminal.new(x)}
    cfg.terminals = (('a'..'z').to_a + ['(',')','[',']','{','}',']']).map{|x| Terminal.new(x)}
    cfg.rules = []
    return cfg
  end
end
