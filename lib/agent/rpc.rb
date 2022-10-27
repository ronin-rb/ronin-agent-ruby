module Agent
  module RPC
    def self.[](name)
      names       = name.split('.')
      method_name = names.pop
      scope       = RPC

      return if method_name.nil?

      names.each do |name|
        scope = begin
                  scope.const_get(name.capitalize)
                rescue NameError
                end

        return if scope.nil?
      end

      begin
        scope.method(method_name)
      rescue NameError
      end
    end

    def self.call(name,arguments)
      unless (method = self[name])
        return {'exception' => "Unknown method: #{name}"}
      end

      value = begin
                method.call(*arguments)
              rescue => exception
                return {'exception' => exception.message}
              end

      return {'return' => value}
    end
  end
end
