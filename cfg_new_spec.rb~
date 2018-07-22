load './cfg_new.rb'

describe 'Factory' do
	
end

describe String do 
	it '#nt' do
		x = 'X'.nt
		expect(x.class).to eq NonTerminal 
		expect(x.char).to eq 'X' 
	end

	it '#t' do
		a = 'a'.t
		expect(a.class).to eq Terminal 
		expect(a.char).to eq 'a' 
	end

	it '#to_psuedo' do
		non_terms = ["X","Y"]
		terms = ["a","b"]
		str = "XXaaXYb".to_pseudo(non_terms,terms)
		expect(str.class).to eq PseudoString 
		expect(str.chars).to eq ["X".nt, "X".nt, "a".t, "a".t, "X".nt, "Y".nt, "b".t]
	end
end

describe ProductionRule do 
	it '#init' do
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

describe PseudoString do
	it '#apply_rule' do
		x = 'X'.nt
		a = 'a'.t
		ls = ps([x])
		rs = ps([a,a])
		rul = rule(ls,rs) 
		expect(ls.apply(rul).write).to eq "aa"
	end

	it 'eg2' do
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
