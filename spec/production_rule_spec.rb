require 'production_rule'
describe ProductionRule do 
  context "docs" do
    it "consists of a #ls and #rs" do
      x = NonTerminal.with_char('X')
      a = Terminal.with_char('a')
      rs = PseudoString.new([a,a])
      rule = ProductionRule.new(ls: x,rs: rs) 
      expect(rule.class).to eq ProductionRule 
      expect(rule.ls).to eq x
      expect(rule.ls).to be_a NonTerminal
      expect(rule.rs).to eq rs
      expect(rule.rs).to be_a PseudoString
    end
  end

  describe "#initialize,#ls,#rs" do
    it 'factory' do
      x = NonTerminal.with_char('X')
      a = Terminal.with_char('a')
      ls = PseudoString.new([x])
      rs = PseudoString.new([a,a])
      rule = ProductionRule.new(ls: ls, rs: rs)
      expect(rule.class).to eq ProductionRule 
      expect(rule.ls).to eq ls
      expect(rule.rs).to eq rs
    end
  end

end

