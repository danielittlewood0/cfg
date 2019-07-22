describe PseudoChar do
  it "delegates to Terminal and NonTerminal" do
  end

  describe "#as_pseudo_string" do
    it "coerces Char to String" do
      x = PseudoChar.new('x')
      expect(x.as_pseudo_string).to be_a PseudoString
    end

    it "preserves #to_s" do
      x = PseudoChar.new('x')
      expect(x.as_pseudo_string.to_s).to eq x.to_s
    end
  end
end
