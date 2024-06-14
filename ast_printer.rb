require_relative 'token'
require_relative 'expr'

class AstPrinter < Visitor
  def print(expr)
    expr.accept(self)
  end

  def visit_binary_expr(expr)
    parenthesize(expr.operator.lexeme, expr.left, expr.right)
  end

  def visit_grouping_expr(expr)
    parenthesize('group', expr.expression)
  end

  def visit_literal_expr(expr)
    expr.value.nil? ? 'nil' : expr.value.to_s
  end

  def visit_unary_expr(expr)
    parenthesize(expr.operator.lexeme, expr.right)
  end

  def parenthesize(name, *exprs)
    str = "(#{name}"
    exprs.each do |expr|
      str += ' '
      str += expr.accept(self)
    end
    str += ')'
  end
end

# test ast_printer
# expression = Grouping.new (
#   Binary.new(
#     Binary.new(
#       Literal.new(1),
#       Token.new(:PLUS, '+', nil, 1),
#       Literal.new(2)
#     ),
#     Token.new(:STAR, '*', nil, 1),
#     Binary.new(
#       Literal.new(4),
#       Token.new(:MINUS, '-', nil, 4),
#       Literal.new(3)
#     )
#   )
# )

# print AstPrinter.new.print expression
