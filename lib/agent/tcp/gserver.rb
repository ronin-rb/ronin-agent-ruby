require 'gserver'

module Agent
  module TCP
    class Server < GServer

      include Protocol

      def self.start(port,host=nil)
        server = new(port,host)

        trap('INT') { server.stop }
        
        server.start
        server.join
      end

    end
  end
end
