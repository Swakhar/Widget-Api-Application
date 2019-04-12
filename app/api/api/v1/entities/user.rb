module API
  module V1
    module Entities
      class User < Entities::Base
        expose :id
        expose :email
        expose :username
      end
    end
  end
end
