module SpreeSpringboard
  module Resource
    class User < SpreeSpringboard::Resource::Base
      include SpreeSpringboard::Resource::Clients::UserClient

      def export_params(user)
        {
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email
        }
      end
    end
  end
end
