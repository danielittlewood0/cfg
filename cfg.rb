$non_terminals = ('A'..'Z').to_a
$terminals = ('a'..'z').to_a

def rule(lhs,rhs)
  return Rule.new(lhs,rhs)
end

class Rule
  attr_accessor :lhs, :rhs

  def initialize(lhs,rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def valid?(terminals,non_terminals)
    unless non_terminals.include?(lhs)
      raise "lhs #{lhs} is not a non_terminal!"
    end
    unless rhs.is_a?(String)
      raise "rhs #{rhs} is not a string!"
    end
    list = rhs.split('')
    list.each do |char|
      unless (non_terminals.include?(char) or terminals.include?(char))
        raise "#{char} in rhs is not valid!"
      end
    end
  end
end

class ContextFreeGrammar
  attr_accessor :non_terminals, :terminals, :start, :rules
  def initialize(terminals,non_terminals,start,rules)
    unless non_terminals.all?{|term| ('A'..'Z').to_a.include?(term)}
      raise 'not all non_terminals are capital characters!'
    end
    unless ('A'..'Z').to_a.include?(start)
      raise "start variable #{start} is not a capital character!"
    end
    unless terminals.all?{|term| ('a'..'z').to_a.include?(term)}
      raise 'not all terminals are lower case characters!'
    end
    @non_terminals = (non_terminals + [start]).uniq
    @terminals = terminals.uniq
    @start = start
    rules.each do |rule|
      unless rule.valid?(terminals,non_terminals)
        raise "rule #{rule} is not valid"
      end
    end
    @rules = rules
  end
end

class String
  def apply_first(rule)
    return self.sub(rule.lhs,rule.rhs)
  end
  def apply_with_input(rule)
    chars = self.split('')
    list = []
    chars.each_with_index do |char,j|
      if char == rule.lhs
        list << j
      end
    end
    puts "There are #{list.length} occurences of the lhs #{rule.lhs}. "\
    "Which one would you like to replace?"
    instance = gets.chomp.to_i - 1
    if instance >= 0
      index_to_replace = list[instance]
      chars[index_to_replace] = rule.rhs
    end
    puts chars.join('')
    return chars.join('')
  end
end

# puts "SSS".apply_with_input(rule('S','AA'))
[rule('S','AA'),rule('S','AA'),rule('S','AA')].inject("SSS"){|str,rule| str.apply_with_input(rule)}
