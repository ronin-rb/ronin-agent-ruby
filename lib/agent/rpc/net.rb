require 'socket'
require 'resolv'

module Agent
  module RPC
    module Net
      def self.sockets; @sockets ||= {}; end
      def self.socket(fd)
        unless (socket = sockets[fd])
          raise(RuntimeError,"unknown socket file-descriptor",caller)
        end

        return socket
      end

      module Dns
        def self.lookup(host)
          Resolv.getaddresses(host)
        end

        def self.reverse_lookup(ip)
          Resolv.getnames(host)
        end
      end

      module Tcp
        def self.connect(host,port,local_host=nil,local_port=nil)
          socket = TCPSocket.new(host,port,local_host,local_port)

          Net.sockets[socket.fileno] = socket
          return socket.fileno
        end

        def self.listen(port,host=nil)
          socket = TCPServer.new(port,host)
          socket.listen(256)

          Net.sockets[socket.fileno] = socket
          return socket.fileno
        end

        def self.accept(fd)
          socket = Net.socket(fd)

          begin
            client = socket.accept_nonblock
          rescue IO::WaitReadable, Errno::EINTR
            return nil
          end

          Net.sockets[client.fileno] = client
          return client.fileno
        end

        def self.recv(fd)
          socket = Net.socket(fd)

          begin
            return socket.recv_nonblock(BLOCK_SIZE)
          rescue IO::WaitReadable
            return nil
          end
        end

        def self.send(fd,data)
          Net.socket(fd).send(data)
        end
      end

      module Udp
        def self.connect(host,port,local_host=nil,local_port=nil)
          socket = UDPSocket.new(host,port,local_host,local_port)

          Net.sockets[socket.fileno] = socket
          return socket.fileno
        end

        def self.listen(port,host=nil)
          socket = UDPServer.new(port,host)

          Net.sockets[socket.fileno] = socket
          return socket.fileno
        end

        def self.recv(fd)
          socket = Net.socket(fd)

          begin
            return socket.recvfrom_nonblock(BLOCK_SIZE)
          rescue IO::WaitReadable
            return nil
          end
        end

        def self.send(fd,data,host=nil,port=nil)
          socket = Net.socket(fd)

          if (host && port)
            return socket.send(data,0,host,port)
          else
            return socket.send(data)
          end
        end
      end

      def self.remote_address(fd)
        socket   = self.socket(fd)
        addrinfo = socket.remote_address

        return [addrinfo.ip_address, addrinfo.ip_port]
      end

      def self.local_address(fd)
        socket   = self.socket(fd)
        addrinfo = socket.local_address

        return [addrinfo.ip_address, addrinfo.ip_port]
      end

      def self.close(fd)
        socket = self.socket(fd)
        socket.close

        self.sockets.delete(fd)
        return true
      end
    end
  end
end
