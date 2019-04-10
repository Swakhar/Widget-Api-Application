module API
  module V1
    module Entities
      class User < Entities::Base
        expose :id
        expose :email
      end
    end
  end
end
