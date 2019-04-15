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
    # does not work for multi-char symbols!
    str.to_pseudo
  end

  def parse_rule(args)
    ls,rs = args.split(/\s*->\s*/)
    rule(ls.to_pseudo,rs.to_pseudo)
  end

  def parse(str)
    string_to_pseudo(str).parse(rules)
  end
end
