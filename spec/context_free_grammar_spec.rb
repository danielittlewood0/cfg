require 'context_free_grammar'
describe ContextFreeGrammar do
  describe "#alphabet" do
    it "non_terms + terms" do
      cfg = ContextFreeGrammar.new
      x = NonTerminal.new('X')
      a = Terminal.new('a')
      b = Terminal.new('b')
      cfg.terminals = [a,b]
      cfg.non_terminals = [x]

      expect(cfg.alphabet).to eq [x,a,b]
    end
  end

  describe "#alphabet_regex" do
    it "regex to match any letter from the alphabet of given CFG" do
      cfg = ContextFreeGrammar.new
      x = NonTerminal.new('X')
      a = Terminal.new('a')
      b = Terminal.new('b')
      cfg.terminals = [a,b]
      cfg.non_terminals = [x]
      regex = cfg.alphabet_regex

      expect(regex).to be_a Regexp
      match = "yyXaa".match(regex)
      expect(match.begin(0)).to eq 2
      expect(match.end(0)).to eq 3
    end

    it "can be used to match all letters (non-matches ignored)" do
      cfg = ContextFreeGrammar.new
      x = NonTerminal.new('<X>')
      a = Terminal.new('\alpha')
      b = Terminal.new('\beta')
      cfg.terminals = [a,b]
      cfg.non_terminals = [x]
      regex = cfg.alphabet_regex

      expect(regex).to be_a Regexp
      matches = "yy<X>\\alpha\\alpha<X>".scan(regex)
      expect(matches).to eq ["<X>","\\alpha","\\alpha","<X>"]
    end
  end

  describe "#lookup_letter" do
    it "Dictionary to look up a letter from its @char" do
      cfg = ContextFreeGrammar.new
      x = NonTerminal.new('X')
      a = Terminal.new('a')
      b = Terminal.new('b')
      cfg.terminals = [a,b]
      cfg.non_terminals = [x]

      expect(cfg.lookup_letter['X']).to eq x
      expect(cfg.lookup_letter['a']).to eq a
      expect(cfg.lookup_letter['Z']).to eq nil
    end
  end

  describe "#string_to_pseudo" do
    it "Takes a string of english letters and expresses it as pseudo_chars" do
      cfg = ContextFreeGrammar.new
      x = NonTerminal.new('X')
      a = Terminal.new('a')
      b = Terminal.new('b')
      cfg.terminals = [a,b]
      cfg.non_terminals = [x]
      cfg.start_sym = x
      to_match = cfg.string_to_pseudo("aaXbXb")
      expect(to_match).to be_a PseudoString
      expect(to_match.chars).to eq [a,a,x,b,x,b]
    end

    it "supports multi-character symbols" do
      cfg = ContextFreeGrammar.new
      x = NonTerminal.new('<X>')
      a = Terminal.new('\alpha')
      b = Terminal.new('\beta')
      cfg.terminals = [a,b]
      cfg.non_terminals = [x]
      cfg.start_sym = x
      to_parse = "\\alpha\\alpha<X>\\beta<X>\\beta"
      expect(cfg.string_to_pseudo(to_parse)).to be_a PseudoString
      expect(cfg.string_to_pseudo(to_parse).chars).to eq [a,a,x,b,x,b]
    end
  end

  describe "::default" do
    it "lowercase letters are Terminals" do
      default_terminals = ContextFreeGrammar.default.terminals
      expect(default_terminals.map(&:to_s)).to include(*('a'..'z').to_a)
    end

    it "upcase letters are NonTerminals" do
      default_non_terminals = ContextFreeGrammar.default.non_terminals
      expect(default_non_terminals.map(&:to_s)).to include(*('A'..'Z').to_a)
    end

    it "brackets are Terminals" do
      default_terminals = ContextFreeGrammar.default.terminals
      expect(default_terminals.map(&:to_s)).to include(*'()[]{}'.split(''))
    end
  end
end
