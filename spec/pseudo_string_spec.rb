require 'pseudo_string'
describe PseudoString do
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


  describe '#apply,#unapply' do
    x = 'X'.nt
    a = 'a'.t
    ls = ps([x])
    rs = ps([a,a])
    rul = rule(ls,rs) 
    applied = ps([ls]).apply(rul)
    it '#apply replaces X by aa' do
      expect(applied.to_s).to eq "aa"
    end
    unapplied_2 = applied.unapply(rul)
    it '#unapply undoes the leftmost instance' do
      expect(unapplied_2).to eq ps([ls])
    end
  end

  describe "#unapply_at" do
    x = 'X'.nt
    a = 'a'.t
    ls = ps([x])
    rs = ps([a,a])
    rul = rule(ls,rs) 
    applied = ls.apply(rul)
    it '#unapply_at undoes this application (but needs index)' do
      unapplied_1 = applied.unapply_at(0,rul)
      expect(unapplied_1).to eq ls
    end
    it "returns nil if given nil index" do
      unapplied_2 = applied.unapply_at(nil,rul)
      expect(unapplied_2).to eq nil
    end
    it "returns nil if match fails" do
      unapplied_3 = applied.unapply_at(1,rul)
      expect(unapplied_3).to eq nil
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
     expect(possible_undos.map{|w| w.write}).to eq ["Xaababababaababababaaababa"]
   end
  end

  describe '#parse,#try_unapply,#unapply_failed' do
    r_0 = rule(NonTerminal.with_char("S"), PseudoString.from_string_default("SS"))
    r_1 = rule(NonTerminal.with_char("S"), PseudoString.from_string_default("Y"))
    r_2 = rule(NonTerminal.with_char("Y"), PseudoString.from_string_default("YXY"))
    r_3 = rule(NonTerminal.with_char("Y"), PseudoString.from_string_default("a"))
    r_4 = rule(NonTerminal.with_char("X"), PseudoString.from_string_default("b"))
    start = PseudoString.from_string_default("S")
    rules = [r_0,r_1,r_2,r_3,r_4]
    given = PseudoString.from_string_default("aaabaabaaa")

    context "Example that used to have bad performance (solved)" do
      it "leftmost parse" do
        step_1 = given.parse("S".nt,rules)
        expect(step_1.map{|w| w.write}).to eq [
            "S",
            "SS",
            "SY",
            "SSY",
            "SYY",
            "SSYY",
            "SYYY",
            "SYXYYY",
            "SYbYYY",
            "SSYbYYY",
            "SYYbYYY",
            "SYXYYbYYY",
            "SYbYYbYYY",
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
      x = NonTerminal.with_char('X')
      y = NonTerminal.with_char('Y')
      a = Terminal.with_char('a')
      line_1 = PseudoString.from_string_default('X')
      line_2 = PseudoString.from_string_default('YY')
      line_3 = PseudoString.from_string_default('aY')

      r_1 = rule(x,line_2)
      r_2 = rule(y,ps([a]))
      expect(line_1.apply(r_1)).to eq line_2
      expect(line_2.apply(r_2)).to eq line_3
      expect(line_2.apply(r_1)).to eq line_2
    end
  end

  describe '#parse' do
    it 'returns nil if no parse exists' do
      r_0 = rule(NonTerminal.with_char("X"),PseudoString.from_string_default("aXb"))
      r_1 = rule(NonTerminal.with_char("X"),PseudoString.from_string_default("ab"))
      rules = [r_0,r_1]
      given = PseudoString.from_string_default("abb")
      expect( given.parse(NonTerminal.with_char("X"),rules) ).to eq nil
    end

    it 'performs incorrectly on palindromes' do
      start_sym = NonTerminal.with_char("X")
      r_0 = rule(NonTerminal.with_char("X"), PseudoString.from_string_default("aXa"))
      r_1 = rule(NonTerminal.with_char("X"), PseudoString.from_string_default("a"))
      r_2 = rule(NonTerminal.with_char("X"), PseudoString.from_string_default("b"))
      rules = [r_0,r_1,r_2]
      given = PseudoString.from_string_default("aba")
      expect(given.parse(start_sym,rules).map(&:write)).to eq [
        'X',
        'aXa',
        'aba'
      ]
    end
  end
end
