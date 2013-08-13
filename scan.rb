require 'socket'

class PortScan

  # Set up the parameters.
  def initialize(hostname, start_port, end_port)
    @hostname = hostname
    @port_range = start_port..end_port
    @time_to_wait_in_seconds = 3 # seconds
    run
  end

  def run
    open_sockets
    probe
  end
  
  def open_sockets
    # Create a socket for each port and initiate the nonblocking
    # connect.
    @sockets = @port_range.map do |port|
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
  hostname = ARGV[0]
  start_port = ARGV[1]
  end_port = ARGV[2]
  scan = PortScan.new hostname, start_port, end_port
end

main
