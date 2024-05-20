# frozen_string_literal: true

def define_ast(output_dir, base_name, types)
  path = "#{output_dir}/#{base_name}.rb"
  open('expr.rb', 'w') do |f|
    
    f.puts '# frozen_string_literal: true'
    f.puts
    define_visitor(f, base_name, types)
    f.puts "class #{base_name.capitalize}"
    f.puts 'end'

    types.each do |type|
      class_name, fields = type.split(':', 2).collect { |s| s.strip }
      define_type(f, base_name, class_name, fields)
    end
  end
end

def define_type(f, base_name, class_name, field_list)
  f.puts
  f.puts "class #{class_name} < #{base_name.capitalize}"
  f.puts "  def initialize(#{field_list})"
  
  fields = field_list.split(', ')
  fields.each {|field| f.puts "    @#{field} = #{field}"}
  f.puts '  end'
  f.puts

  f.puts '  def accept(visitor)'
  f.puts "    visitor.visit_#{class_name.downcase}_#{base_name.downcase}(self)"
  f.puts '  end'
  f.puts 'end'
end

def define_visitor(f, base_name, types)
  f.puts 'class Visitor'
  types.each do |type|
    type_name = type.split(':')[0].strip
    f.puts "  def visit_#{type_name.downcase}_#{base_name.downcase}(*)"
    f.puts "  end"
    f.puts unless type == types.last
  end
  f.puts 'end'
  f.puts
end

if ARGV.size != 1
  STDERR.puts("Usage: generateAst <output directory>")
  exit 64
end

output_dir = ARGV[0]
define_ast(output_dir, 'Expr', [
  'Binary : left, operator, right',
  'Grouping : expression',
  'Literal : value',
  'Unary : operator, right'
])