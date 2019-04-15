require 'misc'
describe String do 
  describe '#nt' do
    it 'factory' do
      x = 'X'.nt
      expect(x.class).to eq NonTerminal 
      expect(x.char).to eq 'X' 
    end
  end

  describe '#t' do
    it 'factory' do
      a = 'a'.t
      expect(a.class).to eq Terminal 
      expect(a.char).to eq 'a' 
    end
  end

  describe '#to_psuedo' do
    it 'Given list of terms and non terms, turns string into pseudo string' do
      non_terms = ["X","Y"]
      terms = ["a","b"]
      str = "XXaaXYb".to_pseudo(non_terms,terms)
      expect(str.class).to eq PseudoString 
      expect(str.chars).to eq ["X".nt, "X".nt, "a".t, "a".t, "X".nt, "Y".nt, "b".t]
    end
  end
end
