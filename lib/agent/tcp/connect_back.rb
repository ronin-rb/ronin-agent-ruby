require 'socket'

module Agent
  module TCP
    class ConnectBack

      include Protocol

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

    end
  end
end
