require_relative 'non_terminal.rb'
require_relative 'terminal.rb'
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
    start_symbol.as_pseudo_string
  end

  def string_to_pseudo(str)
    parsed_chars = str.scan(alphabet_regex).map{|x| lookup_letter[x]}
    PseudoString.new(parsed_chars)
  end

  def parse_rule(string_rule)
    ls,rs = string_rule.split(/\s*->\s*/)
    ProductionRule.new(ls: NonTerminal.with_char(ls), rs: string_to_pseudo(rs))
  end

  def add_string_rule!(string_rule)
    self.rules << parse_rule(string_rule)
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
        try = parse(preword, derivation + [string_to_parse], seen_before)
        return try unless try.nil?
      end
      return nil
    end
  end

  def self.default
    cfg = ContextFreeGrammar.new
    cfg.non_terminals = ('A'..'Z').to_a.map{|x| NonTerminal.new(x)}
    cfg.terminals = (('a'..'z').to_a + ['(',')','[',']','{','}',']']).map{|x| Terminal.new(x)}
    cfg.rules = []
    return cfg
  end
end
