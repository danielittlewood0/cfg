class NonTerminal < String

end

class Terminal < String

end

class StartSymbol < NonTerminal

end


def nonterm(str)
  NonTerminal.new(str)
end

def term(str)
  Terminal.new(str)
end

def start(str)
  StartSymbol.new(str)
end
