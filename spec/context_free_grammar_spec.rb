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
    it "consists of non_terminals, terminals, a start symbol and rules" do
      x = NonTerminal.with_char("x")
      y = NonTerminal.with_char("y")
      a = Terminal.with_char("a")
      b = Terminal.with_char("b")
      r_1 = ProductionRule.new(ls: x, rs: PseudoString.new([x,y]))
      r_2 = ProductionRule.new(ls: x, rs: PseudoString.new([x,y]))

      cfg = ContextFreeGrammar.new(
        terminals: [a,b],
        non_terminals: [x,y],
        rules: [r_1,r_2],
        start_symbol: x
      )

      expect(cfg.non_terminals).to eq [x,y]
      expect(cfg.terminals).to eq [a,b]
      expect(cfg.rules).to eq [r_1,r_2]
      expect(cfg.start_symbol).to eq x
    end
  end

  describe "#parse_rule" do
    it "converts terminals and non-terminals; wraps up in a Rule" do
      x = NonTerminal.with_char("x")
      y = NonTerminal.with_char("y")
      a = Terminal.with_char("a")
      b = Terminal.with_char("b")

      cfg = ContextFreeGrammar.new(
        terminals: [a,b],
        non_terminals: [x,y],
      )

      parsed_rule = cfg.parse_rule("X -> aYb")
      expect(parsed_rule).to be_a ProductionRule
      expect(parsed_rule.ls).to be_a NonTerminal
      expect(parsed_rule.ls.to_s).to eq "X"
      expect(parsed_rule.rs).to be_a PseudoString
      expect(parsed_rule.rs.to_s).to eq "aYb"
    end
  end

  describe "#add_string_rule" do
    it "parses the rule and puts it in @rules" do
      x = NonTerminal.with_char("x")
      y = NonTerminal.with_char("y")
      a = Terminal.with_char("a")
      b = Terminal.with_char("b")

      cfg = ContextFreeGrammar.new(
        terminals: [a,b],
        non_terminals: [x,y],
      )
      expect(cfg.rules.length).to eq 0

      cfg.add_string_rule!("S -> SS")
      cfg.add_string_rule!("S -> Y")
      cfg.add_string_rule!("X -> aYb")

      expect(cfg.rules.length).to eq 3
      expect(cfg.rules.first.ls.to_s).to eq "S"
      expect(cfg.rules.first.rs.to_s).to eq "SS"
    end
  end

  describe '#parse' do
    context "Example that used to have bad performance (solved)" do
      it "Parses a PseudoString, starting on the left" do
        s = NonTerminal.with_char("S")
        x = NonTerminal.with_char("X")
        y = NonTerminal.with_char("Y")
        a = Terminal.with_char("a")
        b = Terminal.with_char("b")
        start = s

        cfg = ContextFreeGrammar.new(
          start_symbol: start, 
          non_terminals: [s,x,y],
          terminals: [a,b],
        )
        cfg.add_string_rule!("S -> SS")
        cfg.add_string_rule!("S -> Y")
        cfg.add_string_rule!("Y -> YXY")
        cfg.add_string_rule!("Y -> a")
        cfg.add_string_rule!("X -> b")

        given = "aaabaabaaa".to_pseudo
        expect(given).to be_a PseudoString
        parsed = cfg.parse(given)
        expect(parsed.map{|w| w.to_s}).to eq [
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
      x = NonTerminal.with_char("X")
      a = Terminal.with_char("a")
      b = Terminal.with_char("b")
      cfg = ContextFreeGrammar.new(
        start_symbol:x,
        non_terminals:[x],
        terminals:[a,b]
      )
      cfg.add_string_rule!("X -> aXb")
      cfg.add_string_rule!("X -> ab")
      given = "abb".to_pseudo
      expect( cfg.parse(given) ).to eq nil
    end

    it 'Used to perform incorrectly on palindromes' do
      x = NonTerminal.with_char("X")
      a = Terminal.with_char("a")
      b = Terminal.with_char("b")
      cfg = ContextFreeGrammar.new(
        start_symbol: x,
        non_terminals: [x],
        terminals: [a,b]
      )
      cfg.add_string_rule!("X -> aXa")
      cfg.add_string_rule!("X -> a")
      cfg.add_string_rule!("X -> b")
      given = "aba".to_pseudo
      expect(cfg.parse(given).map(&:to_s)).to eq [
        'X',
        'aXa',
        'aba'
      ]

    end
  end

end
