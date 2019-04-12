require 'doorkeeper/grape/helpers'

module API
  class Dispatch < Grape::API
    helpers Doorkeeper::Grape::Helpers
    format :json

    version 'v1', using: :path

    before do
      authorize_client_credential!
    end

    helpers do
      def permitted_params
        declared(params, include_missing: false)
      end

      def current_user
        @current_user ||= User.find(doorkeeper_token[:resource_owner_id])
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
      end

      def authorize_client_credential!
        return if doorkeeper_token.present?

        uid = params[:client_id]
        secret = params[:client_secret]

        return if Doorkeeper::Application.by_uid_and_secret(uid, secret)
        error_description = 'Invalid Credential'
        error!({ error: error_description, status: 412 }, 412)
      end

      def current_ability
        @current_ability ||= ::Ability.new(current_user)
      end

      def authorize!(*args)
        current_ability.authorize!(*args)
      end
    end

    rescue_from ::CanCan::AccessDenied do
      error!('403 Forbidden', 403)
    end

    include API::ExceptionHandling

    mount API::V1::Resources::Base

    route :any, '*path' do
      error!({ error: 'Not Found', details: "No such route '#{request.path}'", status: 404 }, 404)
    end
  end
end
