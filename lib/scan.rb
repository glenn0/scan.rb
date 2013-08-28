class Scan

  def run(raw_host, raw_port_set)
    validate_ports(raw_port_set)
  end

  def validate_ports(raw_port_set)
    run_scan = true
    @valid_port_set = 
      if raw_port_set.include?(',')
        raw_port_set.split(',').map { |x| x.to_i }
      elsif raw_port_set.include?('-')
        range_ports = raw_port_set.split('-').map { |x| x.to_i }
        Range.new(range_ports[0], range_ports[1])
      elsif /^([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$/.match(raw_port_set)
        [raw_port_set.to_i]
      else
        puts "That port set looks funny. How about something like:"
        puts "80"
        puts "22,80,443"
        puts "100-200"
        run_scan = false
      end
    run_scan ? puts("Validation OK!") : puts("Validation FAIL!")
    #run_scan ? PortScan.new(hostname, sanitised_ports) : exit
  end
end

