module Agent
  module TCP
    module Protocol
      include Message

      protected

      def decode_request(request)
        super(request.chomp("\0"))
      end

      def encode_response(socket,message)
        socket.write(super(message) + "\0")
      end

      def serve(socket)
        loop do
          name, arguments = decode_request(socket.readline("\0"))

          encode_response(socket,RPC.call(name,arguments))
        end
      end
    end
  end
end
