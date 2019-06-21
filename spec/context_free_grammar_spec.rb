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

  context "docs" do
    it "consists of non_terminals, terminals and rules" do
      x = NonTerminal.with_char("x")
      y = NonTerminal.with_char("y")
      a = Terminal.with_char("a")
      b = Terminal.with_char("b")
      r_1 = ProductionRule.new(ls: x, rs: PseudoString.new([x,y]))
      r_2 = ProductionRule.new(ls: x, rs: PseudoString.new([x,y]))

      cfg = ContextFreeGrammar.new(
        terminals: [a,b],
        non_terminals: [x,y],
        rules: [r_1,r_2]
      )

      expect(cfg.non_terminals).to eq [x,y]
      expect(cfg.terminals).to eq [a,b]
      expect(cfg.rules).to eq [r_1,r_2]
    end
  end

  describe '#parse' do
    context "Example that used to have bad performance (solved)" do
      it "leftmost parse" do
        r_0 = rule(NonTerminal.with_char("S"), "SS".to_pseudo)
        r_1 = rule(NonTerminal.with_char("S"), "Y".to_pseudo)
        r_2 = rule(NonTerminal.with_char("Y"), "YXY".to_pseudo)
        r_3 = rule(NonTerminal.with_char("Y"), "a".to_pseudo)
        r_4 = rule(NonTerminal.with_char("X"), "b".to_pseudo)
        start = NonTerminal.with_char("S")
        rules = [r_0,r_1,r_2,r_3,r_4]
        given = "aaabaabaaa".to_pseudo
        step_1 = given.parse(start,rules)
        expect(step_1&.map{|w| w.to_s}).to eq [
            "S",
            "SS",
            "SY",
            "SSY",
            "SYY",
            "SSYY",
            "SYYY",
            "SYXYYY",
            "SYbYYY",
            "SSYbYYY",
            "SYYbYYY",
            "SYXYYbYYY",
            "SYbYYbYYY",
            "SYbYYbYYa",
            "SYbYYbYaa",
            "SYbYYbaaa",
            "SYbYabaaa",
            "SYbaabaaa",
            "Sabaabaaa",
            "SSabaabaaa",
            "SYabaabaaa",
            "Saabaabaaa",
            "Yaabaabaaa",
            "aaabaabaaa"
          ]
      end
    end

    it 'returns nil if no parse exists' do
      r_0 = rule(NonTerminal.with_char("X"),"aXb".to_pseudo)
      r_1 = rule(NonTerminal.with_char("X"),"ab".to_pseudo)
      rules = [r_0,r_1]
      given = "abb".to_pseudo
      expect( given.parse(NonTerminal.with_char("X"),rules) ).to eq nil
    end

    it 'performs incorrectly on palindromes' do
      start_sym = NonTerminal.with_char("X")
      r_0 = rule(NonTerminal.with_char("X"), "aXa".to_pseudo)
      r_1 = rule(NonTerminal.with_char("X"), "a".to_pseudo)
      r_2 = rule(NonTerminal.with_char("X"), "b".to_pseudo)
      rules = [r_0,r_1,r_2]
      given = "aba".to_pseudo
      expect(given.parse(start_sym,rules).map(&:to_s)).to eq [
        'X',
        'aXa',
        'aba'
      ]

    end
  end

end
