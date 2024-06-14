require_relative 'expr'

class Parser 
  class ParseError < RuntimeError
  end

  def initialize(tokens)
    @tokens = tokens
    @current = 0
  end

  def parse
    begin
      expression
    rescue ParseError
      nil
    end
  end

  # binary operations
  def expression
    equality
  end

  def equality
    expr = parse_helper(method(:comparison), :BANG_EQUAL, :EQUAL_EQUAL)
  end
  
  def comparison
    expr = parse_helper(method(:term), :GREATER, :GREATER_EQUAL, :LESS, :LESS_EQUAL)
  end

  def term
    expr = parse_helper(method(:factor), :PLUS, :MINUS)
  end

  def factor
    expr = parse_helper(method(:unary), :SLASH, :STAR)
  end

  # binary operator helper
  def parse_helper(func, *types)
    expr = func.call
    while match(*types)
      operator = previous
      right = func.call
      expr = Binary.new(expr, operator, right)
    end

    expr
  end

  # unary operators
  def unary
    if match(:BANG, :MINUS)
      operator = previous
      right = unary
      return Unary.new(operator, right)
    end

    primary
  end

  # primary expressions
  def primary
    return Literal.new(false) if match(:FALSE)
    return Literal.new(true) if match(:TRUE)
    return Literal.new(nil) if match(:NIL)
    return Literal.new(previous.literal) if match(:NUMBER, :STRING)
    
    if match(:LEFT_PAREN)
      expr = expression
      consume(:RIGHT_PAREN, "Expect ')' after expression.")
      return Grouping.new(expr)
    end

    raise error(peek, "Expect expression.")
  end

  # primitive operations
  def match(*types)
    types.each do |type|
      if check(type)
        advance
        return true
      end
    end

    false
  end

  def consume(type, message)
    return advance if check(type)
    raise error(peek, message)
  end

  def check(type)
    at_end? ? false : peek.type == type
  end

  def advance
    @current += 1 unless at_end?
    previous
  end

  def at_end?
    peek.type == :EOF
  end

  def peek
    @tokens[@current]
  end

  def previous
    @tokens[@current - 1]
  end

  def ParseError::error(token, message)
    parser_error(error, message)
    ParseError.new
  end

  def synchronize
    advance

    until at_end?
      return if previous.type == :SEMICOLON

      case peek.type
      when :CLASS, :FUN, :VAR, :FOR,
      :IF, :WHILE, :PRINT, :RETURN
        return
      end
      advance
    end
  end
end