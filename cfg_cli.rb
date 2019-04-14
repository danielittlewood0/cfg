begin 
  config_file = File.readlines(ARGV[0]).each do |line|
    next if line =~ /\A(\s)*\z/ # skips blank lines
    cmd,args = line.split(' : ')
    raise "No command detected!" if cmd.nil?
    raise "No arguments detected!" if args.nil?
    puts cmd
    puts args
  end
rescue => e
  puts "ERROR!"
  puts e.message
end
