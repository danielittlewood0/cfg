describe Move do 
  it 'represents a move being applied at some index' do
    ls = "X".to_pseudo
    rs = "aa".to_pseudo
    rule = rule(ls,rs)
    move = move(rule,1)
    expect(move.class).to eq Move 
    expect(move.index).to eq 1
    expect(move.rule).to eq rule
  end
end

