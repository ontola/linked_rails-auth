# frozen_string_literal: true

module LinkedRails
  module Auth
    module AuthHelper
      include Doorkeeper::Rails::Helpers
      include Doorkeeper::Helpers::Controller

      SAFE_METHODS = %w[GET HEAD OPTIONS CONNECT TRACE].freeze
      UNSAFE_METHODS = %w[POST PUT PATCH DELETE].freeze

      def current_user
        return @current_user if instance_variable_defined?(:@current_user)

        @current_user ||= current_resource_owner || create_guest_user

        handle_invalid_token unless valid_token?

        @current_user
      end

      private

      def create_guest_user
        LinkedRails.guest_user_class.new
      end

      def doorkeeper_scopes
        doorkeeper_token&.scopes || []
      end

      def doorkeeper_token_payload
        @doorkeeper_token_payload ||= JWT.decode(
          doorkeeper_token.token,
          Doorkeeper::JWT.configuration.secret_key,
          true,
          algorithms: %w[HS256 HS512]
        )[0]
      end

      def doorkeeper_unauthorized_render_options(error: nil)
        {
          json: {
            error: :invalid_token,
            error_description: error&.description
          }
        }
      end

      def generate_access_token(resource_owner)
        Doorkeeper::AccessToken.find_or_create_for(
          application: doorkeeper_token&.application,
          resource_owner: resource_owner,
          scopes: resource_owner.guest? ? :guest : :user,
          expires_in: Doorkeeper.configuration.access_token_expires_in,
          use_refresh_token: true
        )
      end

      def handle_invalid_token
        @current_user = create_guest_user
        update_oauth_token(generate_access_token(@current_user))
      end

      def sign_in(resource, *_args)
        @current_user = resource
        update_oauth_token(generate_access_token(resource))
        warden.set_user(resource, scope: :user, store: false) unless warden.user(:user) == resource
      end

      def sign_out(*args)
        super

        doorkeeper_token.revoke if doorkeeper_token&.resource_owner_id
        update_oauth_token(generate_access_token(create_guest_user))
      end

      def update_oauth_token(token)
        response.headers['New-Refresh-Token'] = token.refresh_token
        response.headers['New-Authorization'] = token.token
      end

      def require_doorkeeper_token?
        UNSAFE_METHODS.include?(request.method)
      end

      def valid_token?
        return !require_doorkeeper_token? if doorkeeper_token.blank?

        doorkeeper_token&.accessible?
      end
    end
  end
end
