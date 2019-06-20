require 'misc'
describe String do 
  describe '#to_pseudo' do
    it 'Given list of terms and non terms, turns string into pseudo string' do
      str = PseudoString.from_string_default("XXaaXYb")
      expect(str.class).to eq PseudoString 
      expect(str.chars).to eq [
        NonTerminal.with_char("X"), 
        NonTerminal.with_char("X"), 
        Terminal.with_char("a"), 
        Terminal.with_char("a"), 
        NonTerminal.with_char("X"), 
        NonTerminal.with_char("Y"), 
        Terminal.with_char("b")
      ]
    end
  end
end
