module LinkedRails
  module Auth
    module OtpHelper
      def handle_expired_session
        raise LinkedRails::Auth::Errors::Expired, I18n.t('messages.otp_secrets.expired')
      end

      def session_from_param
        return {} unless params[:session]

        @session_from_param ||= JWT.decode(
          session_param,
          Doorkeeper::JWT.configuration.secret_key,
          true,
          algorithms: [Doorkeeper::JWT.configuration.encryption_method.to_s.upcase]
        ).first || {}
      rescue JWT::ExpiredSignature
        handle_expired_session
      end

      def user_id_from_session
        session_from_param['user_id']
      end

      def user_id_from_session!
        user_id_from_session || raise(ActiveRecord::RecordNotFound)
      end

      def session_param
        params.require(:session)
      end
    end
  end
end
