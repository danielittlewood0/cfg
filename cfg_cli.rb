require './lib/context_free_grammar.rb'
cfg = ContextFreeGrammar.new

begin 
  raise "Please provide a configuration file." if ARGV[0].nil?
  config_file = File.readlines(ARGV[0]).each do |line|
    next if line =~ /\A(\s)*\z/ # skips blank lines
    cmd,args = line.chomp.split(/\s*:\s*/)
    raise "No command detected!" if cmd.nil?
    raise "No arguments detected!" if args.nil?
    cfg.execute!(cmd,args)
  end

  puts "The non-terminal symbols are: " + cfg.non_terminals.map(&:to_s).to_s
  puts "The terminal symbols are: " + cfg.terminals.map(&:to_s).to_s
  puts "The start symbol is: " + cfg.start_sym.to_s
  puts "The rules are: "
  puts cfg.rules
rescue => e
  puts "ERROR!"
  puts e.message
end

loop do
  puts "What word would you like to parse?"
  word = $stdin.gets.chomp
  puts "OK, parsing \"#{word}\"..."
  puts cfg.parse(word)
  puts word
end
