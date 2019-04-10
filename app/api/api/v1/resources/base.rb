module API
  module V1
    module Resources
      class Base < Grape::API
        mount Resources::Users
        mount Resources::Widgets
      end
    end
  end
end
