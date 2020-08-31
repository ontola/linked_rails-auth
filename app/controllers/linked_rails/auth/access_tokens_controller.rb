# frozen_string_literal: true

module LinkedRails
  module Auth
    class AccessTokensController < Doorkeeper::TokensController
      def create
        headers.merge!(authorize_response.headers)

        update_oauth_token(authorize_response.token) if authorize_response.status == :ok

        render json: authorize_response.body, status: authorize_response.status
      rescue Doorkeeper::Errors::DoorkeeperError => e
        handle_token_exception(e)
      end

      private

      def handle_token_exception(exception)
        active_response_block do
          case active_response_type
          when :json
            handle_token_exception_json(exception)
          else
            respond_with_invalid_resource(resource: token_with_errors(exception))
          end
        end
      end

      def handle_token_exception_json(exception) # rubocop:disable Metrics/AbcSize
        error = get_error_response_from_exception(exception)
        headers.merge!(error.headers)
        Bugsnag.notify(exception)
        Rails.logger.info(error.body.merge(code: error_id(exception)).to_json)
        self.response_body = error.body.merge(code: error_id(exception)).to_json
        self.status = error.status
      end

      def raise_login_error(request) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        raise(
          if LinkedRails.user_class.find_by(email: request.params[:user][:email]).nil?
            LinkedRails::Errors::UnknownEmail.new
          elsif request.env['warden'].message == :invalid
            LinkedRails::Errors::WrongPassword.new
          elsif request.env['warden'].message == :not_found_in_database
            LinkedRails::Errors::WrongPassword.new
          else
            "unhandled login state #{request.env['warden'].message}"
          end
        )
      end

      def token_with_errors(exception)
        token_with_errors = AccessToken.new
        field = [Errors::WrongPassword].include?(exception.class) ? :password : :email
        token_with_errors.errors.add(field, exception.message)
        token_with_errors
      end

      class << self
        def controller_class
          LinkedRails.access_token_class
        end
      end
    end
  end
end
