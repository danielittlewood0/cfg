require 'move'
describe Move do 
  context "docs" do
    it "represents a move being applied at some index; #initialize" do
      ls = PseudoString.from_string_default("X")
      rs = PseudoString.from_string_default("aa")
      rule = ProductionRule.new(ls: ls,rs: rs)
      move = Move.new(rule: rule, index: 1)

      expect(move.class).to eq Move 
      expect(move.index).to eq 1
      expect(move.rule).to eq rule
    end

    it "can be 'applied' to a pseudo_string; implemented there for chaining" do
      receiver = PseudoString.from_string_default("X")
      ls = PseudoString.from_string_default("X")
      rs = PseudoString.from_string_default("Xa")
      rule = ProductionRule.new(ls: ls,rs: rs)
      move = Move.new(rule: rule, index: 1)

      result = receiver.apply(rule).apply(rule).apply(rule)
      expect(result.to_s).to eq "XXXa"
    end
  end
end

