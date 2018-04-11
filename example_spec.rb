require './example.rb'

describe NonTerminal do
  describe 'initialize' do
    it 'should not do anything interesting' do
      exp = nonterm('A')
      expect(exp.class).to eq NonTerminal
    end
  end
end

describe Terminal do
  describe 'initialize' do
    it 'should not do anything interesting' do
      exp = term('A')
      expect(exp.class).to eq Terminal
    end
  end
end

describe StartSymbol do
  describe 'initialize' do
    it 'should not do anything interesting' do
      exp = start('A')
      expect(exp.class).to eq StartSymbol
    end
  end
end
