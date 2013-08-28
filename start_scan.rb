require './lib/scan.rb'

raw_host = ARGV[0]
raw_port_set = ARGV[1]

scan = Scan.new
scan.run(raw_host, raw_port_set)