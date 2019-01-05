load './lib/cfg_new.rb'

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

  xdescribe '#parse,#try_unapply,#unapply_failed' do
    r_0 = rule("S".to_pseudo,"SS".to_pseudo)
    r_1 = rule("S".to_pseudo,"Y".to_pseudo)
    r_2 = rule("Y".to_pseudo,"YXY".to_pseudo)
    r_3 = rule("Y".to_pseudo,"a".to_pseudo)
    r_4 = rule("X".to_pseudo,"b".to_pseudo)
    start = "S".to_pseudo
    rules = [r_0,r_1,r_2,r_3,r_4]
    given = "aaabaabaaa".to_pseudo
    context '' do

      it '#parses' do
        step_1 = given.parse(rules)
        puts step_1.map{|w| w.write}
      end
      
      
    end
  end

  xdescribe 'eg2' do
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
   #  p line_3.unapply(r_2,0)
   #  p r_2.rs
   #  p line_3.index(r_2.rs)
   #  p line_3.possible_undos([r_1,r_2])
      expect(line_1.apply(r_1)).to eq line_2
      expect(line_2.apply(r_2)).to eq line_3
      expect(line_2.apply(r_1)).to eq line_2
    end
  end


  describe "#to_abstract_word" do 
    it "converts all chars into abstract chars" do
      pseudo = "abCD".to_pseudo
      abstract = pseudo.to_abstract
      expect(abstract.class).to eq AbstractWord
      abstract_chars = abstract.abstract_chars
      check = abstract_chars.all?{|char| char.class == AbstractChar}
      expect(check).to eq true
    end
  end
end

describe AbstractWord do
  describe "#to_pseudo" do 
    it "forgets structure" do
      pseudo = "abCD".to_pseudo
      abstract = pseudo.to_abstract
      expect(abstract.to_pseudo).to eq pseudo
    end
  end

  describe "#write" do 
    it "writes out the top level chars" do
      abstract = "abCD".to_pseudo.to_abstract
      expect(abstract.write).to eq "abCD"
    end
  end
  
  describe "==" do
    it "compares array of characters" do
      abstract_1 = "abCD".to_pseudo.to_abstract
      abstract_2 = "abCD".to_pseudo.to_abstract
      expect(abstract_1).to eq abstract_2
    end
  end

  describe "+" do
    it "concatenates chars" do
      abstract_1 = "abCD".to_pseudo.to_abstract
      abstract_2 = "Efg".to_pseudo.to_abstract
      expect((abstract_1 + abstract_2).write).to eq "abCDEfg"
    end
  end

  describe "[]" do
    it "selects from the chars array" do
      abstract_1 = "abCD".to_pseudo.to_abstract
      abstract_2 = abstract_1[1..2]
      expect(abstract_2.write).to eq "bC"
    end
  end

  describe "length" do
    it "length of the chars array" do
      abstract_1 = "abCD".to_pseudo.to_abstract
      abstract_2 = abstract_1[1..2]
      expect(abstract_1.length).to eq 4
      expect(abstract_2.length).to eq 2
    end
  end

  describe "index" do
    it "given a pseudo string, gives the first appearance in chars" do
      abstract = "abaabab".to_pseudo.to_abstract
      pseudo = "aab".to_pseudo
      expect(abstract.index(pseudo)).to eq 2
    end
  end

  describe "unapply_at" do 

    it '#unapply_at undoes this application (but needs index)' do
      ls = 'X'.to_pseudo
      rs = 'aa'.to_pseudo
      rul = rule(ls,rs) 
      applied = 'aabbabaab'.to_pseudo.to_abstract
      unapplied_1 = applied.unapply_at(6,rul)
      expect(unapplied_1.write).to eq 'aabbabXb'
    end

    it "builds the parse tree" do
      ls = 'X'.to_pseudo
      rs = 'aa'.to_pseudo
      rul = rule(ls,rs) 
      applied = 'aabbabaab'.to_pseudo.to_abstract
      unapplied_1 = applied.unapply_at(6,rul)
      built_tree = 'aabbabXb'.to_pseudo.to_abstract
      x = built_tree.abstract_chars[6]
      x.move = rul
      x.child_nodes = rs.chars.map{|ch| AbstractChar.new(ch)}
      x.child_nodes.each{|y| y.parent = x}
      expect(unapplied_1).to eq built_tree
    end

    it '#unapply_at the leftmost instance' do
      ls = 'X'.to_pseudo
      rs = 'aa'.to_pseudo
      rul = rule(ls,rs) 
      applied = 'aabbabaab'.to_pseudo.to_abstract
      unapplied_2 = applied.unapply(rul)
      built_tree = 'Xbbabaab'.to_pseudo.to_abstract
      x = built_tree.abstract_chars[0]
      x.move = rul
      x.child_nodes = rs.chars.map{|ch| AbstractChar.new(ch)}
      x.child_nodes.each{|y| y.parent = x}
      expect(unapplied_2).to eq built_tree
    end
  end

  describe "scan" do
    ls = 'X'.to_pseudo
    rs = 'aa'.to_pseudo
    rul = rule(ls,rs) 
    applied = 'aabbabaab'.to_pseudo.to_abstract

    it 'finds all indices of pseudo_word matching abstract_word' do
      expect(applied.scan(rs)).to eq [0,6]
    end
  end

  describe "possible_undos" do
    it "Given set of rules, shows all possible previous parse trees" do
      ls = 'X'.to_pseudo
      rs = 'aa'.to_pseudo
      rul = rule(ls,rs) 
      applied = 'aabbabaab'.to_pseudo.to_abstract
      u_1 = applied.unapply_at(0,rul)
      u_2 = applied.unapply_at(6,rul)

      expect(applied.possible_undos([rul])).to eq [u_1,u_2]
    end
  end

  describe "parse" do
    it "Hopefully generates the parse tree for a word" do
      ls = 'X'.to_pseudo
      rs = 'aa'.to_pseudo
      rul = rule(ls,rs) 
      applied = 'aabbabaab'.to_pseudo.to_abstract
      parsed = applied.parse([rul]).first
      puts parsed.tree_view
    end

    it "example 2" do
      implies = rule("P".to_pseudo,"(P => P)".to_pseudo)
      a = rule("P".to_pseudo,"a".to_pseudo)
      b = rule("P".to_pseudo,"b".to_pseudo)
      to_parse = "(b => (a => b))".to_pseudo.to_abstract
      puts to_parse.parse([implies,a,b]).first.tree_view
    end
  end
end
