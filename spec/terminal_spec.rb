require 'terminal'
describe Terminal do
  context "docs" do
    # duplicated code from NonTerminal; extract out. 
    it "contains an ordinary String as its symbol" do
      x = Terminal.with_char("x")
      expect(x.char).to be_a String
      expect(x.char).to eq "x"
    end

    it "can have a multi-char string" do
      x = Terminal.with_char("<Object>")
      expect(x.char).to be_a String
      expect(x.char).to eq "<Object>"
    end
  end

  describe "::with_char" do
    it "wraps a string up in a NonTerminal" do
      x = NonTerminal.with_char('X')
      expect(x.class).to eq NonTerminal 
      expect(x.char).to eq 'X' 
    end
  end

  describe '==' do
    it 'two terminals are equal when they have the same character' do
      x = Terminal.with_char('X')
      y = Terminal.with_char('X')
      expect(x.char).to eq 'X'
      expect(y.char).to eq 'X'
      expect(x.class).to eq Terminal
      expect(y.class).to eq Terminal
      expect(x == y).to eq true
    end
  end
end

