# frozen_string_literal: true

# Token class for Lox
class Token
  attributes = %i[type lexeme literal line]
  attr_reader(*attributes)

  def initialize(type, lexeme, literal, line_num)
    @type = type
    @lexeme = lexeme
    @literal = literal
    @line_num = line_num
  end

  def to_s
    "#{type} #{lexeme} #{literal}"
  end
end
