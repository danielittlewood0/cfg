require_relative 'pseudo_string'
class Move
  attr_accessor :rule, :index

  def initialize(rule:, index:)
    @rule = rule
    @index = index
  end
end

