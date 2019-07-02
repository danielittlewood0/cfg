require 'move'
describe Move do 
  it 'represents a move being applied at some index' do
    ls = PseudoString.from_string_default("X")
    rs = PseudoString.from_string_default("aa")
    rule = rule(ls,rs)
    move = move(rule,1)
    expect(move.class).to eq Move 
    expect(move.index).to eq 1
    expect(move.rule).to eq rule
  end
end

