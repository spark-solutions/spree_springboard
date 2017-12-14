module SpreeSpringboard
  module Resource
    class Base
      attr_reader :errors

      def client(_resource)
        raise 'Implement `client` for each resource'
      end

      def client_resource(_resource)
        raise 'Implement `client_resource` for each resource'
      end

      def initialize
        @errors = []
      end
    end
  end
end
