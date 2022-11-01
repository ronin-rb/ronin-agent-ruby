require 'socket'

module Agent
  module Transports
    class HTTP

      include Message

      attr_reader :host, :port, :local_host, :local_port

      def initialize(host,port,local_host=nil,local_port=nil)
        @host       = host
        @port       = port
        @local_host = local_host
        @local_port = local_port
      end

      def self.start(host,port,local_host=nil,local_port=nil)
        client = new(host,port,local_host,local_port)

        trap('INT') { client.stop }

        client.start
      end

      def start
        @connection = TCPSocket.new(@host,@port,@local_host,@local_port)

        serve(@connection)
      end

      def stop; @connection.close; end

      def serve(socket)
        loop do
          name, arguments = decode_request(socket.readline("\0"))

          encode_response(socket,RPC.call(name,arguments))
        end
      end

      def decode_request(request)
        super(request.chomp("\0"))
      end

      def encode_response(socket,message)
        socket.write(super(message) + "\0")
      end
    end
  end
end
