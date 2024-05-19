# frozen_string_literal: true

require_relative 'scanner'

@had_error = true

def self.main(args, argc)
  if argc > 1
    $stderr.puts 'Usage: rublox [script]'
    exit 64
  elsif argc == 1
    run_file args[0]
  else
    run_prompt
  end
end

def run_file(path)
  run File.read(path)
  exit 65 if hadError
end

def run_prompt
  loop do
    print '> '
    break if (line = gets).nil?

    run line
    @had_error = false
  end
end

def run(src)
  scanner = Scanner.new(src)
  tokens = scanner.tokenize
  tokens.each do |t|
    puts t
  end
end

def error(line_num, message)
  report(line_num, '', message)
end

def report(line_num, where, message)
  puts "[line #{line_num}] Error #{where}: #{message}"
  @had_error = true
end

main(ARGV, ARGV.size)
