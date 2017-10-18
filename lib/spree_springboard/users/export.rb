module SpreeSpringboard
  module Users
    class Export < SpreeSpringboard::Resources::Export
      def client(user)
        user.springboard_id ? client_update(user) : client_create
      end

      def client_update(user)
        SpreeSpringboard.client["customers/#{user.springboard_id}"]
      end

      def client_create
        SpreeSpringboard.client["customers"]
      end

      def export_params(user)
        export_params_base(user).merge!
        {
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email
        }
      end
    end
  end
end
