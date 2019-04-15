require 'terminal'
describe Terminal do
  describe '==' do
    it 'two terminals are equal when they have the same character' do
      x = 'X'.t
      y = 'X'.t
      expect(x.char).to eq 'X'
      expect(y.char).to eq 'X'
      expect(x.class).to eq Terminal
      expect(y.class).to eq Terminal
      expect(x == y).to eq true
    end
  end
end

