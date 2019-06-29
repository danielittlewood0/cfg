require 'context_free_grammar'
describe ContextFreeGrammar do
  describe "#string_to_pseudo" do
    it "Takes a string of english letters and expresses it as pseudo_chars" do
      cfg = ContextFreeGrammar.new
      x = NonTerminal.new('X')
      a = Terminal.new('a')
      b = Terminal.new('b')
      cfg.terminals = [a,b]
      cfg.non_terminals = [x]
      cfg.start_sym = x
      expect(cfg.string_to_pseudo("aaXbXb")).to be_a PseudoString
      expect(cfg.string_to_pseudo("aaXbXb").chars).to eq [a,a,x,b,x,b]
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

    xit "Involved example" do
      cfg = ContextFreeGrammar.new
      verb_phrase = NonTerminal.new("<Verb phrase>")
      verb = NonTerminal.new("<Verb>")
      subject = NonTerminal.new("<Subject>")
      object = NonTerminal.new("<Object>")
      cfg.start_sym = verb_phrase
      cfg.rules << cfg.parse_rule("<Verb phrase> -> <Subject> <Verb> <Object>")

    end
  end
end
