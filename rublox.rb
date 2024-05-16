module Rublox
    class Lox

        @@had_error = false

        def run_file(path)
            run IO.read(path)
            if @@had_error do exit(65); end
        end

        def run_prompt
            loop do
                print "> "
                line = gets
                run line
                @@had_error = false
            end
        end

        def run(line)
            puts line
        end

        def error(line_num, message)
            report(line_num, "", message)
        end
        
        def report
            puts "[line " + line_num + "] Error " + where + ": " + message
            hadError = true
        end

    end
end

if ARGV.size > 1
    STDERR.puts "Usage: jlox [script]"
    exit 64
elsif ARGV.size == 1
    Rublox::Lox.run_file ARGV[0]
else
    Rublox::Lox.run_prompt
end