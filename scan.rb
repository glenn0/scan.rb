require './lib/port_scan'

require 'socket'
require 'pry'

def main
  run_scan = true
  hostname = ARGV[0]
  sanitised_ports = 
    if ARGV[1].include?(',')
      ARGV[1].split(',').map { |x| x.to_i }
    elsif ARGV[1].include?('-')
      range_ports = ARGV[1].split('-').map { |x| x.to_i }
      Range.new(range_ports[0], range_ports[1])
    elsif /^([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$/.match(ARGV[1])
      [ARGV[1].to_i]
    else
      puts "That port set looks funny. How about something like:"
      puts "80"
      puts "22,80,443"
      puts "100-200"
      run_scan = false
    end

  run_scan ? PortScan.new(hostname, sanitised_ports) : exit
end

main