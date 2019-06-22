require 'non_terminal.rb'
require 'terminal.rb'
require 'misc.rb'
class ContextFreeGrammar
  attr_accessor :non_terminals, :terminals, :start_symbol, :rules

  def initialize(non_terminals:[], terminals:[], rules:[], start_symbol: nil)
    @non_terminals = non_terminals
    @terminals = terminals
    @rules = rules
    @start_symbol = start_symbol
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
      self.start_symbol = NonTerminal.new(args)
    when "RULE" 
      self.rules << parse_rule(args)
    end
  end

  def start_word
    ps([start_symbol])
  end

  def string_to_pseudo(str)
    parsed_chars = str.scan(alphabet_regex).map{|x| lookup_letter[x]}
    PseudoString.new(parsed_chars)
  end

  def parse_rule(args)
    ls,rs = args.split(/\s*->\s*/)
    rule(PseudoString.from_string_default(ls),PseudoString.from_string_default(rs))
  end

  def parse(string_to_parse, derivation=[], seen_before=[])
    return nil if seen_before.include?(string_to_parse)
    seen_before << string_to_parse

    possible_undos = string_to_parse.leftmost_possible_undos(rules)
    if string_to_parse == start_word
      return [start_word] + derivation.reverse
    elsif possible_undos.empty?
      return nil
    else
      try = []
      possible_undos.select{|w| !seen_before.include?(w)}.each_with_index do |preword,i|
        try = preword.parse(derivation + [string_to_parse],seen_before)
        return try unless try.nil?
      end
      return nil
    end
  end

  def parse(string_to_parse)
    string_to_pseudo(string_to_parse).parse(start_symbol,rules)
  end

  def self.default
    cfg = ContextFreeGrammar.new
    cfg.non_terminals = ('A'..'Z').to_a.map{|x| NonTerminal.new(x)}
    cfg.terminals = (('a'..'z').to_a + ['(',')','[',']','{','}',']']).map{|x| Terminal.new(x)}
    cfg.rules = []
    return cfg
  end
end
