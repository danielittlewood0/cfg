load './cfg_new.rb'

describe Terminal do
  describe '==' do
    it 'two terminals are equal when they have the same character' do
      x = 'X'.t
      y = 'X'.t
      expect(x.char).to eq 'X'
      expect(y.char).to eq 'X'
      expect(x.class).to eq Terminal
      expect(y.class).to eq Terminal
      expect(x == y).to eq true
    end
  end
end

describe NonTerminal do
  describe '==' do
    it 'two non-terminals are equal when they have the same character' do
      x = 'x'.nt
      y = 'x'.nt
      expect(x.char).to eq 'x'
      expect(y.char).to eq 'x'
      expect(x.class).to eq NonTerminal
      expect(y.class).to eq NonTerminal
      expect(x == y).to eq true
    end

    it 'has to be the same class' do
      x = 'x'.nt
      y = 'x'.t
      expect(x.char).to eq 'x'
      expect(y.char).to eq 'x'
      expect(x.class).to eq NonTerminal
      expect(y.class).to eq Terminal
      expect(x == y).to eq false
    end
  end
end

describe String do 
  describe '#nt' do
    it 'factory' do
      x = 'X'.nt
      expect(x.class).to eq NonTerminal 
      expect(x.char).to eq 'X' 
    end
  end

  describe '#t' do
    it 'factory' do
      a = 'a'.t
      expect(a.class).to eq Terminal 
      expect(a.char).to eq 'a' 
    end
  end

  describe '#to_psuedo' do
    it 'Given list of terms and non terms, turns string into pseudo string' do
      non_terms = ["X","Y"]
      terms = ["a","b"]
      str = "XXaaXYb".to_pseudo(non_terms,terms)
      expect(str.class).to eq PseudoString 
      expect(str.chars).to eq ["X".nt, "X".nt, "a".t, "a".t, "X".nt, "Y".nt, "b".t]
    end
  end
end

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

describe PseudoString do
  describe '#write' do
    it 'turns a pseudo-string into a string' do
      pseudo_string = "hello".to_pseudo(non_terms=[],terms="hello".split(''))
      string = pseudo_string.write
      expect(string).to eq "hello"
    end
  end

  describe '#==' do
    it 'two strings are the same iff they have the same chars' do
      hello_1 = ps("hello".split('').map{|c| c.t})
      hello_2 = ps("hello".split('').map{|c| c.t})
      hello_3 = ps("hello".split('').map{|c| c.nt})
      
      expect(hello_1 == hello_2).to eq true 
      expect(hello_2 == hello_3).to eq false
    end
  end

  describe '#+,#+=' do
    terms = "abc".split('')
    non_terms = "ABC".split('')
    str_1 = "aBc".to_pseudo(non_terms,terms)
    str_2 = "AbC".to_pseudo(non_terms,terms)

    it 'joins two pseudo-strings' do
      expect(str_1 + str_2).to eq "aBcAbC".to_pseudo(non_terms,terms)
    end

    it 'does += work?' do
      str_1 += str_2
      expect(str_1 + str_2).to eq "aBcAbCAbC".to_pseudo(non_terms,terms)
    end
  end

  describe '#apply_rule' do
    it 'replaces the leftmost instance of ls with rs' do
      x = 'X'.nt
      a = 'a'.t
      ls = ps([x])
      rs = ps([a,a])
      rul = rule(ls,rs) 
      expect(ls.apply(rul).write).to eq "aa"
    end
  end

  describe '#index' do
    terms = "abc".split('')
    non_terms = "ABC".split('')
    str_1 = "aBc".to_pseudo(non_terms,terms)
    str_2 = "AbC".to_pseudo(non_terms,terms)

    eg_1 = "aBaBaCbAbCaBcAbA".to_pseudo(non_terms,terms)
    eg_2 = "aCbCbCbCaBcBaBc".to_pseudo(non_terms,terms)
    eg_3 = "CaCbAbCaBc".to_pseudo(non_terms,terms)
    
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


  describe '#apply,#unapply_at,#unapply' do
    x = 'X'.nt
    a = 'a'.t
    ls = ps([x])
    rs = ps([a,a])
    rul = rule(ls,rs) 
    applied = ls.apply(rul)
    it '#apply replaces X by aa' do
      expect(applied.write).to eq "aa"
    end
    unapplied_1 = applied.unapply_at(0,rul)
    it '#unapply_at undoes this application (but needs index)' do
      expect(unapplied).to eq ls
    end
    unapplied_2 = applied.unapply(rul)
    it '#unapply undoes the leftmost instance' do

    end
  end

end
#  xdescribe 'eg2' do
#    it '' do
#      x = 'X'.nt
#      y = 'Y'.nt
#      a = 'a'.t
#      non_terms = ['X','Y']
#      terms = ['a']
#      line_1 = 'X'.to_pseudo(non_terms,terms)
#      line_2 = 'YY'.to_pseudo(non_terms,terms)
#      line_3 = 'aY'.to_pseudo(non_terms,terms)
#
#      r_1 = rule(ps([x]),line_2)
#      r_2 = rule(ps([y]),ps([a]))
#      p line_3.unapply(r_2,0)
#      p r_2.rs
#      p line_3.index(r_2.rs)
#      p line_3.possible_undos([r_1,r_2])
#      expect(line_1.apply(r_1)).to eq line_2
#      expect(line_2.apply(r_2)).to eq line_3
#      expect(line_2.apply(r_1)).to eq line_2
#    end
#  end
#
#end
