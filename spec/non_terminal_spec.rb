require 'non_terminal'
describe NonTerminal do
  context "docs" do
    it "contains an ordinary String as its symbol" do
      x = NonTerminal.with_char("x")
      expect(x.char).to be_a String
      expect(x.char).to eq "x"
    end

    it "can have a multi-char string" do
      x = NonTerminal.with_char("<Object>")
      expect(x.char).to be_a String
      expect(x.char).to eq "<Object>"
    end
  end

  describe '::with_char' do
    it "wraps a string up in a Terminal" do
      a = Terminal.with_char('a')
      expect(a.class).to eq Terminal 
      expect(a.char).to eq 'a' 
    end
  end

  describe '==' do
    it 'two non-terminals are equal when they have the same character' do
      x = NonTerminal.with_char('x')
      y = NonTerminal.with_char('x')
      expect(x.char).to eq 'x'
      expect(y.char).to eq 'x'
      expect(x.class).to eq NonTerminal
      expect(y.class).to eq NonTerminal
      expect(x == y).to eq true
    end

    it 'has to be the same class' do
      x = NonTerminal.with_char('x')
      y = Terminal.with_char('x')
      expect(x.char).to eq 'x'
      expect(y.char).to eq 'x'
      expect(x.class).to eq NonTerminal
      expect(y.class).to eq Terminal
      expect(x == y).to eq false
    end
  end
end
