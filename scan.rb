require 'socket'
require 'pry'

class PortScan

  # Set up the parameters.
  def initialize(hostname, sanitised_ports)
    @hostname = hostname
    @ports = sanitised_ports
    @time_to_wait_in_seconds = 3
    run
  end

  def run
    open_sockets
    probe
  end
  
  def open_sockets
    # Create a socket for each port and initiate the nonblocking
    # connect.
    @sockets = @ports.map do |port|
      socket = Socket.new(:INET, :STREAM)
      remote_addr = Socket.sockaddr_in(port, @hostname)

      begin
        socket.connect_nonblock(remote_addr)
      rescue Errno::EINPROGRESS
        # EINPROGRESS tells us that the connect cannot be completed immediately,
        # but is continuing in the background.
      end

      socket
    end
  end

  def probe
    # Set the expiration.
    expiration = Time.now + @time_to_wait_in_seconds

    loop do
      # We call IO.select and adjust the timeout each time so that we'll never
      # be waiting past the expiration.
      _, writable, _ = IO.select(nil, @sockets, nil, expiration - Time.now)
      break unless writable

      writable.each do |socket|
        begin
          socket.connect_nonblock(socket.remote_address)
        rescue Errno::EISCONN
          # EISCONN tells us that the socket is already connected. Count this as a success.
          puts "#{@hostname}:#{socket.remote_address.ip_port} accepts connections..."

          # Remove the socket from the array so it isn't selected multiple times.
          @sockets.delete(socket)
        rescue Errno::EINVAL
          @sockets.delete(socket)
        end
      end
    end
  end
end



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
