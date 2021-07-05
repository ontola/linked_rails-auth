# frozen_string_literal: true

module LinkedRails
  module Auth
    class AccessTokensController < Doorkeeper::TokensController # rubocop:disable Metrics/ClassLength
      def create
        headers.merge!(authorize_response.headers)

        create_success_effects if authorize_response.status == :ok

        render json: authorize_response.body, status: authorize_response.status
      rescue Doorkeeper::Errors::DoorkeeperError => e
        handle_token_exception(e)
      end

      private

      def create_success_effects
        if enter_otp? && !strategy.is_a?(Doorkeeper::Request::RefreshToken)
          redirect_to_otp_attempt
        elsif !otp_activated? && otp_setup_required? && !strategy.is_a?(Doorkeeper::Request::RefreshToken)
          redirect_to_otp_secret
        else
          handle_new_token
        end
      end

      def enter_otp?
        otp_activated?
      end

      def handle_new_token
        update_oauth_token(authorize_response.token)
        response.headers['Location'] = redirect_url_param if redirect_url_param
      end

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

      def otp_activated?
        @otp_activated ||=
          LinkedRails.otp_secret_class.exists?(
            user_id: authorize_response.token.resource_owner_id,
            active: true
          )
      end

      def otp_attempt_form_iri
        LinkedRails.iri(path: 'u/otp_attempt/new', query: {session: session_param}.to_param)
      end

      def otp_secret_form_iri
        LinkedRails.iri(path: 'u/otp_secret/new', query: {session: session_param}.to_param)
      end

      def otp_setup_required?
        false
      end

      def redirect_to_otp_attempt
        response.headers['Location'] = otp_attempt_form_iri.to_s
        @authorize_response = Doorkeeper::OAuth::TokenResponse.new(Doorkeeper::AccessToken.new)
      end

      def redirect_to_otp_secret
        response.headers['Location'] = otp_secret_form_iri.to_s
        @authorize_response = Doorkeeper::OAuth::TokenResponse.new(Doorkeeper::AccessToken.new)
      end

      def session_param
        sign_payload(
          exp: 10.minutes.from_now.to_i,
          user_id: authorize_response.token.resource_owner_id,
          redirect_uri: redirect_url_param
        )
      end

      def sign_payload(payload)
        JWT.encode(
          payload,
          Doorkeeper::JWT.configuration.secret_key,
          Doorkeeper::JWT.configuration.encryption_method.to_s.upcase
        )
      end

      def raise_login_error(request) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        raise(
          if LinkedRails.user_class.find_by(email: request.params[:user][:email]).nil?
            LinkedRails::Auth::Errors::UnknownEmail.new
          elsif request.env['warden'].message == :invalid
            LinkedRails::Auth::Errors::WrongPassword.new
          elsif request.env['warden'].message == :not_found_in_database
            LinkedRails::Auth::Errors::WrongPassword.new
          else
            "unhandled login state #{request.env['warden'].message}"
          end
        )
      end

      def redirect_url_param
        params[:access_token].try(:[], :redirect_url) || params[:redirect_url]
      end

      def token_with_errors(exception)
        token_with_errors = AccessToken.new
        field = [LinkedRails::Auth::Errors::WrongPassword].include?(exception.class) ? :password : :email
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
