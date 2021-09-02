# frozen_string_literal: true

module LinkedRails
  module Auth
    module OtpHelper
      def handle_expired_session
        raise LinkedRails::Auth::Errors::Expired, I18n.t('actions.otp_secrets.errors.expired')
      end

      def session_from_param(session_param)
        return {} unless session_param

        JWT.decode(
          session_param,
          Doorkeeper::JWT.configuration.secret_key,
          true,
          algorithms: [Doorkeeper::JWT.configuration.encryption_method.to_s.upcase]
        ).first || {}
      rescue JWT::ExpiredSignature
        handle_expired_session
      end

      def owner_from_session(session_param)
        user_id = session_from_param(session_param)['user_id']

        LinkedRails.otp_owner_class.find_by(id: user_id) if user_id
      end
    end
  end
end
