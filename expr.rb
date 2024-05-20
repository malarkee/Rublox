# frozen_string_literal: true

class Visitor
  def visit_binary_expr(*)
  end

  def visit_grouping_expr(*)
  end

  def visit_literal_expr(*)
  end

  def visit_unary_expr(*)
  end
end

class Expr
end

class Binary < Expr
  def initialize(left, operator, right)
    @left = left
    @operator = operator
    @right = right
  end

  def accept(visitor)
    visitor.visit_binary_expr(self)
  end
end

class Grouping < Expr
  def initialize(expression)
    @expression = expression
  end

  def accept(visitor)
    visitor.visit_grouping_expr(self)
  end
end

class Literal < Expr
  def initialize(value)
    @value = value
  end

  def accept(visitor)
    visitor.visit_literal_expr(self)
  end
end

class Unary < Expr
  def initialize(operator, right)
    @operator = operator
    @right = right
  end

  def accept(visitor)
    visitor.visit_unary_expr(self)
  end
end
