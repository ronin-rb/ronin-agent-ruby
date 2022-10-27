require 'webrick'

module Agent
  module HTTP
    class Server < WEBrick::HTTPServlet::AbstractServlet

      include Message

      def self.start(port,host=nil)
        server = WEBrick::HTTPServer.new(:Host => host, :Port => port)
        server.mount '/', self

        trap('INT') { server.shutdown }

        server.start
      end

      def do_GET(request,response)
        p request.query_string

        name, arguments = decode_request(request.query['_request'])

        encode_response(response,RPC.call(name,arguments))
      end

      protected

      def encode_response(response,message)
        response.status = (message.has_key?('exception') ? 404 : 200)
        response.body   = super(message)
      end

    end
  end
end
