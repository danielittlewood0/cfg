require 'pseudo_string'
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
      expect(unapplied_1).to eq ls
    end
    unapplied_2 = applied.unapply(rul)
    it '#unapply undoes the leftmost instance' do
      expect(unapplied_2).to eq ls
    end
  end

  describe '#scan,#possible_undos' do
    word = "aaaababababaababababaaababa".to_pseudo
    ls = "X".to_pseudo
    rs = "aa".to_pseudo
    rule = rule(ls,rs)
    it 'finds all the indices a subword begins at' do
      indices = word.scan("aa".to_pseudo)
      expect(indices).to eq [0,1,2,11,20,21]
    end
    it 'fixed bug in #unapply' do
      expect(word.unapply_at(1,rule).write).to eq "aXababababaababababaaababa"
    end
   it 'finds all possible words an application could have come from' do
     possible_undos = word.possible_undos([rule])
     expect(possible_undos.map{|w| w.write}).to eq ["Xaababababaababababaaababa",
                                                    "aXababababaababababaaababa",
                                                    "aaXbabababaababababaaababa",
                                                    "aaaababababXbabababaaababa",
                                                    "aaaababababaababababXababa",
                                                    "aaaababababaababababaXbaba"]
   end
  end

  describe '#parse,#try_unapply,#unapply_failed' do
    r_0 = rule("S".to_pseudo,"SS".to_pseudo)
    r_1 = rule("S".to_pseudo,"Y".to_pseudo)
    r_2 = rule("Y".to_pseudo,"YXY".to_pseudo)
    r_3 = rule("Y".to_pseudo,"a".to_pseudo)
    r_4 = rule("X".to_pseudo,"b".to_pseudo)
    start = "S".to_pseudo
    rules = [r_0,r_1,r_2,r_3,r_4]
    given = "aaabaabaaa".to_pseudo

    context 'Really slow on some examples' do
      it '#parses' do
        step_1 = given.parse("S".nt,rules)
        expect(step_1.map{|w| w.write}).to eq [
          "S",
          "SS",
          "SSS",
          "SYS",
          "SYXYS",
          "SYbYS",
          "SSYbYS",
          "SYYbYS",
          "SYXYYbYS",
          "SYbYYbYS",
          "SYbYYbYSS",
          "SYbYYbYSY",
          "SYbYYbYSa",
          "SYbYYbYYa",
          "SYbYYbYaa",
          "SYbYYbaaa",
          "SYbYabaaa",
          "SYbaabaaa",
          "Sabaabaaa",
          "SSabaabaaa",
          "SYabaabaaa",
          "Saabaabaaa",
          "Yaabaabaaa",
          "aaabaabaaa"
        ]
      end
    end
  end

  describe 'apply' do
    it '' do
      x = 'X'.nt
      y = 'Y'.nt
      a = 'a'.t
      non_terms = ['X','Y']
      terms = ['a']
      line_1 = 'X'.to_pseudo(non_terms,terms)
      line_2 = 'YY'.to_pseudo(non_terms,terms)
      line_3 = 'aY'.to_pseudo(non_terms,terms)

      r_1 = rule(ps([x]),line_2)
      r_2 = rule(ps([y]),ps([a]))
      expect(line_1.apply(r_1)).to eq line_2
      expect(line_2.apply(r_2)).to eq line_3
      expect(line_2.apply(r_1)).to eq line_2
    end
  end

  describe '#parse' do
    it 'returns nil if no parse exists' do
      r_0 = rule("X".to_pseudo,"aXb".to_pseudo)
      r_1 = rule("X".to_pseudo,"ab".to_pseudo)
      rules = [r_0,r_1]
      given = "abb".to_pseudo
      expect( given.parse("X".nt,rules) ).to eq nil
    end

    it 'performs incorrectly on palindromes' do
      start_sym = "X".nt
      r_0 = rule("X".to_pseudo,"aXa".to_pseudo)
      r_1 = rule("X".to_pseudo,"a".to_pseudo)
      r_2 = rule("X".to_pseudo,"b".to_pseudo)
      rules = [r_0,r_1,r_2]
      given = "aba".to_pseudo
      expect(given.parse(start_sym,rules).map(&:write)).to eq [
        'X',
        'aXa',
        'aba'
      ]


    end
  end


end