require 'production_rule'
describe ProductionRule do 
  context "docs" do
    it "consists of a #ls and #rs" do
      x = NonTerminal.with_char('X')
      a = Terminal.with_char('a')
      rs = PseudoString.new([a,a])
      ProductionRule.new(ls: x,rs: rs) 
      expect(rul.class).to eq ProductionRule 
      expect(rul.ls).to eq x
      expect(rul.ls).to be_a NonTerminal
      expect(rul.rs).to eq rs
      expect(rul.rs).to be_a PseudoString
    end
  end

  describe "#initialize,#ls,#rs" do
    it 'factory' do
      x = NonTerminal.with_char('X')
      a = Terminal.with_char('a')
      ls = PseudoString.new([x])
      rs = PseudoString.new([a,a])
      rul = ProductionRule.new(ls: ls, rs: rs)
      expect(rul.class).to eq ProductionRule 
      expect(rul.ls).to eq ls
      expect(rul.rs).to eq rs
    end
  end

end

