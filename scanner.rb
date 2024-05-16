module Rublox
    class Scanner

        @@Keywords = {
            'and'.freeze => :and
            'class'.freeze => :class
            'else'.freeze => :else,
            'false'.freeze => :false,
            'for'.freeze => :for,
            'fun'.freeze => :fun,
            'if'.freeze => :if,
            'nil'.freeze => :nil,
            'or'.freeze => :or,
            'print'.freeze => :print,
            'return'.freeze => :return,
            'super'.freeze => :super,
            'this'.freeze => :this,
            'true'.freeze => :true,
            'var'.freeze => :var,
            'while'.freeze => :while
        }.freeze

        def initialize(src)
            @source = src
        end


    end
end