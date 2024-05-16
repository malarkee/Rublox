module Rublox
    class Token
        attributes = [:type, :lexeme, :literal, :line]
        attr_read *attributes

        def initialize(type, lexeme, literal, line)
            @type = type
            @lexeme = lexeme
            @literal = literal
            @line = line
        end

        def to_s
            "#{type} #{lexeme} #{literal}"
        end
    end
end