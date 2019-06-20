require 'production_rule'
describe ProductionRule do 
  describe '#rule,#ls,#rs' do
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

