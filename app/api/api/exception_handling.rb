module API
  module ExceptionHandling
    extend ActiveSupport::Concern

    included do
      rescue_from Grape::Exceptions::ValidationErrors do |e|
        errors = {}
        e.errors.each do |keys, values|
          keys.each do |key|
            errors[key] ||= []
            errors[key].concat values.map(&:to_s)
          end
        end

        response = { status: 422, message: e.message, errors: errors }
        rack_response response.to_json, 422
      end

      rescue_from ActiveRecord::RecordInvalid do |error|
        rack_response({
                          'status' => 422,
                          'message' => error.record.errors.full_messages.to_sentence,
                          'errors' => error.record.errors,
                      }.to_json, 422)
      end

      rescue_from ActiveRecord::RecordNotFound do
        rack_response({
                          'status' => 404,
                      }.to_json, 404)
      end
    end
  end
end
