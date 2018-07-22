class Terminal 
	attr_accessor :char

	def initialize(char)
		@char = char
	end

	def ==(other)
		self.char == other.char
	end

end

class NonTerminal 
	attr_accessor :char

	def initialize(char)
		@char = char
	end

	def ==(other)
		self.char == other.char
	end

end

class String 
	def to_pseudo(non_terms,terms) 
		chars = self.split('')
		new_chars = []
		chars.each do |c| 
			if non_terms.include?(c)
				new_chars << NonTerminal.new(c)
			elsif terms.include?(c)
				new_chars << Terminal.new(c)
			end
		end
		return ps(new_chars)
	end

	def nt
		NonTerminal.new(self)
	end

	def t
		Terminal.new(self)
	end

end

class PseudoString 
	attr_accessor :chars 

	def initialize(chars)
		@chars = chars
	end

	def write
		@chars.map{|c| c.char}.join('')
	end	

  def ==(other)
    self.write == other.write
  end

	def apply(rule)
		i = self.chars.index(rule.ls.chars.first)
    if i.nil?
      return self
    else
      new_chars = chars[0...i] + rule.rs.chars + chars[i+1..-1]
      return ps(new_chars)		
    end
	end
end

class ProductionRule 
	attr_accessor :ls,:rs 

	def initialize(ls,rs)
		@ls = ls
		@rs = rs 
	end
end

def rule(ls,rs) 
	ProductionRule.new(ls,rs) 
end


def ps(chars)
	PseudoString.new(chars) 
end
