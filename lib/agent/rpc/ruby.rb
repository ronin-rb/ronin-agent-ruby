Main = self

module Agent
  module RPC
    module Ruby
      def self.eval(code); Main.eval(code); end
      def self.define(name,args,code)
        module_eval %{
        def self.#{name}(#{args.join(',')})
          #{code}
        end
        }
        return true
      end

      def self.version;  RUBY_VERSION;  end
      def self.platform; RUBY_PLATFORM; end
      def self.engine
        if Object.const_defined?('RUBY_ENGINE')
          Object.const_get('RUBY_ENGINE')
        end
      end
    end
  end
end
