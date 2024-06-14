# frozen_string_literal: true

require_relative 'token'

# Scanner class for Lox
class Scanner
  @@keywords = {
    'and' => :AND,
    'class' => :CLASS,
    'else' => :ELSE,
    'false' => :FALSE,
    'for' => :FOR,
    'fun' => :FUN,
    'if' => :IF,
    'nil' => :NIL,
    'or' => :OR,
    'print' => :PRINT,
    'return' => :RETURN,
    'super' => :SUPER,
    'this' => :THIS,
    'true' => :TRUE,
    'var' => :VAR,
    'while' => :WHILE
  }

  def initialize(source)
    @src = source
    @tokens = []
    @start = 0
    @current = 0
    @line_num = 1
  end

  # equivalent to scan_tokens in jlox
  def tokenize
    until at_end?
      @start = @current
      scan_token
    end
    @tokens.push(Token.new(:EOF, '', nil, @line_num))
  end

  # equivalent to scan_token in jlox
  def scan_token
    case c = advance
    when '(', ')', '{', '}', ',', '.', '-', '+', ';', '*'
      process_single_character_tokens(c)
    when '!', '=', '<', '>' 
      process_comparison_tokens(c)
    when '/' 
      process_slash
    when '"'
      process_string
    when /\d/
      process_number
    when /[a-zA-Z_]/
      process_identifier
    when "\n"
      @line_num += 1
    else error(@line_num, "Unexpected character: '#{c}'") unless c.match?(/\s/)
    end
  end

  def process_single_character_tokens(char)
    case char
    when '(' then add_token :LEFT_PAREN
    when ')' then add_token :RIGHT_PAREN
    when '{' then add_token :LEFT_BRACE
    when '}' then add_token :RIGHT_BRACE
    when ',' then add_token :COMMA
    when '.' then add_token :DOT
    when '-' then add_token :MINUS
    when '+' then add_token :PLUS
    when ';' then add_token :SEMICOLON
    when '*' then add_token :STAR
    end
  end

  def process_comparison_tokens(char)
    case char
    when '!' then add_token(match('=') ? :BANG_EQUAL : :BANG)
    when '=' then add_token(match('=') ? :EQUAL_EQUAL : :EQUAL)
    when '<' then add_token(match('=') ? :LESS_EQUAL : :LESS)
    when '>' then add_token(match('=') ? :GREATER_EQUAL : :GREATER)
    end
  end

  def process_slash
    if match '/'    # single-line comments
      advance until peek == "\n" || at_end?
    elsif match '*' # multi-line comments
      count = 1
      until count.zero? || at_end? do
        count += 1 if peek == '/' && peek_next == '*'
        count -= 1 if peek == '*' && peek_next == '/'
        advance
      end
      2.times { advance }
    else
      add_token :SLASH
    end
  end

  def process_string
    until peek == '"' || at_end?
      @line_num += 1 if peek == "\n"
      advance
    end

    return error(@line_num, 'Unterminated string.') if at_end?

    advance
    value = @src[(@start + 1)...(@current - 1)]
    add_token(:STRING, value)
  end

  def process_number
    advance while peek&.match?(/\d/)
    if peek == '.' && peek_next.match?(/\d/)
      advance # consume the '.'
      advance while peek.match?(/\d/)
    end
    
    add_token(:NUMBER, @src[@start, @current].to_f)
  end

  def process_identifier
    advance while peek&.match?(/\w/)
    
    text = @src[@start...@current]
    type = @@keywords[text]
    type = :IDENTIFIER if type.nil?

    add_token(type)
  end

  def match(expected)
    return false if peek != expected

    @current += 1
    true
  end

  def add_token(type, literal = nil)
    text = @src[@start...@current]
    @tokens.push(Token.new(type, text, literal, @line_num))
  end

  # helper methods
  def at_end?(pos = @current)
    pos >= @src.size
  end

  def peek
    at_end? ? nil : @src[@current]
  end

  def peek_next
    at_end?(@current + 1) ? nil : @src[@current + 1]
  end

  def advance
    @current += 1
    next_char = @src[@current - 1]
  end
end
