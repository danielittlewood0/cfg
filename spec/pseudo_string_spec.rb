require 'pseudo_string'
describe PseudoString do
  describe Enumerable do
    it "#each enumerates through chars" do
      string = "aXa".to_pseudo
      expect(string.each).to be_a Enumerator
      expect(string.each.to_a).to eq string.chars
    end

    it "mixes in module methods like #each_cons" do
      string = "aXa".to_pseudo
      pairs = string.each_cons(2).to_a.map{|sub_chars| PseudoString.new(sub_chars)}
      expect(pairs.map(&:to_s)).to eq ["aX","Xa"]
    end
  end

  describe '#to_s' do
    it 'turns a pseudo-string into a string' do
      pseudo_string = PseudoString.from_string_default("hello")
      string = pseudo_string.write
      expect(string).to eq "hello"
    end
  end

  describe '#==' do
    it 'two strings are the same iff they have the same chars' do
      hello_1 = ps("hello".split('').map{|c| Terminal.with_char(c)})
      hello_2 = ps("hello".split('').map{|c| Terminal.with_char(c)})
      hello_3 = ps("hello".split('').map{|c| NonTerminal.with_char(c)})
      
      expect(hello_1 == hello_2).to eq true 
      expect(hello_2 == hello_3).to eq false
    end
  end

  describe '#+,#+=' do
    str_1 = PseudoString.from_string_default("aBc")
    str_2 = PseudoString.from_string_default("AbC")

    it 'joins two pseudo-strings' do
      expect(str_1 + str_2).to eq PseudoString.from_string_default("aBcAbC")
    end

    it 'does += work?' do
      str_1 += str_2
      expect(str_1 + str_2).to eq PseudoString.from_string_default("aBcAbCAbC")
    end
  end

  describe '#apply_rule' do
    it 'replaces the leftmost instance of ls with rs' do
      x = NonTerminal.with_char('X')
      a = Terminal.with_char('a')
      ls = x
      rs = ps([a,a])
      rul = rule(ls,rs) 
      expect(ps([ls]).apply(rul).to_s).to eq "aa"
    end
  end

  describe "#subwords_of_length" do
    it "Enumerator containing all sub words of self of given length" do
      word = "abcd".to_pseudo
      subwords = word.subwords_of_length(2)
      expect(subwords).to be_a Enumerator
      expect(subwords.map(&:to_s)).to eq ["ab","bc","cd"]
    end
  end

  describe '#index' do
    str_1 = PseudoString.from_string_default("aBc")
    str_2 = PseudoString.from_string_default("AbC")

    eg_1 = PseudoString.from_string_default("aBaBaCbAbCaBcAbA")
    eg_2 = PseudoString.from_string_default("aCbCbCbCaBcBaBc")
    eg_3 = PseudoString.from_string_default("CaCbAbCaBc")
    
    it 'returns index of leftmost occurrence of a word' do
      expect(eg_1.index(str_1)).to eq 10
      expect(eg_1.index(str_2)).to eq 7
    end
    it 'returns index of leftmost occurrence of a word' do
      expect(eg_2.index(str_1)).to eq 8
      expect(eg_2.index(str_2)).to eq nil
    end
    it 'returns index of leftmost occurrence of a word' do
      expect(eg_3.index(str_1)).to eq 7
      expect(eg_3.index(str_2)).to eq 4
    end
  end

  describe '#apply, #apply_at' do
    it "apply replaces leftmost X by aa" do
      x = NonTerminal.with_char('X')
      a = Terminal.with_char('a')
      ls = x
      rs = ps([a,a])
      rul = rule(ls,rs) 
      applied = ps([ls]).apply(rul)
      expect(applied.to_s).to eq "aa"
    end

    it "apply_at replaces at a given point" do
      x = NonTerminal.with_char('X')
      y = NonTerminal.with_char('Y')
      a = Terminal.with_char('a')
      non_terms = ['X','Y']
      terms = ['a']
      line_1 = 'X'.to_pseudo(non_terms,terms)
      line_2 = 'YY'.to_pseudo(non_terms,terms)
      line_3 = 'aY'.to_pseudo(non_terms,terms)
      line_4 = 'Ya'.to_pseudo(non_terms,terms)

      r_1 = rule(x,line_2)
      r_2 = rule(y,ps([a]))
      expect(line_1.apply(r_1)).to eq line_2
      expect(line_2.apply(r_2)).to eq line_3
      expect(line_2.apply(r_1)).to eq line_2
      expect(line_2.apply_at(1,r_2)).to eq line_4
    end

    it "apply_at returns self if no application" do
      x = NonTerminal.with_char('X')
      y = NonTerminal.with_char('Y')
      a = Terminal.with_char('a')
      non_terms = ['X','Y']
      terms = ['a']
      line_1 = ps([x])
      line_2 = ps([y,y])

      r_1 = rule(x,line_2)
      r_2 = rule(y,ps([a]))
      expect(line_1.apply(r_2)).to eq line_1
      expect(line_1.apply_at(1,r_2)).to eq line_1
    end
  end

  describe "#unapply, #unapply_at" do
    x = NonTerminal.with_char('X')
    a = Terminal.with_char('a')
    ls = x
    rs = ps([a,a])
    rul = rule(ls,rs) 
    applied = ps([ls]).apply(rul)
    it '#unapply_at undoes this application (but needs index)' do
      unapplied_1 = applied.unapply_at(0,rul)
      expect(unapplied_1).to eq ps([ls])
    end
    it "returns nil if given nil index" do
      unapplied_2 = applied.unapply_at(nil,rul)
      expect(unapplied_2).to eq nil
    end
    it "returns nil if match fails" do
      unapplied_3 = applied.unapply_at(1,rul)
      expect(unapplied_3).to eq nil
    end

    it '#unapply undoes the leftmost instance' do
      unapplied_4 = applied.unapply(rul)
      expect(unapplied_4).to eq ps([ls])
    end
  end

  describe '#scan,#possible_undos' do
    word = PseudoString.from_string_default("aaaababababaababababaaababa")
    ls = NonTerminal.with_char("X")
    rs = PseudoString.from_string_default("aa")
    rule = rule(ls,rs)
    it 'finds all the indices a subword begins at' do
      indices = word.scan(PseudoString.from_string_default("aa"))
      expect(indices).to eq [0,1,2,11,20,21]
    end
    it 'fixed bug in #unapply' do
      expect(word.unapply_at(1,rule).to_s).to eq "aXababababaababababaaababa"
    end
   it 'finds all possible words an application could have come from' do
     possible_undos = word.possible_undos([rule])
     expect(possible_undos.map{|w| w.to_s}).to eq ["Xaababababaababababaaababa",
                                                    "aXababababaababababaaababa",
                                                    "aaXbabababaababababaaababa",
                                                    "aaaababababXbabababaaababa",
                                                    "aaaababababaababababXababa",
                                                    "aaaababababaababababaXbaba"]
   end

   it 'finds all possible words an application could have come from (leftmost)' do
     possible_undos = word.leftmost_possible_undos([rule])
     expect(possible_undos.map{|w| w.to_s}).to eq ["Xaababababaababababaaababa"]
   end
  end
end
