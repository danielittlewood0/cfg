require 'production_rule'
describe ProductionRule do 
  describe '#rule,#ls,#rs' do
    it 'factory' do
      x = 'X'.nt
      a = 'a'.t
      ls = ps([x])
      rs = ps([a,a])
      rul = rule(ls,rs) 
      expect(rul.class).to eq ProductionRule 
      expect(rul.ls).to eq ls
      expect(rul.rs).to eq rs
    end
  end

end

