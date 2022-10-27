require 'fileutils'

module Agent
  module RPC
    module Fs
      extend FileUtils

      BLOCK_SIZE = 4096

      def self.open(path,mode); File.new(path,mode).fileno; end

      def self.read(fd,position)
        file = File.for_fd(fd)
        file.seek(position)

        return (file.read(BLOCK_SIZE) || '')
      end

      def self.write(fd,position,data)
        file = File.for_fd(fd)
        file.seek(position)

        return file.write(data)
      end

      def self.seek(fd,position)
        file = File.for_fd(fd)
        file.seek(position)

        return file.pos
      end

      def self.close(fd); file = File.for_fd(fd).close; end

      def self.getcwd;                   Dir.pwd;                            end
      def self.readlink(path);           File.readlink(path);                end
      def self.readdir(path);            Dir.entries(path);                  end
      def self.glob(pattern);            Dir.glob(pattern);                  end
      def self.mktemp(basename);         Tempfile.new(basename).path;        end
      def self.unlink(path);             File.unlink(path);                  end
      def self.chown(user,path);         FileUtils.chown(user,nil,path);     end
      def self.chgrp(group,path);        FileUtils.chown(nil,group,path);    end
      def self.stat(path);               File.stat(path);                    end
      def self.compare(path,other_path); File.compare_file(path,other_path); end    end
  end
end
