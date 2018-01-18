module SpreeSpringboard
  module Resource
    module Export
      class User < SpreeSpringboard::Resource::Export::Base
        include SpreeSpringboard::Resource::Clients::UserClient

        def export_params(user, params = {})
          {
            first_name: user.firstname.blank? ? params[:first_name] : user.firstname,
            last_name: user.lastname.blank? ? params[:last_name] : user.lastname,
            email: user.email
          }
        end
      end
    end
  end
end
