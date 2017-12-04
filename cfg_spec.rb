require './cfg.rb'

describe '#valid?' do

end

describe 'context-free-grammar' do
  it 'initializes' do
    terminals = ('a'..'z').to_a
    non_terminals = ('A'..'Z').to_a
    start = 'S'
    rules = [rule('S','AA'),rule('A','ab')]
    cfg = ContextFreeGrammar.new(terminals,non_terminals,start,rules)
    p cfg.start
    p cfg.terminals
    p cfg.non_terminals
  end
end

describe 'apply_first' do
  it 'applies a substitution rule to the first place it can' do
    "S".apply_with_input(rule('S','AA'))
  end
end
