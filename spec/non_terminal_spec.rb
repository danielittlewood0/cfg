describe NonTerminal do
  describe '==' do
    it 'two non-terminals are equal when they have the same character' do
      x = 'x'.nt
      y = 'x'.nt
      expect(x.char).to eq 'x'
      expect(y.char).to eq 'x'
      expect(x.class).to eq NonTerminal
      expect(y.class).to eq NonTerminal
      expect(x == y).to eq true
    end

    it 'has to be the same class' do
      x = 'x'.nt
      y = 'x'.t
      expect(x.char).to eq 'x'
      expect(y.char).to eq 'x'
      expect(x.class).to eq NonTerminal
      expect(y.class).to eq Terminal
      expect(x == y).to eq false
    end
  end
end
