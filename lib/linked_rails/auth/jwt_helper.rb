# frozen_string_literal: true

module LinkedRails
  module Auth
    module JWTHelper
      module_function

      def sign_payload(payload, secret: ENV['JWT_ENCRYPTION_TOKEN'])
        JWT.encode payload, secret, 'HS512'
      end

      def decode_token(token, secret: ENV['JWT_ENCRYPTION_TOKEN'], verify: true)
        JWT.decode(token, secret, verify, algorithms: %w[HS256 HS512])[0]
      end
    end
  end
end
