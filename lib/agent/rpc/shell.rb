module Agent
  module RPC
    module Shell
      BLOCK_SIZE = 4096

      def self.shell; @shell ||= IO.popen(ENV['SHELL']); end

      def self.exec(program,*arguments)
        io = IO.popen("#{program} #{arguments.join(' ')}")

        self.processes[io.pid] = io
        return io.pid
      end

      def self.read(pid)
        process = self.process(pid)

        begin
          return process.read_nonblock(BLOCK_SIZE)
        rescue IO::WaitReadable
          return nil # no data currently available
        end
      end

      def self.write(pid,data)
        self.process(pid).write(data)
      end

      def self.close(pid)
        process = self.process(pid)
        process.close

        self.processes.delete(pid)
        return true
      end
    end
  end
end
