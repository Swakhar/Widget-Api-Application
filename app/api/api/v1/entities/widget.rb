module API
  module V1
    module Entities
      class Widget < Entities::Base
        expose :id
        expose :name
        expose :description
        expose :kind
      end
    end
  end
end
